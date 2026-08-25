import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myrideuser/app/modules/Deshboard/finding_driver_view.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/app/modules/Deshboard/completed_ride_sheet.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/controller/chat_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/modal/driveravailable_model.dart';
import 'package:myrideuser/data/modal/trackride_model.dart';
import 'package:myrideuser/data/services/nearby_drivers_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myrideuser/widgets/custom_loader.dart';
import 'package:myrideuser/widgets/price_breakdown_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class FindingDriverUI extends StatefulWidget {
  final String booking_id;
  FindingDriverUI({super.key, required this.booking_id});

  @override
  State<FindingDriverUI> createState() => _FindingDriverUIState();
}

class _FindingDriverUIState extends State<FindingDriverUI> {
  Timer? _timer;
  bool _isNavigating = false;
  bool addressLoaded = false;
  bool _isChatOpening = false;

  /// The booking's drop-off, remembered when the pins are first placed so the
  /// route and camera can switch to it once the ride is under way.
  LatLng? _dropLatLng;

  /// Whether the camera should keep following the driver.
  ///
  /// Every driver location update used to re-centre the map unconditionally,
  /// so a rider who dragged the map to look around was pulled straight back
  /// within a second or two and effectively could not pan at all. Panning now
  /// hands control to the rider and follow resumes on its own after
  /// [_refollowDelay] — no button to find, and no fighting the map.
  bool _followMode = true;

  /// Distinguishes our own animateCamera calls from a real finger drag, since
  /// onCameraMoveStarted fires for both.
  bool _programmaticCameraMove = false;

  Timer? _refollowTimer;
  static const Duration _refollowDelay = Duration(seconds: 8);

  /// Called when the rider drags the map: stop following, and start the clock
  /// on resuming.
  void _onUserPannedMap() {
    _refollowTimer?.cancel();
    if (_followMode && mounted) setState(() => _followMode = false);
    _refollowTimer = Timer(_refollowDelay, () {
      if (!mounted) return;
      setState(() => _followMode = true);
      _recentreOnRide();
    });
  }

  /// Frames whatever matters at this point in the ride: the driver on their
  /// way in, or the road ahead once the rider is aboard.
  void _recentreOnRide() {
    // This — and the WidgetsBinding.instance.addPostFrameCallback() calls
    // that lead into it from updateDriverLocation() below — can still fire
    // a frame after this screen has already been popped: payment
    // confirming (PaymentController._onPaid → Get.offAll(TripCompletedScreen))
    // can land in the same instant a GetBuilder rebuild here schedules one
    // of those callbacks, and addPostFrameCallback runs regardless of
    // whether the widget that scheduled it is still mounted. mapController
    // itself is still non-null at that point (dispose() never clears it),
    // so the null check alone let this reach a GoogleMapController whose
    // underlying native view had already been torn down — "GoogleMapController
    // ... used after the associated GoogleMap widget had already been
    // disposed."
    if (!mounted || mapController == null) return;
    final target = _isRideUnderway ? (_dropLatLng ?? driverLocation) : driverLocation;
    if (target == null) return;
    _programmaticCameraMove = true;
    // mounted is still no absolute guarantee — the platform channel can
    // tear the native view down in a narrower window than Flutter's own
    // mounted flag flips in. A stray StateError from this specific call is
    // a lost camera animation on a screen that's on its way out anyway, so
    // swallowing it here is strictly safer than letting it crash the app.
    try {
      mapController?.animateCamera(CameraUpdate.newLatLng(target));
    } catch (e) {
      debugPrint('[FindingDriver] animateCamera after dispose: $e');
    }
  }

  /// True once the rider is in the car, when the journey being shown stops
  /// being "driver coming to me" and becomes "us going to the destination".
  bool get _isRideUnderway =>
      Get.find<BookingController>().rideStatus.value.toLowerCase() == 'ongoing';

  Future<void> loadCarIcon() async {
    carIcon = await getCustomMarker();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    /// First API hit immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hitApi();
    });

    loadCarIcon();

    /// Start continuous polling
    startPolling();
    // getCurrentLocation();
  }

  void startPolling() {
    _timer?.cancel(); // avoid duplicate timer

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      _hitApi();
    });
  }

  void _hitApi() {
    Get.find<BookingController>().TrackRideApi2(
      context: context,
      bookingid: widget.booking_id,
    );
    Get.find<BookingController>().TripRideDetailsApi(
      context: context,
      bookingid: widget.booking_id,
    );

    log("API HIT AGAIN");
  }

  @override
  void dispose() {
    _timer?.cancel();
    _refollowTimer?.cancel();
    super.dispose();
  }

  BitmapDescriptor? carIcon;

  Future<BitmapDescriptor> getCustomMarker() async {
    ByteData data = await rootBundle.load('assets/images/ridecar.png');

    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 20, // size chhota karo
    );

    ui.FrameInfo fi = await codec.getNextFrame();

    ByteData? resizedData = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.bytes(resizedData!.buffer.asUint8List());
  }

  String pickupAddress = "";
  String dropAddress = "";
  Future<void> getAddress(
    dynamic pickuplat,
    dynamic picklong,
    dynamic droplat,
    dynamic droplong,
  ) async {
    final pickupLat = _coordinate(pickuplat);
    final pickupLng = _coordinate(picklong);
    final dropLat = _coordinate(droplat);
    final dropLng = _coordinate(droplong);
    if (pickupLat == null ||
        pickupLng == null ||
        dropLat == null ||
        dropLng == null) {
      return;
    }

    String formatAddress(Placemark place) {
      return [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((e) => e != null && e!.isNotEmpty).join(", ");
    }

    try {
      final addresses = await Future.wait([
        placemarkFromCoordinates(pickupLat, pickupLng),
        placemarkFromCoordinates(dropLat, dropLng),
      ]);
      if (!mounted) return;

      final pickup = addresses[0];
      final drop = addresses[1];
      setState(() {
        if (pickup.isNotEmpty) pickupAddress = formatAddress(pickup.first);
        if (drop.isNotEmpty) dropAddress = formatAddress(drop.first);
      });
    } catch (error) {
      // The API-provided address remains visible if reverse geocoding fails.
      log('Could not resolve ride addresses: $error');
    }
  }

  String _bookingAddress(
    Map<dynamic, dynamic> booking,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final rawValue = booking[key];
      final value = rawValue is Map
          ? rawValue['address']?.toString().trim() ?? ''
          : rawValue?.toString().trim() ?? '';
      if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
    }
    return fallback;
  }

  Future<void> _loadBookingAddresses(Map<dynamic, dynamic> booking) async {
    if (!mounted) return;
    setState(() {
      pickupAddress = _bookingAddress(
        booking,
        const ['pickup_address', 'pickup_location', 'pickup'],
        'Pickup location',
      );
      dropAddress = _bookingAddress(
        booking,
        const ['drop_address', 'destination_address', 'drop_location', 'drop'],
        'Destination',
      );
    });
    await getAddress(
      _locationCoordinate(booking, 'pickup_lat', 'pickup'),
      _locationCoordinate(booking, 'pickup_lng', 'pickup'),
      _locationCoordinate(booking, 'drop_lat', 'drop'),
      _locationCoordinate(booking, 'drop_lng', 'drop'),
    );
  }

  //pickupAddress  pickupAddress
  GoogleMapController? mapController;

  LatLng? currentLatLng;
  LatLng carLatLng = const LatLng(28.5355, 77.3910); // Noida (Static)
  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  // Set<Marker> markers = {};
  // Set<Polyline> polylines = {};
  Future<void> getCurrentLocation() async {
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLatLng = LatLng(position.latitude, position.longitude);

    setMarkers();
    drawRoute();
  }

  void setMarkers() {
    if (currentLatLng == null) return;

    markers.clear();

    markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: currentLatLng!,
        infoWindow: const InfoWindow(title: "You"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("car"),
        position: carLatLng,
        infoWindow: const InfoWindow(title: "Car"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    setState(() {});
  }

  // Was "...CVMldUs" (trailing typo'd 's') — a different, invalid key from
  // the one used everywhere else in the app (drawRoute1(), _drawBookingRoute(),
  // rentals_vehicle_screen.dart, etc.), which silently broke this screen's
  // own route drawing (drawRoute() below) — every Directions API call
  // through this key failed with 400/403 and got swallowed by the
  // `if (response.statusCode != 200) { print(...); return; }` below.
  final String googleApiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";

  Future<void> drawRoute() async {
    try {
      final origin = "${carLatLng.latitude},${carLatLng.longitude}";
      final destination =
          "${currentLatLng!.latitude},${currentLatLng!.longitude}";
      print("CAR: ${carLatLng.latitude},${carLatLng.longitude}");
      print("USER: ${currentLatLng!.latitude},${currentLatLng!.longitude}");
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$googleApiKey";

      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url)); // ✅ FIX
      final response = await request.close();

      if (response.statusCode != 200) {
        print("API Error: ${response.statusCode}");
        return;
      }

      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body);

      List<LatLng> routePoints = [];

      if (data["routes"] != null && data["routes"].isNotEmpty) {
        final steps = data["routes"][0]["legs"][0]["steps"];

        for (var step in steps) {
          final polyline = step["polyline"]["points"];

          List<PointLatLng> decoded = PolylinePoints.decodePolyline(polyline);

          for (var point in decoded) {
            routePoints.add(LatLng(point.latitude, point.longitude));
          }
        }

        setState(() {
          polylines.clear();
          polylines.add(
            Polyline(
              polylineId: const PolylineId("route"),
              points: routePoints,
              width: 6,
              color: ColorResources.blueeebutton,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
            ),
          );
        });
      }
    } catch (e) {
      print("Route Error: $e");
    }
  }

  //
  Future<void> drawRoute1() async {
    try {
      if (currentLocation == null || driverLocation == null) {
        print("Current location ya Driver location null hai");
        return;
      }

      PolylinePoints polylinePoints = PolylinePoints(
        apiKey: 'AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU',
      );

      // Which journey to draw depends on where the rider is in the trip.
      // Before pickup the useful line is the driver closing in on them; once
      // they are aboard it is the road to the destination. This used to be
      // hardcoded to "me → driver", so for the whole ride the rider watched a
      // line to a car they were already sitting in.
      final bool underway = _isRideUnderway;
      final LatLng routeStart = underway
          ? driverLocation!
          : currentLocation!;
      final LatLng? routeEnd = underway ? _dropLatLng : driverLocation;
      if (routeEnd == null) return;

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(routeStart.latitude, routeStart.longitude),
          destination: PointLatLng(routeEnd.latitude, routeEnd.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isEmpty) {
        print("Route points nahi mile");
        return;
      }

      List<LatLng> routePoints = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        polylines.clear();

        polylines.add(
          Polyline(
            polylineId: const PolylineId("driver_route"),
            points: routePoints,
            width: 5,
            geodesic: true,
          ),
        );
      });

      print("Route Drawn Successfully");
    } catch (e) {
      print("Draw Route Error: $e");
    }
  }

  void updateMarkers() {
    // Keep the booking's pickup and destination pins when the device or
    // driver position refreshes.
    final updatedMarkers = markers
        .where(
          (marker) =>
              marker.markerId.value != 'user' &&
              marker.markerId.value != 'driver',
        )
        .toSet();

    if (currentLocation != null) {
      updatedMarkers.add(
        Marker(
          markerId: const MarkerId("user"),
          position: currentLocation!,
          infoWindow: const InfoWindow(title: "My Location"),
        ),
      );
    }

    if (driverLocation != null) {
      updatedMarkers.add(
        Marker(
          markerId: const MarkerId("driver"),
          position: driverLocation!,
          icon: carIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: "Driver"),
        ),
      );
    }
    markers.assignAll(updatedMarkers);
  }

  double? _coordinate(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  Map<dynamic, dynamic>? _locationData(
    Map<dynamic, dynamic> booking,
    String key,
  ) {
    final location = booking[key];
    return location is Map ? location : null;
  }

  dynamic _locationCoordinate(
    Map<dynamic, dynamic> booking,
    String legacyKey,
    String locationKey,
  ) {
    final legacyValue = booking[legacyKey];
    if (legacyValue != null && legacyValue.toString().isNotEmpty) {
      return legacyValue;
    }
    return _locationData(booking, locationKey)?[
        legacyKey.endsWith('_lat') ? 'lat' : 'lng'];
  }

  String _bookingLocationKey(Map<dynamic, dynamic> booking) {
    return '${_locationCoordinate(booking, 'pickup_lat', 'pickup')},'
        '${_locationCoordinate(booking, 'pickup_lng', 'pickup')},'
        '${_locationCoordinate(booking, 'drop_lat', 'drop')},'
        '${_locationCoordinate(booking, 'drop_lng', 'drop')}';
  }

  String? _visibleBookingLocationKey;
  String? _visibleDriverLocationKey;

  void _showBookingLocations(Map<dynamic, dynamic> booking) {
    final pickupLat = _coordinate(
      _locationCoordinate(booking, 'pickup_lat', 'pickup'),
    );
    final pickupLng = _coordinate(
      _locationCoordinate(booking, 'pickup_lng', 'pickup'),
    );
    final dropLat = _coordinate(
      _locationCoordinate(booking, 'drop_lat', 'drop'),
    );
    final dropLng = _coordinate(
      _locationCoordinate(booking, 'drop_lng', 'drop'),
    );
    if (pickupLat == null ||
        pickupLng == null ||
        dropLat == null ||
        dropLng == null) {
      return;
    }

    final locationKey = _bookingLocationKey(booking);
    final pickup = LatLng(pickupLat, pickupLng);
    final destination = LatLng(dropLat, dropLng);
    // Kept so the route and camera can aim here once the ride starts.
    _dropLatLng = destination;
    if (_visibleBookingLocationKey != locationKey) {
      _visibleBookingLocationKey = locationKey;
      final retainedLiveMarkers = markers
          .where(
            (marker) =>
                marker.markerId.value == 'user' ||
                marker.markerId.value == 'driver',
          )
          .toSet();
      retainedLiveMarkers.addAll({
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup,
          infoWindow: const InfoWindow(title: 'Pickup location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      });
      markers.assignAll(retainedLiveMarkers);
      _drawBookingRoute(pickup, destination);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || mapController == null) return;
      // mounted is genuinely not enough on its own here — confirmed live:
      // this exact mounted check was already in place and the app still
      // hit "GoogleMapController ... used after the associated GoogleMap
      // widget had already been disposed." The native map view's teardown
      // and Flutter's own mounted flag don't flip in the same instant, so
      // there's a real window where this check passes but the platform
      // channel underneath has already gone. Same fix as _recentreOnRide:
      // catch it rather than let a lost camera move on a screen that's
      // already on its way out crash the app.
      try {
        if (pickup.latitude == destination.latitude &&
            pickup.longitude == destination.longitude) {
          mapController?.animateCamera(CameraUpdate.newLatLngZoom(pickup, 15));
          return;
        }
        mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                pickup.latitude < destination.latitude
                    ? pickup.latitude
                    : destination.latitude,
                pickup.longitude < destination.longitude
                    ? pickup.longitude
                    : destination.longitude,
              ),
              northeast: LatLng(
                pickup.latitude > destination.latitude
                    ? pickup.latitude
                    : destination.latitude,
                pickup.longitude > destination.longitude
                    ? pickup.longitude
                    : destination.longitude,
              ),
            ),
            80,
          ),
        );
      } catch (e) {
        debugPrint('[FindingDriver] animateCamera after dispose: $e');
      }
    });
  }

  Future<void> _drawBookingRoute(LatLng pickup, LatLng destination) async {
    try {
      final result = await PolylinePoints(apiKey: googleApiKey)
          .getRouteBetweenCoordinates(
            request: PolylineRequest(
              origin: PointLatLng(pickup.latitude, pickup.longitude),
              destination: PointLatLng(
                destination.latitude,
                destination.longitude,
              ),
              mode: TravelMode.driving,
            ),
          );
      final points = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      if (!mounted) return;
      polylines.assignAll({
        Polyline(
          polylineId: const PolylineId('booking_route'),
          points: points.length >= 2 ? points : [pickup, destination],
          width: 5,
          color: ColorResources.blueeebutton,
          geodesic: points.length < 2,
        ),
      });
    } catch (_) {
      // Still show a direct connector if Directions is temporarily unavailable.
      if (!mounted) return;
      polylines.assignAll({
        Polyline(
          polylineId: const PolylineId('booking_route'),
          points: [pickup, destination],
          width: 5,
          color: ColorResources.blueeebutton,
          geodesic: true,
        ),
      });
    }
  }

  void updateDriverLocation(double latitude, double longitude) {
    // See _recentreOnRide's own note — this is reached from a
    // post-frame callback that can outlive this screen.
    if (!mounted) return;

    driverLocation = LatLng(latitude, longitude);

    updateMarkers();
    drawRoute1();

    // Only if the rider hasn't taken the map over — see [_followMode].
    if (!_followMode) return;
    _recentreOnRide();
  }

  Future<void> getCurrentLocation1() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLocation = LatLng(position.latitude, position.longitude);

    updateMarkers();
  }

  LatLng? currentLocation;
  LatLng? driverLocation;
  @override
  Widget build(BuildContext context) {
    // While the booking is still unassigned, this screen is the full-screen
    // "Finding you the best driver" search state — not a map with a sheet
    // over it. There is nothing to track on a map yet: no driver has
    // accepted, so the only marker would be the rider's own pickup point.
    //
    // Only the pending branch is replaced. Every other status still falls
    // through to the tracking scaffold below with its map, live driver
    // marker and polling completely untouched.
    return GetBuilder<BookingController>(
      builder: (statusController) {
        if (statusController.rideStatus.value.toLowerCase() == 'pending') {
          return Scaffold(
            body: FindingDriverView(
              onBack: () => Get.back(),
              // Same action the old pending sheet's Cancel Ride button ran:
              // stop the poll first, then offAndToNamed so this screen is
              // disposed rather than left alive behind the cancel screen.
              onCancelRide: () {
                _timer?.cancel();
                Get.offAndToNamed(
                  RouteHelper.getcancelRideScreen(),
                  arguments: {'booking_id': widget.booking_id},
                );
              },
            ),
          );
        }
        return _buildTrackingScaffold(context);
      },
    );
  }

  Widget _buildTrackingScaffold(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            // Was Obx() watching only rideStatus + tridRideDetailsData (both
            // Rx) — the live driver GPS (driverInfo.lat/lng, set by
            // TrackRideApi2 on every 3s poll) is a plain field updated via
            // update(), which Obx never reacts to, so the driver marker
            // was placed once and then frozen for the rest of the ride.
            // GetBuilder reacts to the same update() call both polling
            // functions already fire every tick, so this now also picks
            // up live position changes, not just status/trip-detail ones.
            child: GetBuilder<BookingController>(builder: (controller) {
              final status = controller.rideStatus.value;
              final driverdata = controller.tridRideDetailsData;
              if (driverdata.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _showBookingLocations(driverdata),
                );
              }

              // Real live driver GPS — from /track-ride's
              // driver_info.lat/lng. Confirmed live against the actual
              // backend: this updates within seconds of the driver
              // sending a location update, unlike the booking's pickup
              // point (which never moves). Falls back to null until the
              // driver has sent at least one location update after
              // accepting.
              final liveDriverLat = _coordinate(controller.driverInfo?.lat);
              final liveDriverLng = _coordinate(controller.driverInfo?.lng);
              if (liveDriverLat != null && liveDriverLng != null) {
                final key = '$liveDriverLat,$liveDriverLng';
                if (_visibleDriverLocationKey != key) {
                  _visibleDriverLocationKey = key;
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => updateDriverLocation(liveDriverLat, liveDriverLng),
                  );
                }
              }

              print('sttaus::::::::${status}');
              return status == "pending"
                  ? GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(28.6139, 77.2090),
                        zoom: 14,
                      ),
                      myLocationEnabled: true,

                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: false,
                      markers: markers.value,
                      polylines: polylines.value,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        getCurrentLocation1();
                        if (driverdata.isNotEmpty) {
                          _showBookingLocations(driverdata);
                        }
                      },
                    )
                  : GoogleMap(
                      key: ValueKey(status), // optional
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(0, 0),
                        zoom: 14,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      markers: markers.value,
                      polylines: polylines.value,
                      // Fires for our own animateCamera calls as well as real
                      // drags, so the flag set alongside those calls is what
                      // separates the two.
                      onCameraMoveStarted: () {
                        if (_programmaticCameraMove) {
                          _programmaticCameraMove = false;
                          return;
                        }
                        _onUserPannedMap();
                      },
                      onMapCreated: (controllerMap) async {
                        mapController = controllerMap;

                        if (driverdata.isNotEmpty) {
                          _showBookingLocations(driverdata);
                        }

                        await getCurrentLocation1();

                        // getCurrentLocation1() awaits a real GPS fix — the
                        // screen can be gone by the time it resolves (same
                        // class of race as _showBookingLocations/
                        // _recentreOnRide above).
                        if (mounted && currentLocation != null) {
                          try {
                            mapController?.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: currentLocation!,
                                  zoom: 16,
                                ),
                              ),
                            );
                          } catch (e) {
                            debugPrint(
                              '[FindingDriver] animateCamera after dispose: $e',
                            );
                          }
                        }
                        // Initial marker placement. Prefer the real live
                        // GPS (driver_info.lat/lng from /track-ride,
                        // confirmed live above) — only fall back to the
                        // booking's pickup point (was previously reading
                        // driverdata['pickup_lat']/['pickup_lng'] as flat
                        // keys, which don't exist in the real /trip-detail
                        // response — they're nested under pickup: {lat,
                        // lng} — so this always read null and the "driver"
                        // marker never appeared at all) for the brief
                        // window before the driver's first location update
                        // lands.
                        final driverLat = liveDriverLat ??
                            _coordinate(
                              _locationCoordinate(driverdata, 'pickup_lat', 'pickup'),
                            );
                        final driverLng = liveDriverLng ??
                            _coordinate(
                              _locationCoordinate(driverdata, 'pickup_lng', 'pickup'),
                            );
                        if (driverLat != null && driverLng != null) {
                          updateDriverLocation(driverLat, driverLng);
                          _visibleDriverLocationKey = '$driverLat,$driverLng';
                        }
                      },
                    );
            }),
            // check karo

            //  ),
          ),
          // Positioned.fill(
          //   child: GoogleMap(
          // initialCameraPosition: const CameraPosition(
          //   target: LatLng(28.6139, 77.2090),
          //   zoom: 14,
          // ),
          // myLocationEnabled: true,

          // myLocationButtonEnabled: false,
          // zoomControlsEnabled: false,
          // mapToolbarEnabled: false,
          // compassEnabled: false,
          // markers: markers,
          // polylines: polylines,
          // onMapCreated: (GoogleMapController controller) {
          //   getCurrentLocation();
          //   drawRoute();
          // },
          //   ),
          // GoogleMap(
          //   initialCameraPosition: const CameraPosition(
          //     target: LatLng(0, 0),
          //     zoom: 14,
          //   ),
          //   myLocationEnabled: true,
          //   myLocationButtonEnabled: false,
          //   zoomControlsEnabled: false,
          //   markers: markers,
          //   polylines: polylines,
          //   onMapCreated: (controller) async {
          //     mapController = controller;

          //     await getCurrentLocation1();

          //     if (currentLocation != null) {
          //       mapController?.animateCamera(
          //         CameraUpdate.newCameraPosition(
          //           CameraPosition(target: currentLocation!, zoom: 16),
          //         ),
          //       );
          //     }

          //     updateDriverLocation(28.627761, 77.372782);
          //   },
          // ),
          //  GoogleMap(
          //   initialCameraPosition: const CameraPosition(
          //     target: LatLng(28.6139, 77.2090),
          //     zoom: 14,
          //   ),
          //   myLocationEnabled: true,

          //   myLocationButtonEnabled: false,
          //   zoomControlsEnabled: false,
          //   mapToolbarEnabled: false,
          //   compassEnabled: false,
          //   markers: markers,
          //   polylines: polylines,
          //   onMapCreated: (GoogleMapController controller) {
          //     getCurrentLocation();
          //     drawRoute();
          //   },
          // ),
          //  ),

          /// ================= TOP LOCATION CARD =================
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            // Was Obx() — same root cause as the map layer above (see its
            // own note): BookingController's polling drives everything via
            // update(), which Obx doesn't reliably pick up. This block's
            // reads (rideDetails, tridRideDetailsData) apparently didn't
            // register as an observed dependency either, which is what
            // GetX's own "improper use of GetX" error was reporting —
            // an Obx that completed a build without ever subscribing to
            // anything. GetBuilder sidesteps the question entirely: it
            // rebuilds on every update() call regardless of which fields
            // got read.
            child: GetBuilder<BookingController>(builder: (controller) {
              final data = controller.rideDetails;
              final driverdata = controller.tridRideDetailsData;
              if (!addressLoaded && driverdata.isNotEmpty) {
                addressLoaded = true;

                Future.microtask(() {
                  _loadBookingAddresses(driverdata);
                });
              }

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// Pickup
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: ColorResources.blueeebutton,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            pickupAddress.isEmpty
                                ? 'Pickup location'
                                : pickupAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Divider(),

                    /// Drop
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: ColorResources.textColorRed,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dropAddress.isEmpty ? 'Destination' : dropAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),

          /// ================= CENTER RIPPLE =================
          const Center(child: RippleLoader()),

          /// ================= LEFT BACK BUTTON =================
          Positioned(
            left: 16,
            bottom: 280,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back),
            ),
          ),

          /// ================= RIGHT TARGET BUTTON =================
          Positioned(
            right: 16,
            bottom: 280,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location),
            ),
          ),

          /// ================= BOTTOM SHEET =================
          Align(
            alignment: Alignment.bottomCenter,
            child: GetBuilder<BookingController>(
              builder: (controller) {
                final status = controller.rideStatus.value;
                final data = controller.rideDetails;
                final driverstatus = controller.tridRideDetails.value;
                final driverdata = controller.tridRideDetailsData;

                if (status == "accepted" ||
                    status == "arrived" ||
                    status == "ongoing") {
                  return buildExpandableRideSheet(
                    status,
                    data!,
                    driverstatus,
                    driverdata,
                  );
                }

                /// COMPLETED
                // if (status == "completed") {
                //   print('Complete:::::::');
                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                //     buildCompletedSheet(data, driverdata);
                //   //  Get.toNamed(RouteHelper.getmainNavigationScreen());
                //     //  buildCompletedSheet(data, driverdata);
                //     // anuj
                //   });

                //   // return const SizedBox();
                // }
                if (status == "completed") {
                  return CompletedRideSheet(
                    key: const ValueKey('completed_sheet'),
                    bookingId: widget.booking_id,
                    rideData: data,
                    tripDetails: Map<String, dynamic>.from(driverdata),
                    dropAddress: dropAddress,
                    onTimerCancel: () => _timer?.cancel(),
                  );
                }

                /// CANCELLED
                if (status == "cancelled") {
                  if (!_isNavigating) {
                    _isNavigating = true;
                    _timer?.cancel();

                    // Driver/admin cancelled externally — clear the stack and
                    // return home. (User-initiated cancel is handled in the
                    // Cancel button via offAndToNamed → CancelRideScreen.)
                    Future.microtask(() {
                      Get.offAllNamed(RouteHelper.getmainNavigationScreen());
                    });
                  }

                  return const SizedBox();
                }

                /// SCHEDULED
                if (status == "scheduled") {
                  if (!_isNavigating) {
                    _isNavigating = true;
                    _timer?.cancel();

                    Future.microtask(() {
                      Get.offAllNamed(RouteHelper.getmainNavigationScreen());
                    });
                  }

                  return const SizedBox();
                }

                /// DEFAULT PENDING
                return buildPendingUI();
              },
            ),
          ),
        ],
      ),
    );
  }

  ////// ========== Ui Build  Finding you a nearby driver.... =============== //////////

  Widget buildPendingUI() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const Text(
            "Finding you a nearby driver....",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            "The driver will pick you up as soon as possible after they confirm your order.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 16),

          /// ── Nearby drivers (informational only — the backend still
          /// does the actual matching/assignment; this just shows the
          /// rider who's around while that happens) ──
          _nearbyDriversPreview(),

          const SizedBox(height: 16),

          /// ── Ripple loader ──
          const RippleLoader(),

          const SizedBox(height: 20),

          /// ── Cancel Ride button ──
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                _timer?.cancel();
                // offAndToNamed removes this screen before pushing cancel,
                // so this FDU is disposed and its timer truly stops.
                Get.offAndToNamed(
                  RouteHelper.getcancelRideScreen(),
                  arguments: {'booking_id': widget.booking_id},
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorResources.textColorRed,
                side: BorderSide(color: ColorResources.textColorRed, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Cancel Ride",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Read-only "who's around" strip — the rider does not pick from this
  /// list, the backend still auto-assigns the driver exactly as before.
  /// Sourced from BookingController.nearbyDriversSearch, which already
  /// polls driver-availble-list every 20s (see nearby_drivers_search.dart);
  /// this just surfaces that existing data here instead of only feeding
  /// map markers on the home screen. Deliberately renders nothing outside
  /// the "search succeeded with at least one driver" state — a locating/
  /// searching/empty/error message here would just duplicate or contradict
  /// the ripple loader and "Finding you a nearby driver...." text already
  /// on screen for those states.
  Widget _nearbyDriversPreview() {
    return Obx(() {
      final state = Get.find<BookingController>().nearbyDriversSearch.state.value;
      if (state.phase != NearbyDriversPhase.success || state.drivers.isEmpty) {
        return const SizedBox.shrink();
      }

      final drivers = state.drivers;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${drivers.length} driver${drivers.length == 1 ? '' : 's'} nearby",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          // Was 72 — a horizontal ListView gives each item a *tight* height
          // equal to this box (not just a max), so _nearbyDriverChip's
          // actual content (36px avatar + 4px gap + a line of name text +
          // a line of distance text + 16px of vertical padding, ~86-90px
          // depending on font metrics) never fit — "BOTTOM OVERFLOWED BY
          // n PIXELS" on every chip, every time a driver is nearby. Sized
          // with real margin instead of the bare minimum so small device-
          // font differences can't reopen the same overflow.
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: drivers.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) =>
                  _nearbyDriverChip(drivers[index]),
            ),
          ),
        ],
      );
    });
  }

  Widget _nearbyDriverChip(DriverAvailableDataModel driver) {
    final name = (driver.name?.isNotEmpty == true) ? driver.name! : "Driver";
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
    final hasImage = driver.profileImage != null && driver.profileImage!.isNotEmpty;

    return Container(
      width: 74,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: ColorResources.blueeebutton.withValues(alpha: 0.15),
            backgroundImage: hasImage
                ? NetworkImage(ApiConstants.imageurl + driver.profileImage!)
                : null,
            child: hasImage
                ? null
                : Text(
                    initial,
                    style: TextStyle(
                      color: ColorResources.blueeebutton,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          // Only when there is a real figure — a zero here meant the backend
          // sent no distance, and "0.0 km" reads as a driver already at the
          // kerb.
          if (driver.distance != null && driver.distance! > 0)
            Text(
              "${driver.distance!.toStringAsFixed(1)} km",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget bottomContainer({
    required String title,
    required String subtitle,
    required bool showLoader,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          if (showLoader) const RippleLoader(),
        ],
      ),
    );
  }

  ////// ========== driverBottomContainer =============== //////////

  Widget driverBottomContainer({
    required String title,
    required String name,
    required String vehicle,
    required String phone,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const CircleAvatar(radius: 25),
            title: Text(name),
            subtitle: Text(vehicle),
            trailing: IconButton(
              icon: Icon(Icons.call, color: ColorResources.blueeebutton),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////============================= fdfodf========================////////////////

  //////////////// ============================ ongoing paire =========================///////////////////////

  /// Small icon+label pair for the vehicle type / registration number row.
  Widget _vehicleInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildExpandableRideSheet(
    String status,
    DatTrackRideDetails data,
    String driverstatus,
    Map drivercollection,
  ) {
    final driver = data.driverInfo;

    String otp = data.otp.toString().padLeft(4, '0');

    return DraggableScrollableSheet(
      initialChildSize: 0.40,
      minChildSize: 0.25,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HANDLE BAR
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                /// STATUS TITLE
                Text(
                  getStatusTitle(status),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                /// OTP (only arrived & ongoing)
                if (status == "arrived" || status == "accepted")
                  Row(
                    children: [
                      const Text(
                        "OTP to start ride",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      Spacer(),

                      ...List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 6),
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorResources.blueeebutton.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(otp[index]),
                        );
                      }),
                    ],
                  ),

                const SizedBox(height: 10),

                /// DRIVER INFO
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        "${ApiConstants.imageurl}${driver!.profileImage}",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver!.name.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Builder(
                            builder: (_) {
                              // Vehicle *type* (e.g. "Sedan", "XUV Premium")
                              // is the ride category picked at booking time
                              // — /trip-detail's vehicle.name — not the
                              // driver's own vehicalName, which is closer to
                              // a make/model label. Falls back to
                              // vehicalName when trip-detail hasn't loaded
                              // yet (right after a driver accepts, before
                              // its first poll lands), so this row never
                              // sits empty while a value is genuinely known.
                              final tripVehicle = Get.find<BookingController>()
                                  .tripDetailModel
                                  .value
                                  ?.data
                                  ?.vehicle;
                              final vehicleType =
                                  (tripVehicle?.name?.isNotEmpty == true)
                                      ? tripVehicle!.name!
                                      : (driver.vehicalName ?? '');
                              final vehicleNumber = driver.vehicalNumber ?? '';

                              // "Maruti Swift Dzire" — brand and model
                              // together as one label, distinct from the
                              // *type*/category chip below (e.g. "Sedan").
                              // vehical_brand/vehical_model aren't confirmed
                              // present on this endpoint (see DriverInfo's
                              // own note) — if the backend doesn't send
                              // them, vehicalName is the next best thing:
                              // it's already confirmed live and reads like
                              // a make/model label itself (that's the whole
                              // reason the type chip above only uses it as
                              // a fallback, not its first choice), so
                              // showing it here is better than an empty
                              // line while brand/model stay unconfirmed.
                              final vehicleBrandModel = [
                                driver.vehicalBrand ?? '',
                                driver.vehicalModel ?? '',
                              ].where((s) => s.isNotEmpty).join(' ');
                              final vehicleBrandModelText =
                                  vehicleBrandModel.isNotEmpty
                                      ? vehicleBrandModel
                                      : (driver.vehicalName ?? '');

                              if (vehicleType.isEmpty &&
                                  vehicleNumber.isEmpty &&
                                  vehicleBrandModelText.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (vehicleBrandModelText.isNotEmpty) ...[
                                    Text(
                                      vehicleBrandModelText,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 4,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      if (vehicleType.isNotEmpty)
                                        _vehicleInfoChip(
                                          Icons.directions_car_rounded,
                                          vehicleType,
                                        ),
                                      if (vehicleNumber.isNotEmpty)
                                        _vehicleInfoChip(
                                          Icons.confirmation_number_outlined,
                                          vehicleNumber.toUpperCase(),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: Dimensions.spacingSize10),
                    // status == 'ongoing'
                    //     ? SizedBox()
                    //     :
                    GestureDetector(
                      onTap: () async {
                        if (_isChatOpening) return;

                        _isChatOpening = true;

                        final prefs = await SharedPreferences.getInstance();
                        String? userId = prefs.getString(
                          ApiConstants.profileid,
                        );

                        print('driver booking id: ${driver.driverid}');
                        print('booking UserId: ${data.bookingId}');
                        print('customer id: $userId');

                        try {
                          showDialog(
                            context: Get.context!,
                            barrierDismissible: false,
                            builder: (_) => PremiumBlurLoader(),
                          );
                          final response = await Get.find<ChatController>()
                              .startChats(
                                context: context,
                                bookingId: data.bookingId!.toString(),
                                driverId: driver.driverid!.toString(),
                                customerId: userId.toString(),
                              );

                          print('testing on tab ${response.body}');

                          if (response.body != null &&
                              response.body['code'].toString() == "200") {
                            _timer?.cancel();

                            Get.toNamed(
                              RouteHelper.getchatScreenScreen(),
                              arguments: {
                                "acceptData": data,
                                "bookingId": widget.booking_id,
                              },
                            );
                          }

                          _isChatOpening = false;
                        } catch (e) {
                          debugPrint('updateVehicleDocument Error: $e');
                        } finally {
                          if (Get.isDialogOpen ?? false) {
                            Get.back();
                          }
                        }
                      },
                      child: Icon(Icons.chat_bubble_outline),
                    ),

                    SizedBox(width: 12),
                    // status == 'ongoing'
                    //     ? SizedBox()
                    //     :
                    GestureDetector(
                      onTap: () {
                        Get.find<ProfileController>().callNumber(
                          phoneNumber: driver.phone.toString(),
                        );
                      },
                      child: Icon(Icons.call),
                    ),

                    //Icon(Icons.call, color: Colors.blue),
                  ],
                ),

                const SizedBox(height: 20),

                /// EXTRA DETAILS (only ongoing) — real breakdown from
                /// /trip-detail; nothing shown until it's actually loaded.
                if (status == "ongoing")
                  Builder(
                    builder: (_) {
                      final tripData = Get.find<BookingController>()
                          .tripDetailModel
                          .value
                          ?.data;
                      if (tripData == null) return const SizedBox.shrink();
                      return PriceBreakdownCard(tripData: tripData);
                    },
                  ),

                const SizedBox(height: 20),

                /// CANCEL BUTTON
                ///if (status != "ongoing")
                if (status == "arrived" ||
                    status == "pending" ||
                    status == "accepted")
                  InkWell(
                    onTap: () {
                      _timer?.cancel();
                      print('text booking id ${widget.booking_id}');
                      Get.offAndToNamed(
                        RouteHelper.getcancelRideScreen(),
                        arguments: {'booking_id': widget.booking_id},
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: ColorResources.textColorRed),
                      ),
                      child: Text(
                        "Cancel Ride",
                        style: TextStyle(
                          color: ColorResources.textColorRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String getStatusTitle(String status) {
    switch (status) {
      case "accepted":
        return "Driver is heading to pickup";
      case "arrived":
        return "Driver has arrived";
      case "ongoing":
        return "Ride is ongoing";
      default:
        return "";
    }
  }

  /// Replaced by PriceBreakdownCard fed from BookingController's typed
  /// tripDetailModel — this used to read details['base_fare'],
  /// details['discount_fare'] and details['total_fare'] directly off the
  /// raw /trip-detail map, but those fields don't exist at that level
  /// (base_fare lives under price_breakdown, and there is no
  /// discount_fare field at all) so it always rendered "₹ null".

  /////======================== Complete ride moved to CompletedRideSheet =============
}

////// finding  loader ==============
class RippleLoader extends StatefulWidget {
  const RippleLoader({super.key});

  @override
  State<RippleLoader> createState() => _RippleLoaderState();
}

class _RippleLoaderState extends State<RippleLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        double value = controller.value;

        return Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60 + (value * 20),
                height: 60 + (value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorResources.blueeebutton.withValues(alpha: 1 - value)),
                ),
              ),

              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: ColorResources.blueeebutton,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

