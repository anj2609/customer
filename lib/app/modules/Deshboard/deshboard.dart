import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:myrideuser/app/modules/Deshboard/rentals_intro_screen.dart';
import 'package:myrideuser/app/modules/Deshboard/outstation_trip_screen.dart';
import 'package:myrideuser/app/modules/acoount/notification_screen.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/services/pickup_marker_icon.dart';
import 'package:myrideuser/data/modal/address_Model.dart';
import 'package:myrideuser/data/modal/vehicle_type_model.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

/// Which section the single bottom sheet is currently showing.
enum _SheetStage { idle, searching, vehicleSelect }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  final BookingController bookingController = Get.find<BookingController>();

  /// The draggable pickup pin's icon, replacing the pulsating ring that used
  /// to mark the rider's location. Null until the asset finishes decoding —
  /// [_pickupMarker] falls back to a stock pin for those first frames rather
  /// than drawing nothing.
  BitmapDescriptor? _pickupPinIcon;

  /// Guards against stale reverse-geocode results from overlapping drags:
  /// each drag captures this, and only commits if it is still the newest.
  /// Without it, dragging twice quickly can land the *first* drag's address
  /// on the *second* drag's coordinates.
  int _pickupDragGeneration = 0;

  /// True while a dropped pin is being reverse-geocoded and service-area
  /// checked. Blocks a second drag mid-resolve and drives the sheet's
  /// "Updating pickup..." line.
  bool _isResolvingPickupDrag = false;

  /// Set once the rider drags the pin, and never cleared for the life of
  /// this screen. A deliberate placement outranks anything automatic — see
  /// [_loadCurrentAddress], where a GPS fix that resolves late would
  /// otherwise overwrite it.
  bool _pickupPlacedByDrag = false;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  /// Last banner debug line printed — see _promoBanner's own note on why
  /// this dedupes the trace instead of printing on every rebuild.
  String? _lastBannerDebugState;

  // GoogleMap had no `padding`, so "centered" meant centered in the map
  // widget's full bounds — including the portion permanently covered by the
  // bottom sheet (never less than _minSize, 30% of the screen). The blue
  // location dot rendered at that geometric center, which sits behind the
  // sheet, reading as "my location is stuck low and half-hidden" rather than
  // actually centered in the visible map area above the sheet. Kept in sync
  // with the sheet's actual live extent (it resizes between 0.3 and 0.92
  // depending on stage and drag), rather than a fixed value that would only
  // be correct at one sheet size.
  double _mapBottomPadding = 0;

  /// The sheet's resting height for a given stage, as a fraction of the
  /// screen. Used as the padding source whenever the live controller can't
  /// be read yet — see [_mapPaddingForCurrentSheet].
  static double _stageSize(_SheetStage stage) => switch (stage) {
    _SheetStage.idle => _idleSize,
    _SheetStage.searching => _searchingSize,
    _SheetStage.vehicleSelect => _vehicleSize,
  };

  /// How much of the map's bottom edge the sheet is currently covering.
  ///
  /// Falls back to the current stage's known resting size when the sheet
  /// controller isn't attached. That fallback is the whole fix for "my
  /// location is hidden behind the sheet after switching tabs": the bottom
  /// bar swaps `_pages[_currentIndex]` rather than keeping tabs alive, so
  /// coming back to Home builds this State from scratch, and on that first
  /// frame the DraggableScrollableSheet's builder hasn't run — so
  /// `_sheetController.isAttached` is still false. The old version simply
  /// returned early in that case, leaving the padding at 0 with nothing
  /// scheduled to ever try again, so the map stayed padded for a
  /// full-height viewport and put the location dot underneath the sheet
  /// until the user happened to drag it. Reading the stage instead means
  /// there is always a correct answer available, attached or not.
  /// Height of the box the map and sheet actually share, captured from the
  /// LayoutBuilder in build(). Falls back to 0 until the first layout.
  double _mapViewportHeight = 0;

  double _mapPaddingForCurrentSheet() {
    // Was MediaQuery.of(context).size.height — the whole screen, including
    // the status bar and the greeting header sitting above this box. The
    // sheet's fractions are relative to its parent, which is that box and
    // not the screen, so every padding value came out overstated. At the
    // searching stage's 0.9 that overshoot is enough to meet or exceed the
    // map's own height: padding then leaves no usable viewport at all, and
    // a camera move has nowhere valid to put its target — which is exactly
    // where "the map still shows the previous location" comes from.
    final double height = _mapViewportHeight > 0
        ? _mapViewportHeight
        : MediaQuery.of(context).size.height;
    final fraction = _sheetController.isAttached
        ? _sheetController.size
        : _stageSize(_stage);
    // Never let the sheet claim the entire map. Google Maps has no sensible
    // interpretation of padding >= the view, and the rider needs some strip
    // of map left to actually see what the camera was pointed at.
    final double maxPadding = height * 0.85;
    return (fraction * height).clamp(0.0, maxPadding);
  }

  void _syncMapPaddingToSheet() {
    if (!mounted) return;
    final padding = _mapPaddingForCurrentSheet();
    if ((padding - _mapBottomPadding).abs() < 1) return;
    setState(() => _mapBottomPadding = padding);
  }

  _SheetStage _stage = _SheetStage.idle;

  // Sheet sizes (fraction of screen height) per stage.
  static const double _idleSize = 0.52;
  static const double _searchingSize = 0.9;
  static const double _vehicleSize = 0.6;
  static const double _minSize = 0.3;
  static const double _maxSize = 0.92;

  // ================= SEARCH (merged from SearchLocationScreen) =================
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _pickupEditController = TextEditingController();
  List predictions = [];
  final String _placesApiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";

  // This app operates in Tripura only. See search_scren.dart's own copy of
  // this same note (this screen's search was "merged from
  // SearchLocationScreen" per the section header above, and inherited the
  // exact same unrestricted-autocomplete gap that file had — fixing one
  // without the other left this one, the version actually embedded in the
  // main dashboard sheet, still showing results from anywhere on Earth).
  // strictbounds=true turns location+radius from a ranking bias into a hard
  // filter; centred/sized to cover Tripura's full extent (bounding box
  // roughly 22.98–24.53°N, 91.15–92.35°E), necessarily over-covering the
  // corners a little since Tripura's shape isn't a circle — Tripura is
  // bordered by Bangladesh on three sides, which components=country:in is
  // what actually excludes.
  static const double _tripuraCenterLat = 23.76;
  static const double _tripuraCenterLng = 91.75;
  static const int _tripuraRadiusMeters = 110000;
  static const String _tripuraLocationParams =
      '&location=$_tripuraCenterLat,$_tripuraCenterLng'
      '&radius=$_tripuraRadiusMeters'
      '&strictbounds=true'
      '&components=country:in';

  String _currentAddress = "Loading...";
  LatLng? _pickupLatLng;
  String? _currentAdminArea;
  bool _isEditingPickup = false;
  bool _isCheckingLocation = false;

  /// True when the searching stage was reopened from the vehicle-select
  /// route summary (rider tapped pickup/drop to change it after a
  /// destination was already picked — e.g. hailing on someone else's
  /// behalf, where "current location" isn't their actual pickup point) as
  /// opposed to the normal idle -> "Where to?" entry. Governs where the
  /// back arrow / system back returns to (see _closeSearch), so editing
  /// either field from that summary doesn't discard the trip already set up.
  bool _editingFromVehicleSelect = false;

  // Was ['delhi', 'tripura'] — this app is strictly Tripura-only, so
  // 'delhi' let a pickup or drop in Delhi silently pass the one safety
  // check this screen already had, even though nothing else about this
  // service operates there.
  static const List<String> _allowedStates = ['tripura'];

  // ================= VEHICLE SELECTION (merged from RideOptionScreen) =================
  LatLng? _dropLatLng;
  String _pickupAddress = "";
  String _dropAddress = "";
  int _selectedVehicleIndex = -1;
  String _estimatedPrice = "";
  String _vehicleTypeId = "";
  bool _isLoadingEstimate = false;
  bool _isScheduled = false;
  DateTime? _selectedDateTime;
  String _formattedDateTime = "";
  bool _isBooking = false;
  Set<Polyline> _polylines = {};
  Set<Marker> _routeMarkers = {};

  final String _directionsApiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_syncMapPaddingToSheet);
    // Belt-and-braces alongside didChangeDependencies below: once the sheet
    // has actually attached, re-read its real size in case it settled
    // somewhere other than its stage's resting position.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _syncMapPaddingToSheet(),
    );
    _loadPickupPinIcon();
    controller.getAddressCustomer(context: context);
    Get.find<ProfileController>().getActivityData(
      context: context,
      typeOfSlug: 'ongoing',
    );
    Get.find<ProfileController>().customerWalletAmount();
    _loadCurrentAddress();

    // Arriving here from a "Services" tab vehicle tap — open destination
    // search once this screen is actually mounted.
    if (bookingController.pendingOpenSearch.value) {
      bookingController.pendingOpenSearch.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openSearch());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Assigned directly rather than through _syncMapPaddingToSheet(), which
    // calls setState — this already runs immediately before build(), so the
    // value is picked up by the very frame that follows. This is what makes
    // the map correctly padded from the first frame on every mount,
    // including each return to the Home tab, instead of only after the
    // sheet attaches. Needs MediaQuery, so it can't be done in initState.
    _mapBottomPadding = _mapPaddingForCurrentSheet();
  }

  /// Decoded once per mount; the service itself caches across mounts, so
  /// returning to the Home tab doesn't re-run the pixel work.
  Future<void> _loadPickupPinIcon() async {
    final BitmapDescriptor icon = await PickupMarkerIcon.load(
      'assets/images/location marker.jpg',
    );
    if (!mounted) return;
    setState(() => _pickupPinIcon = icon);
  }

  @override
  void dispose() {
    _sheetController.removeListener(_syncMapPaddingToSheet);
    _sheetController.dispose();
    _destinationController.dispose();
    _pickupEditController.dispose();
    super.dispose();
  }

  // ================= CURRENT LOCATION =================

  Future<void> _loadCurrentAddress() async {
    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // A GPS fix can take several seconds — long enough for the rider to
      // have already dragged the pin somewhere deliberate (the pin is
      // draggable from the first frame precisely so a slow or denied fix
      // isn't a dead end). Landing this result on top of that choice would
      // silently move their pickup back, so a manual placement wins.
      if (_pickupPlacedByDrag) return;

      _pickupLatLng = LatLng(pos.latitude, pos.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (_pickupPlacedByDrag) return;

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _currentAdminArea = place.administrativeArea;
        if (mounted) {
          setState(() {
            _currentAddress =
                "${place.name}, ${place.locality}, ${place.administrativeArea}";
          });
        }
      }
    } catch (e) {
      debugPrint("Current address error: $e");
    }
  }

  bool _isLocationAllowed(String? administrativeArea) {
    if (administrativeArea == null || administrativeArea.isEmpty) return false;
    final lower = administrativeArea.toLowerCase();
    return _allowedStates.any((s) => lower.contains(s));
  }

  // ================= STAGE TRANSITIONS =================

  void _openSearch() {
    setState(() {
      _stage = _SheetStage.searching;
      _isEditingPickup = false;
      _pickupEditController.text = _currentAddress;
      predictions = [];
    });
    _animateSheetTo(_searchingSize);
  }

  void _closeSearch() {
    // Editing pickup/drop from the vehicle-select summary reopens this same
    // searching stage — backing out of it (arrow or system back) should
    // return to that summary with the trip still intact, not fall all the
    // way back to idle and discard the destination already picked.
    if (_editingFromVehicleSelect && _dropLatLng != null) {
      setState(() {
        _stage = _SheetStage.vehicleSelect;
        _isEditingPickup = false;
        _editingFromVehicleSelect = false;
        predictions = [];
      });
      _animateSheetTo(_vehicleSize);
      return;
    }

    setState(() {
      _stage = _SheetStage.idle;
      predictions = [];
      _isEditingPickup = false;
      _editingFromVehicleSelect = false;
      _destinationController.clear();
    });
    _animateSheetTo(_idleSize);
  }

  /// Reopens the search sheet to change the pickup point after a
  /// destination is already set — e.g. hailing on someone else's behalf,
  /// where the rider's current GPS location isn't the actual pickup point.
  void _editPickupFromVehicleSelect() {
    setState(() {
      _stage = _SheetStage.searching;
      _isEditingPickup = true;
      _editingFromVehicleSelect = true;
      _pickupEditController.text = _currentAddress;
      _destinationController.text = _dropAddress;
      predictions = [];
    });
    _animateSheetTo(_searchingSize);
  }

  /// Reopens the search sheet to change the destination after one is
  /// already set, from the vehicle-select route summary.
  void _editDestinationFromVehicleSelect() {
    setState(() {
      _stage = _SheetStage.searching;
      _isEditingPickup = false;
      _editingFromVehicleSelect = true;
      _pickupEditController.text = _currentAddress;
      _destinationController.text = _dropAddress;
      predictions = [];
    });
    _animateSheetTo(_searchingSize);
  }

  void _backToIdleFromVehicleSelect() {
    setState(() {
      _stage = _SheetStage.idle;
      _dropLatLng = null;
      _polylines = {};
      _routeMarkers = {};
      _selectedVehicleIndex = -1;
      bookingController.vehicleList.clear();
    });
    _animateSheetTo(_idleSize);
  }

  void _animateSheetTo(double size) {
    if (!_sheetController.isAttached) return;
    _sheetController.animateTo(
      size,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  // ================= PLACES SEARCH (same endpoints as before) =================

  Future<void> _searchPlaces(String input) async {
    if (input.isEmpty) {
      setState(() => predictions = []);
      return;
    }

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_placesApiKey$_tripuraLocationParams";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          predictions = data["predictions"];
        });
      }
    }
  }

  Future<void> _onPredictionTap(dynamic place) async {
    if (_isEditingPickup) {
      await _applyPickupSelection(place);
    } else {
      await _confirmDestination(place);
    }
  }

  Future<void> _applyPickupSelection(dynamic place) async {
    final placeId = place["place_id"];
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_placesApiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    final loc = data['result']['geometry']['location'];

    if (!mounted) return;

    final LatLng selected = LatLng(loc['lat'], loc['lng']);

    setState(() {
      _pickupLatLng = selected;
      _currentAddress = place['description'];
      // Keeps the pickup field itself in step, so reopening it shows the
      // pickup that is actually set rather than the last thing typed.
      _pickupEditController.text = _currentAddress;
      _isEditingPickup = false;
      predictions = [];
    });

    // Editing pickup from the vehicle-select summary (destination already
    // set) — go straight back there with the route/estimates refreshed for
    // the new pickup point, instead of stranding the rider on the search
    // sheet waiting to re-pick a destination they'd already chosen.
    if (_editingFromVehicleSelect && _dropLatLng != null) {
      _editingFromVehicleSelect = false;
      await _fetchEstimates(
        dropLat: _dropLatLng!.latitude,
        dropLng: _dropLatLng!.longitude,
        dropAddressText: _dropAddress,
      );
      // _fetchEstimates fits the camera to the whole pickup->drop route,
      // which is the more useful framing once a trip exists — don't fight it.
      return;
    }

    // No destination yet, so nothing else will ever move the camera: the
    // only camera work in this flow is _fitRouteBounds, and that needs a
    // route. Without this the pin dutifully moved to the newly chosen
    // pickup and the map carried on showing the *previous* area, leaving
    // the rider looking at the wrong place with the pin somewhere off
    // screen entirely.
    _moveCameraToPickup(selected);
  }

  /// Zoom used when framing a freshly chosen pickup — close enough to make
  /// out which side of the street it landed on, where the map's initial 14
  /// is a neighbourhood overview.
  static const double _pickupZoom = 16;

  /// Centres the map on [target].
  ///
  /// No-ops before the map exists (the controller is only set in
  /// onMapCreated). The GoogleMap already carries bottom padding equal to
  /// the sheet's height, so "centre" here means centred in the strip the
  /// rider can actually see above the sheet, not behind it.
  void _moveCameraToPickup(LatLng target) {
    // From here on the rider's framing is the one that counts — otherwise
    // the nearby-driver refresh re-frames the map back onto the raw GPS fix
    // within seconds. See BookingController.suppressCameraAutoFit.
    bookingController.suppressCameraAutoFit = true;

    final GoogleMapController? mapController = bookingController.mapController;
    if (mapController == null) return;
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(target, _pickupZoom),
    );
  }

  Future<void> _confirmDestination(dynamic place) async {
    if (_isCheckingLocation) return;
    setState(() => _isCheckingLocation = true);

    try {
      final placeId = place["place_id"];
      final url =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_placesApiKey";

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      final location = data["result"]["geometry"]["location"];
      final LatLng selectedLatLng = LatLng(location["lat"], location["lng"]);

      if (_currentAdminArea == null && _pickupLatLng == null) {
        try {
          await _loadCurrentAddress();
        } catch (_) {}
      }

      String? destAdminArea;
      if (data["result"]["address_components"] != null) {
        for (var component in data["result"]["address_components"]) {
          List types = component["types"] ?? [];
          if (types.contains("administrative_area_level_1")) {
            destAdminArea = component["long_name"];
            break;
          }
        }
      }

      if (_currentAdminArea == null && _pickupLatLng != null) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            _pickupLatLng!.latitude,
            _pickupLatLng!.longitude,
          );
          if (placemarks.isNotEmpty) {
            _currentAdminArea = placemarks.first.administrativeArea;
          }
        } catch (_) {}
      }

      final bool pickupAllowed =
          _currentAdminArea == null || _isLocationAllowed(_currentAdminArea);
      final bool destAllowed =
          destAdminArea == null || _isLocationAllowed(destAdminArea);

      if (!pickupAllowed && !destAllowed) {
        if (mounted) {
          AnimatedTopToast.show(
            context: context,
            message:
                "Sorry! We are not available in this location at the moment.",
            backgroundColor: ColorResources.textColorBaclColor,
            icon: Icons.location_off_outlined,
          );
        }
        return;
      }

      await _fetchEstimates(
        dropLat: selectedLatLng.latitude,
        dropLng: selectedLatLng.longitude,
        dropAddressText: place["description"] ?? "",
      );
    } catch (e) {
      if (mounted) {
        AnimatedTopToast.show(
          context: context,
          message: "Could not verify location. Please try again.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }
    } finally {
      if (mounted) setState(() => _isCheckingLocation = false);
    }
  }

  /// Picking a saved/recent address already has lat/lng — go straight
  /// to fetching estimates without another Places round-trip.
  Future<void> _selectKnownAddress(String label, double lat, double lng) async {
    await _fetchEstimates(dropLat: lat, dropLng: lng, dropAddressText: label);
  }

  Future<void> _fetchEstimates({
    required double dropLat,
    required double dropLng,
    required String dropAddressText,
  }) async {
    if (_pickupLatLng == null) {
      AnimatedTopToast.show(
        context: context,
        message: "Still locating you — please try again in a moment.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.my_location,
      );
      return;
    }

    // Where to put the rider back if the estimate fails. The sheet moves to
    // vehicleSelect optimistically just below, before the fare call has
    // answered, so the loading skeletons have somewhere to show — but when
    // that call fails there are no vehicles to choose from, and leaving
    // them parked on "Choose a ride" showing "No vehicles available for
    // this route" under a live Next button is a dead end. Sending them back
    // where they came from puts the destination field in front of them
    // again, which is the one thing that can actually fix it.
    final _SheetStage stageBeforeFetch = _stage;

    // A priced trip gets framed to its own pickup->drop bounds by
    // _fitRouteBounds; the nearby-driver auto-fit would pull the camera off
    // that route every refresh.
    bookingController.suppressCameraAutoFit = true;

    setState(() {
      _stage = _SheetStage.vehicleSelect;
      _isLoadingEstimate = true;
      _editingFromVehicleSelect = false;
      _dropLatLng = LatLng(dropLat, dropLng);
      _dropAddress = dropAddressText;
      _pickupAddress = _currentAddress;
      _selectedVehicleIndex = -1;
      predictions = [];
    });
    _animateSheetTo(_vehicleSize);

    await _drawRoute();

    final Response estimateResponse =
        await bookingController.bookingestimateListApi(
      pickup_lat: _pickupLatLng!.latitude,
      pickup_lng: _pickupLatLng!.longitude,
      drop_lat: dropLat,
      drop_lng: dropLng,
      context: context,
      navigateToRideOption: false,
    );

    if (!mounted) return;

    // Mirrors what bookingestimateListApi itself treats as success: a real
    // 200 whose body also carries code 200. Anything else (the 500 this
    // endpoint returns for an unroutable drop pin included) left the
    // vehicle list empty, and the toast has already explained why.
    final dynamic responseBody = estimateResponse.body;
    final bool estimateSucceeded = estimateResponse.statusCode == 200 &&
        responseBody is Map &&
        responseBody['code']?.toString() == '200';

    if (!estimateSucceeded) {
      setState(() {
        _isLoadingEstimate = false;
        // vehicleSelect would just bounce them straight back to the dead
        // end; searching at least lets them pick a different destination.
        _stage = stageBeforeFetch == _SheetStage.vehicleSelect
            ? _SheetStage.searching
            : stageBeforeFetch;
        // The half-built trip is not usable — drop it rather than leave a
        // stale pin, route line, or previous route's vehicles behind.
        _dropLatLng = null;
        _polylines = {};
        _routeMarkers = {};
        _selectedVehicleIndex = -1;
        bookingController.vehicleList.clear();
      });
      _animateSheetTo(_stageSize(_stage));
      return;
    }

    setState(() => _isLoadingEstimate = false);
  }

  // ================= ROUTE DRAWING (same Directions API logic as before) =================

  Future<void> _drawRoute() async {
    if (_pickupLatLng == null || _dropLatLng == null) return;

    setState(() {
      // Drop only. The pickup end of the route is the draggable pickup pin
      // (see _pickupMarker), which _buildMap unions in on every stage — a
      // second static marker here would sit underneath it at the same
      // coordinate and, worse, would not move when the rider drags.
      _routeMarkers = {
        Marker(
          markerId: const MarkerId("drop"),
          position: _dropLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });

    try {
      final origin = "${_pickupLatLng!.latitude},${_pickupLatLng!.longitude}";
      final destination = "${_dropLatLng!.latitude},${_dropLatLng!.longitude}";

      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$_directionsApiKey";

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      List<LatLng> routePoints = [];

      if (data["routes"] != null && data["routes"].isNotEmpty) {
        final legs = data["routes"][0]["legs"];

        for (var leg in legs) {
          for (var step in leg["steps"]) {
            final polyline = step["polyline"]["points"];
            List<PointLatLng> decoded = PolylinePoints.decodePolyline(polyline);
            for (var point in decoded) {
              routePoints.add(LatLng(point.latitude, point.longitude));
            }
          }
        }

        if (mounted) {
          setState(() {
            _polylines = {
              Polyline(
                polylineId: const PolylineId("route"),
                points: routePoints,
                width: 6,
                color: ColorResources.blueeebutton,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
              ),
            };
          });
        }

        _fitRouteBounds();
      }
    } catch (e) {
      debugPrint("Route error: $e");
    }
  }

  void _fitRouteBounds() {
    if (_pickupLatLng == null || _dropLatLng == null) return;
    final bounds = LatLngBounds(
      southwest: LatLng(
        _pickupLatLng!.latitude < _dropLatLng!.latitude
            ? _pickupLatLng!.latitude
            : _dropLatLng!.latitude,
        _pickupLatLng!.longitude < _dropLatLng!.longitude
            ? _pickupLatLng!.longitude
            : _dropLatLng!.longitude,
      ),
      northeast: LatLng(
        _pickupLatLng!.latitude > _dropLatLng!.latitude
            ? _pickupLatLng!.latitude
            : _dropLatLng!.latitude,
        _pickupLatLng!.longitude > _dropLatLng!.longitude
            ? _pickupLatLng!.longitude
            : _dropLatLng!.longitude,
      ),
    );
    bookingController.mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  // ================= SCHEDULE (same picker logic as before) =================

  Future<void> _pickSchedule() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      _isScheduled = true;
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      _formattedDateTime =
          "${_selectedDateTime!.year}-"
          "${_selectedDateTime!.month.toString().padLeft(2, '0')}-"
          "${_selectedDateTime!.day.toString().padLeft(2, '0')} "
          "${_selectedDateTime!.hour.toString().padLeft(2, '0')}:"
          "${_selectedDateTime!.minute.toString().padLeft(2, '0')}:00";
    });
  }

  void _clearSchedule() {
    setState(() {
      _isScheduled = false;
      _selectedDateTime = null;
      _formattedDateTime = "";
    });
  }

  // ================= BOOKING (same CreateBooking call as before) =================

  Future<void> _book() async {
    if (_isBooking) return;

    if (_selectedVehicleIndex == -1 || _vehicleTypeId.isEmpty) {
      AnimatedTopToast.show(
        context: context,
        message: "Please select a vehicle type",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return;
    }

    if (_isScheduled && _formattedDateTime.isEmpty) {
      AnimatedTopToast.show(
        context: context,
        message: "Please select a schedule date & time",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return;
    }

    setState(() => _isBooking = true);

    try {
      final String scheduleFlag = _isScheduled ? "1" : "0";
      final String scheduleDateTime = _isScheduled ? _formattedDateTime : "";

      await bookingController.CreateBooking(
        pickup_lat: _pickupLatLng!.latitude,
        pickup_lng: _pickupLatLng!.longitude,
        drop_lat: _dropLatLng!.latitude,
        drop_lng: _dropLatLng!.longitude,
        context: context,
        estimated_price: _estimatedPrice,
        vehicle_type_id: _vehicleTypeId,
        pickup_address: _pickupAddress,
        drop_address: _dropAddress,
        is_schedule: scheduleFlag,
        schedule_date_time: scheduleDateTime,
      );
    } catch (e) {
      debugPrint('CreateBooking Error: $e');
      AnimatedTopToast.show(
        context: context,
        message: "Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  // ================= QUICK ACTIONS =================

  AddressModels? _findAddressByLabel(String keyword) {
    for (final a in controller.addressList) {
      if (a.isNoAddressPlaceholder) continue;
      final label = a.label?.toLowerCase() ?? "";
      if (label.contains(keyword)) return a;
    }
    return null;
  }

  void _onQuickAction(String type) {
    switch (type) {
      case 'home':
        final home = _findAddressByLabel('home');
        if (home != null) {
          final lat = double.tryParse(home.lat ?? "");
          final lng = double.tryParse(home.lng ?? "");
          if (lat != null && lng != null) {
            _selectKnownAddress(home.label ?? "Home", lat, lng);
            return;
          }
        }
        Get.toNamed(RouteHelper.getsavedAddressScreen())?.then((_) {
          controller.getAddressCustomer(context: context);
        });
        break;
      case 'work':
        final work = _findAddressByLabel('work');
        if (work != null) {
          final lat = double.tryParse(work.lat ?? "");
          final lng = double.tryParse(work.lng ?? "");
          if (lat != null && lng != null) {
            _selectKnownAddress(work.label ?? "Work", lat, lng);
            return;
          }
        }
        Get.toNamed(RouteHelper.getsavedAddressScreen())?.then((_) {
          controller.getAddressCustomer(context: context);
        });
        break;
      case 'airport':
        _openSearch();
        _destinationController.text = "Agartala Airport";
        _searchPlaces("Agartala Airport");
        break;
      case 'saved':
        Get.toNamed(RouteHelper.getsavedAddressScreen())?.then((_) {
          controller.getAddressCustomer(context: context);
        });
        break;
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _stage == _SheetStage.idle,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_stage == _SheetStage.searching) {
          _closeSearch();
        } else if (_stage == _SheetStage.vehicleSelect) {
          _backToIdleFromVehicleSelect();
        }
      },
      child: Scaffold(
        backgroundColor: ColorResources.whiteColor,
        // Keep the map and draggable sheet at a stable height while the
        // destination keyboard is open. The sheet itself gets bottom inset
        // padding below, so its search results remain scrollable.
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SafeArea(bottom: false, child: _buildHeader()),
            Expanded(
              // The sheet's size fractions are relative to *this* box, not
              // to the screen — so this is the height the map padding has to
              // be computed against (see _mapPaddingForCurrentSheet).
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _mapViewportHeight = constraints.maxHeight;
                  return Stack(
                    children: [
                      _buildMap(),
                      // Nearby-drivers status banner (loading/empty/error
                      // toasts like "Couldn't load nearby drivers, please
                      // try again") removed from the dashboard header per
                      // request — the map markers alone now communicate
                      // driver availability.
                      _buildSheet(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Header (greeting + logo + notification) ----------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: GetBuilder<ProfileController>(
        builder: (c) {
          final fullName = c.profile.value.data?.name ?? "";
          final firstName = fullName.trim().isNotEmpty
              ? fullName.trim().split(RegExp(r'\s+')).first
              : "there";

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Hello, ",
                                  style: PoppinsReguler.copyWith(
                                    fontSize: 15,
                                    color: ColorResources.blackcolor11,
                                  ),
                                ),
                                TextSpan(
                                  text: "$firstName ",
                                  style: PoppinsSemiBold.copyWith(
                                    fontSize: 15,
                                    color: ColorResources.blackcolor11,
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Text("👋", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Built in Tripura, For Tripura",
                      style: PoppinsReguler.copyWith(
                        fontSize: 11,
                        color: ColorResources.TextColorForGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Image.asset(
                'assets/images/splashscreen.png',
                height: 20,
                color: ColorResources.blueeebutton,
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () => Get.to(() => const NotificationsScreen()),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: ColorResources.blackcolor11,
                      size: 24,
                    ),
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: ColorResources.blueeebutton,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorResources.whiteColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------- Map ----------

  /// The pickup pin — draggable, and the replacement for the pulsating ring
  /// that used to mark the rider's position.
  ///
  /// It marks the *pickup point*, which is not always where the rider is
  /// standing: hailing for someone else is exactly the case where those
  /// differ, and dragging this is the fastest way to say so. GoogleMap's
  /// native blue dot stays enabled alongside it and keeps showing true GPS
  /// position, so once the pin is moved away the rider can still see where
  /// they actually are.
  ///
  /// Falls back to [BitmapDescriptor.defaultMarker] for the frames before
  /// the asset finishes decoding, so the pin is never missing.
  ///
  /// Anchored bottom-centre because the artwork is a pin on a stick: the tip
  /// is the coordinate, and the default (0.5, 0.5) would float the point
  /// half an icon-height north of the place it claims to mark.
  Marker? _pickupMarker(LatLng fallbackCenter) {
    // Before GPS resolves — or when permission was denied outright — there
    // is no pickup yet, but that is precisely when placing one by hand
    // matters most. Showing the pin at the map's centre gives the rider a
    // way to set pickup manually instead of a dead screen.
    final LatLng position = _pickupLatLng ?? fallbackCenter;

    return Marker(
      markerId: const MarkerId('pickup_pin'),
      position: position,
      icon: _pickupPinIcon ?? BitmapDescriptor.defaultMarker,
      anchor: const Offset(0.5, 1.0),
      // Above the nearby-driver cars, which are drawn at zIndex 0..n.
      zIndexInt: 1000,
      // Frozen while a booking is being created or fares are being fetched
      // for the current pickup — letting it move then would send the rider
      // a fare, or a driver, for a point they are no longer choosing.
      draggable: !_isBooking && !_isLoadingEstimate && !_isResolvingPickupDrag,
      onDragEnd: _onPickupPinDragEnd,
      infoWindow: InfoWindow(
        title: _pickupLatLng == null ? 'Set pickup' : 'Pickup',
        snippet: _isResolvingPickupDrag
            ? 'Updating…'
            : 'Drag to adjust',
      ),
    );
  }

  /// Commits a dragged pickup pin: reverse-geocode, service-area check, then
  /// re-price the trip if a destination is already chosen.
  ///
  /// The pin is moved into state immediately rather than after the async
  /// work, because the marker's drawn position comes from that state — a
  /// rebuild landing mid-resolve (the nearby-driver refresh fires one every
  /// few seconds) would otherwise snap the pin back under the rider's
  /// finger. On rejection it is put back deliberately, below.
  Future<void> _onPickupPinDragEnd(LatLng dropped) async {
    final LatLng? previousLatLng = _pickupLatLng;
    final String previousAddress = _currentAddress;
    final String? previousAdminArea = _currentAdminArea;
    final bool previouslyPlacedByDrag = _pickupPlacedByDrag;

    // A drag that ends where it started is a tap-and-release, not a move.
    if (previousLatLng != null &&
        (previousLatLng.latitude - dropped.latitude).abs() < 0.000001 &&
        (previousLatLng.longitude - dropped.longitude).abs() < 0.000001) {
      return;
    }

    final int generation = ++_pickupDragGeneration;

    // The rider just placed this by hand, so the camera is already framed
    // the way they want it — the job here is only to stop the nearby-driver
    // refresh from animating it back onto the raw GPS fix a few seconds
    // later. No camera move of our own: moving it after a drag would fight
    // the gesture that just ended.
    bookingController.suppressCameraAutoFit = true;

    setState(() {
      _pickupLatLng = dropped;
      _pickupPlacedByDrag = true;
      _isResolvingPickupDrag = true;
    });

    String? resolvedAddress;
    String? resolvedAdminArea;
    bool geocodeFailed = false;

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        dropped.latitude,
        dropped.longitude,
      );
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        resolvedAdminArea = place.administrativeArea;
        resolvedAddress = [
          place.name,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((p) => p != null && p.trim().isNotEmpty).join(', ');
      }
    } catch (e) {
      // Offline, or the platform geocoder is unavailable. Not fatal — see
      // the service-area decision below.
      geocodeFailed = true;
      debugPrint('Pickup drag reverse-geocode failed: $e');
    }

    if (!mounted) return;
    // A newer drag started while this one was resolving; that one owns the
    // pin now, and committing this stale result would put an older address
    // on newer coordinates.
    if (generation != _pickupDragGeneration) return;

    // Same rule the destination check already uses: only block on a
    // *known* out-of-area result. An unknown area (geocoder down, offline)
    // must not strand a rider who is in fact inside the service area — the
    // booking call itself remains the backstop.
    final bool outsideServiceArea =
        resolvedAdminArea != null && !_isLocationAllowed(resolvedAdminArea);

    if (outsideServiceArea) {
      setState(() {
        _pickupLatLng = previousLatLng;
        _currentAddress = previousAddress;
        _currentAdminArea = previousAdminArea;
        // Restored, not left set: a rejected drag is not a placement. If
        // this stayed true after reverting to a null pickup (dragged before
        // the GPS fix landed), _loadCurrentAddress would be locked out for
        // good and the rider would be left with no pickup at all.
        _pickupPlacedByDrag = previouslyPlacedByDrag;
        _isResolvingPickupDrag = false;
      });
      AnimatedTopToast.show(
        context: context,
        message: "We don't operate there yet — pickup moved back.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.location_off_outlined,
      );
      return;
    }

    setState(() {
      _currentAdminArea = resolvedAdminArea ?? previousAdminArea;
      _currentAddress = (resolvedAddress != null && resolvedAddress.isNotEmpty)
          ? resolvedAddress
          // Coordinates are a poor label, but they are honest and they keep
          // the booking usable when the geocoder can't name the spot.
          : '${dropped.latitude.toStringAsFixed(5)}, '
              '${dropped.longitude.toStringAsFixed(5)}';
      _pickupEditController.text = _currentAddress;
      _pickupAddress = _currentAddress;
      _isResolvingPickupDrag = false;
    });

    if (geocodeFailed) {
      AnimatedTopToast.show(
        context: context,
        message: "Couldn't look up that address — pickup set to the pin.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.info_outline,
      );
    }

    // A destination is already chosen, so the fare and route on screen were
    // priced from the old pickup and are now wrong. _fetchEstimates redraws
    // the route, re-prices, and handles its own failure path (including
    // dropping back out of vehicle-select when the new pickup can't be
    // routed from).
    if (_dropLatLng != null) {
      await _fetchEstimates(
        dropLat: _dropLatLng!.latitude,
        dropLng: _dropLatLng!.longitude,
        dropAddressText: _dropAddress,
      );
    }
  }

  /// Explicitly re-centers the camera so the rider's own location renders
  /// in the visible area above the sheet, right after a fresh GoogleMap is
  /// created (which happens on every return to this tab — see
  /// _mapPaddingForCurrentSheet's own comment on why that is).
  ///
  /// `padding` is documented to shift where a camera target renders on
  /// screen, and _mapBottomPadding is correct by the time this fires — but
  /// there is a real gap between Flutter handing the native platform view a
  /// padding value and that view actually finishing applying it internally,
  /// and the map's very first rendered frame can land before that settles.
  /// That race is exactly what "correct on a cold app start, hidden again
  /// after switching tabs" looks like: a slow cold start gives the native
  /// side plenty of time to settle before anything is shown; a fast, warm
  /// tab switch does not.
  ///
  /// `scrollBy` is a genuine camera move in screen pixels — not a padding
  /// trick — so it settles the position regardless of whether that native
  /// timing gap was actually the cause. Deliberately applied exactly once,
  /// right after creation, and never on a sheet-drag tick: repeating it
  /// would compound (scrollBy is relative, not absolute) and would fight
  /// the rider's own manual panning of the map.
  void _nudgeCameraAboveSheet(GoogleMapController mapController) {
    if (_mapBottomPadding <= 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Gives the native side a frame to actually finish applying the
      // padding it was just handed, so this is a correction on top of the
      // settled state rather than a second guess made before that settles.
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      // Positive dy moves the camera *target* south, which puts the point
      // that used to be dead-center (the rider) north of it instead — i.e.
      // visibly higher on screen, up out from behind the sheet.
      mapController.moveCamera(CameraUpdate.scrollBy(0, _mapBottomPadding / 2));
    });
  }

  Widget _buildMap() {
    return GetBuilder<BookingController>(
      builder: (bc) {
        // The nearby-driver cars while choosing, the route's drop pin once a
        // trip is priced — and the draggable pickup pin in both, so pickup
        // stays adjustable right up until the ride is booked.
        final Set<Marker> baseMarkers = _stage == _SheetStage.vehicleSelect
            ? _routeMarkers
            : bc.markers;
        final Marker? pickupPin = _pickupMarker(bc.currentLatLng);

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: bc.currentLatLng,
            zoom: 14,
          ),
          // Google's own blue location dot, off deliberately: the pickup pin
          // is the only location marker on this map now. With both drawn,
          // the untouched case stacks a dot and a pin on the identical
          // coordinate, and after a drag the two read as competing claims
          // about where the rider is.
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          // Without this, "centered" meant centered in the map widget's
          // full bounds, including the portion the bottom sheet
          // permanently covers — see _mapPaddingForCurrentSheet.
          padding: EdgeInsets.only(bottom: _mapBottomPadding),
          markers: {
            ...baseMarkers,
            if (pickupPin != null) pickupPin,
          },
          polylines: _polylines,
          onMapCreated: (mapController) {
            bc.mapController = mapController;
            _nudgeCameraAboveSheet(mapController);
          },
        );
      },
    );
  }

  // ---------- The single bottom sheet ----------

  Widget _buildSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _idleSize,
      minChildSize: _minSize,
      maxChildSize: _maxSize,
      snap: true,
      snapSizes: const [_idleSize, _vehicleSize, _searchingSize],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: ColorResources.whiteColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: const [BoxShadow(blurRadius: 16, color: Colors.black12)],
          ),
          child: _stage == _SheetStage.idle
              ? _buildIdleScrollable(scrollController)
              : SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom:
                        16 +
                        MediaQuery.of(context).padding.bottom +
                        MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dragHandle(),
                      switch (_stage) {
                        _SheetStage.searching => _searchContent(),
                        _SheetStage.vehicleSelect => _vehicleContent(),
                        _SheetStage.idle => const SizedBox.shrink(),
                      },
                    ],
                  ),
                ),
        );
      },
    );
  }

  /// The pickup line shown above "Where to?" in the idle sheet.
  ///
  /// Without this the idle sheet named no pickup at all, so dragging the map
  /// pin — the whole point of which is to change that pickup — produced no
  /// visible confirmation of where it actually landed. Tapping it opens the
  /// same search sheet with the pickup field focused, so the pin and the
  /// text field are two routes to one value.
  Widget _pickupPinBar() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _openSearch();
        setState(() => _isEditingPickup = true);
      },
      child: Row(
        children: [
          Icon(
            Icons.trip_origin,
            size: 14,
            color: ColorResources.blueeebutton,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isResolvingPickupDrag ? 'Updating pickup…' : _currentAddress,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsMedium.copyWith(
                fontSize: 12.5,
                color: _isResolvingPickupDrag
                    ? ColorResources.TextColorForGrey
                    : ColorResources.blackcolor11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (_isResolvingPickupDrag)
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 1.8),
            )
          else
            Text(
              'Change',
              style: PoppinsMedium.copyWith(
                fontSize: 11.5,
                color: ColorResources.blueeebutton,
              ),
            ),
        ],
      ),
    );
  }

  /// Idle stage only: the "Where to?" bar (+ drag handle) is a fixed-height
  /// Column child above an Expanded SingleChildScrollView carrying the rest
  /// of the idle content — still driven by the same scrollController the
  /// DraggableScrollableSheet needs for its drag-to-resize gesture.
  Widget _buildIdleScrollable(ScrollController scrollController) {
    return Column(
      children: [
        Container(
          color: ColorResources.whiteColor,
          child: Column(
            children: [
              _dragHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: _pickupPinBar(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                child: _whereToBar(),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _quickActionsRow(),
                const SizedBox(height: 18),
                _promoBanner(),
                const SizedBox(height: 20),
                _recentPlacesSection(),
                const SizedBox(height: 20),
                _forYouSection(),
                const SizedBox(height: 20),
                _chooseRideSection(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: ColorResources.greycolorborder,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  // ===================================================================
  // IDLE STAGE
  // ===================================================================

  Widget _whereToBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _openSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color: ColorResources.backgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: ColorResources.TextColorForGrey,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Where to?",
                    style: PoppinsReguler.copyWith(
                      fontSize: 14,
                      color: ColorResources.blackcolor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            if (_isScheduled) {
              _clearSchedule();
            } else {
              _pickSchedule();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ColorResources.brandGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: ColorResources.whiteColor,
                ),
                const SizedBox(width: 6),
                Text(
                  _isScheduled ? "Scheduled" : "Now",
                  style: PoppinsMedium.copyWith(
                    fontSize: 13,
                    color: ColorResources.whiteColor,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickActionItem(
          icon: Icons.home_rounded,
          label: "Home",
          subtitle: _findAddressByLabel('home') != null
              ? "Go home"
              : "Set location",
          onTap: () => _onQuickAction('home'),
        ),
        _quickActionItem(
          icon: Icons.work_rounded,
          label: "Work",
          subtitle: _findAddressByLabel('work') != null
              ? "Go to work"
              : "Set location",
          onTap: () => _onQuickAction('work'),
        ),
        _quickActionItem(
          icon: Icons.flight_takeoff_rounded,
          label: "Airport",
          subtitle: "Agartala",
          onTap: () => _onQuickAction('airport'),
        ),
        _quickActionItem(
          icon: Icons.bookmark_rounded,
          label: "Saved",
          subtitle: "View all",
          onTap: () => _onQuickAction('saved'),
        ),
      ],
    );
  }

  Widget _quickActionItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ColorResources.blueeebutton.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: ColorResources.blueeebutton, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: PoppinsMedium.copyWith(
                fontSize: 12,
                color: ColorResources.blackcolor11,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsReguler.copyWith(
                fontSize: 10,
                color: ColorResources.TextColorForGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _promoBanner() {
    return GetBuilder<BookingController>(
      builder: (bc) {
        final banner = bc.homeBanner;
        final String title = banner?.title ?? "Get ₹100 OFF";
        final String subTitle = banner?.subTitle ?? "On your first 3 rides";
        final String? image = banner?.image;
        final String? imageUrl = image == null || image.isEmpty
            ? null
            : (Uri.tryParse(image)?.hasScheme ?? false)
            ? image
            : '${ApiConstants.imageurl}$image';
        // Traced unconditionally, not just from Image.network's own
        // errorBuilder below (which only fires on an actual load failure)
        // — this also shows the null/empty case, where the backend field
        // itself never reached this widget at all and there was never a
        // load attempt for the errorBuilder to catch in the first place.
        // Deduped to once per distinct outcome (this widget rebuilds on
        // every scroll/fling — GetBuilder<BookingController>, not scoped
        // to just this banner — so printing unconditionally drowned out
        // the one line that actually mattered under scroll-event spam),
        // and self-sufficient: whether homeBanner itself ever loaded at
        // all is now in the same line, not a separate trace over in
        // getHomeBanner() that this log slice might not even include.
        final bannerDebugState =
            'homeBanner=${banner == null ? "null (fetch never succeeded)" : "loaded"}, '
            'title=${banner?.title}, rawImage="$image", resolvedUrl=$imageUrl';
        if (bannerDebugState != _lastBannerDebugState) {
          _lastBannerDebugState = bannerDebugState;
          debugPrint('[HomeBanner] $bannerDebugState');
        }

        return GestureDetector(
          onTap: _openSearch,
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              // Base gradient — visible while the banner loads, and as a
              // fallback if the API image fails to load.
              gradient: LinearGradient(
                colors: ColorResources.brandGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                if (imageUrl != null)
                  Positioned.fill(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      // Was silent — a load failure just showed nothing, with
                      // no way to tell from the app's behavior whether the
                      // URL was wrong, the image is missing server-side, or
                      // something else. That's exactly what made "banner
                      // doesn't load in production" impossible to diagnose:
                      // there was nowhere for the actual failure to surface.
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint(
                          '[HomeBanner] failed to load "$imageUrl": $error',
                        );
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                // Scrim so text stays readable over an arbitrary photo.
                if (imageUrl != null)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ride More, Save More!",
                        style: PoppinsSemiBold.copyWith(
                          fontSize: 15,
                          color: ColorResources.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: PoppinsBold.copyWith(
                          fontSize: 20,
                          color: ColorResources.whiteColor,
                        ),
                      ),
                      Text(
                        subTitle,
                        style: PoppinsReguler.copyWith(
                          fontSize: 12,
                          color: ColorResources.whiteColor.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: ColorResources.whiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Book Now",
                          style: PoppinsMedium.copyWith(
                            fontSize: 12,
                            color: ColorResources.blueeebutton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _recentPlacesSection() {
    return GetBuilder<ProfileController>(
      builder: (c) {
        final visible = c.addressList
            .where((data) => !data.isNoAddressPlaceholder)
            .take(3)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Places",
                  style: PoppinsSemiBold.copyWith(
                    fontSize: 14,
                    color: ColorResources.blackcolor11,
                  ),
                ),
                GestureDetector(
                  onTap: () => _onQuickAction('saved'),
                  child: Text(
                    "View all",
                    style: PoppinsMedium.copyWith(
                      fontSize: 12,
                      color: ColorResources.blueeebutton,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (c.isLoadings == true)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  ),
                ),
              )
            else if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "No recent places yet",
                  style: PoppinsReguler.copyWith(
                    fontSize: 13,
                    color: ColorResources.TextColorForGrey,
                  ),
                ),
              )
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: visible.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: ColorResources.backgroundColor),
                itemBuilder: (context, index) {
                  final data = visible[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      final lat = double.tryParse(data.lat ?? "");
                      final lng = double.tryParse(data.lng ?? "");
                      if (lat != null && lng != null) {
                        _selectKnownAddress(
                          data.label ?? data.address ?? "Saved place",
                          lat,
                          lng,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: ColorResources.blueeebutton.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              size: 20,
                              color: ColorResources.blueeebutton,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.label ?? "Saved Address",
                                  style: PoppinsMedium.copyWith(
                                    fontSize: 13,
                                    color: ColorResources.blackcolor11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (data.address != null &&
                                    data.address!.isNotEmpty)
                                  Text(
                                    data.address!,
                                    style: PoppinsReguler.copyWith(
                                      fontSize: 11,
                                      color: ColorResources.TextColorForGrey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: ColorResources.TextColorForGrey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  /// "For you" — a small set of ride categories, matching the requested
  /// reference layout (circular icon + label). Only the two categories that
  /// actually exist as upcoming/placeholder concepts are shown; there's no
  /// booking flow behind either yet, so they're non-interactive for now
  /// rather than linking somewhere that doesn't exist.
  Widget _forYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "For you",
          style: PoppinsSemiBold.copyWith(
            fontSize: 14,
            color: ColorResources.blackcolor11,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _forYouItem(
              icon: Icons.time_to_leave_rounded,
              label: "Rentals",
              onTap: () => Get.to(() => const RentalsIntroScreen()),
            ),
            const SizedBox(width: 20),
            _forYouItem(
              icon: Icons.luggage_rounded,
              label: "Outstation",
              onTap: () => Get.to(() => const OutstationTripScreen()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _forYouItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ColorResources.blueeebutton.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ColorResources.blueeebutton, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: PoppinsMedium.copyWith(
              fontSize: 12,
              color: ColorResources.blackcolor11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chooseRideSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose a ride, or swipe up for more",
          style: PoppinsSemiBold.copyWith(
            fontSize: 14,
            color: ColorResources.blackcolor11,
          ),
        ),
        const SizedBox(height: 10),
        GetBuilder<BookingController>(
          builder: (bc) {
            if (bc.isVehicleTypeLoading || bc.vehicleTypeList.isEmpty) {
              return _vehicleGrid(
                List.generate(6, (_) => _vehicleCardSkeleton()),
              );
            }
            return _vehicleGrid(
              bc.vehicleTypeList
                  .map((type) => _idleVehicleTypeCard(type))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  /// No destination yet, so no real price exists — show the real vehicle
  /// type's name/image from the backend with a branded loading placeholder
  /// where the price will appear once a destination is picked.
  Widget _idleVehicleTypeCard(VehicleTypeModel type) {
    return GestureDetector(
      onTap: _openSearch,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorResources.greycolorborder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: _vehicleImageAspectRatio,
                child: _vehicleTypeImage(type.image),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              type.name ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackcolor11,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 40,
              height: 12,
              decoration: BoxDecoration(
                color: ColorResources.backgroundColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lays real card widgets out in a responsive 3-column grid without
  /// forcing a fixed aspect ratio per cell (card content height varies
  /// slightly between the idle/vehicle-select stages), so each card sizes
  /// to its own content instead of GridView's uniform-cell constraint.
  Widget _vehicleGrid(List<Widget> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final itemWidth = (constraints.maxWidth - spacing * 2) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: cards
              .map((card) => SizedBox(width: itemWidth, child: card))
              .toList(),
        );
      },
    );
  }

  Widget _vehicleCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorResources.greycolorborder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: _vehicleImageAspectRatio,
              child: Container(
                color: ColorResources.blueeebutton.withValues(alpha: 0.08),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 70,
            height: 12,
            decoration: BoxDecoration(
              color: ColorResources.blueeebutton.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // SEARCHING STAGE
  // ===================================================================

  Widget _searchContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _closeSearch,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: ColorResources.blackcolor11,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Where do you want to go?",
                style: PoppinsSemiBold.copyWith(
                  fontSize: 15,
                  color: ColorResources.blackcolor11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ColorResources.backgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isEditingPickup)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditingPickup = true;
                        predictions = [];
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          size: 18,
                          color: ColorResources.blueeebutton,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _currentAddress,
                            overflow: TextOverflow.ellipsis,
                            style: PoppinsReguler.copyWith(
                              fontSize: 14,
                              color: ColorResources.blackcolor11,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          size: 14,
                          color: ColorResources.TextColorForGrey,
                        ),
                      ],
                    ),
                  )
                else
                  TextField(
                    controller: _pickupEditController,
                    autofocus: true,
                    style: PoppinsReguler.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Search pickup location...",
                      hintStyle: PoppinsReguler.copyWith(
                        fontSize: 14,
                        color: ColorResources.TextColorForGrey,
                      ),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      // Clears the box and leaves it open to retype — it must
                      // NOT also set _isEditingPickup = false in the same
                      // setState, or this TextField gets swapped out for the
                      // static summary row (which shows _currentAddress, the
                      // one thing this button never touches) in the very
                      // same frame. That's why "first tap on a freshly
                      // opened pickup field, then X" looked like it did
                      // nothing: the field was pre-filled with _currentAddress
                      // by _openSearch, the clear did happen, but it was
                      // instantly hidden behind that unchanged summary text.
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          setState(() {
                            _pickupEditController.clear();
                            predictions = [];
                          });
                        },
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.length > 2) _searchPlaces(value);
                    },
                  ),
                Divider(color: ColorResources.greycolorborder, height: 20),
                TextField(
                  controller: _destinationController,
                  autofocus: !_isEditingPickup,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  style: PoppinsReguler.copyWith(fontSize: 14),
                  // Tapping here while pickup is still mid-edit (e.g. the
                  // rider just typed a friend's address as pickup but hasn't
                  // tapped a suggestion yet) must hand "active field" status
                  // back to destination — otherwise onChanged below stays
                  // gated by _isEditingPickup forever, since nothing else on
                  // this field ever clears that flag, and destination search
                  // silently does nothing no matter what's typed. The
                  // pickup TextField itself (and whatever's typed into it)
                  // isn't lost: it's just not shown while _isEditingPickup
                  // is false, same as tapping its own close icon.
                  onTap: () {
                    if (_isEditingPickup) {
                      setState(() {
                        _isEditingPickup = false;
                        predictions = [];
                      });
                    }
                  },
                  onChanged: (value) {
                    if (!_isEditingPickup) _searchPlaces(value);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: "Where to?",
                    hintStyle: PoppinsReguler.copyWith(
                      fontSize: 14,
                      color: ColorResources.TextColorForGrey,
                    ),
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: ColorResources.textColorRed,
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 24,
                    ),
                    // Destination had no clear button at all — added to
                    // match pickup's, so either field can be emptied
                    // without backspacing through it manually.
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          _destinationController.clear();
                          predictions = [];
                        });
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_isCheckingLocation)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Checking availability...",
                      style: PoppinsReguler.copyWith(
                        fontSize: 13,
                        color: ColorResources.TextColorForGrey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                final place = predictions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: ColorResources.TextColorForGrey,
                  ),
                  title: Text(
                    place["structured_formatting"]["main_text"],
                    style: PoppinsMedium.copyWith(
                      fontSize: 14,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                  subtitle: Text(
                    place["description"],
                    style: PoppinsReguler.copyWith(
                      fontSize: 12,
                      color: ColorResources.TextColorForGrey,
                    ),
                  ),
                  onTap: () => _onPredictionTap(place),
                );
              },
            ),
        ],
      ),
    );
  }

  // ===================================================================
  // VEHICLE SELECT STAGE
  // ===================================================================

  Widget _vehicleContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _backToIdleFromVehicleSelect,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: ColorResources.blackcolor11,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Choose a ride",
                style: PoppinsSemiBold.copyWith(
                  fontSize: 15,
                  color: ColorResources.blackcolor11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _routeSummary(),
          const SizedBox(height: 14),
          if (_isLoadingEstimate)
            _vehicleGrid(List.generate(6, (_) => _vehicleCardSkeleton()))
          else
            GetBuilder<BookingController>(
              builder: (bc) {
                if (bc.vehicleList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "No vehicles available for this route",
                        style: PoppinsMedium.copyWith(
                          fontSize: 14,
                          color: ColorResources.TextColorForGrey,
                        ),
                      ),
                    ),
                  );
                }
                return _vehicleList(bc.vehicleList);
              },
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _isScheduled,
                  activeColor: ColorResources.blueeebutton,
                  onChanged: (value) {
                    if (value == true) {
                      _pickSchedule();
                    } else {
                      _clearSchedule();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Schedule Ride",
                style: PoppinsMedium.copyWith(
                  fontSize: 13,
                  color: ColorResources.blackcolor11,
                ),
              ),
            ],
          ),
          if (_isScheduled)
            GestureDetector(
              onTap: _pickSchedule,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorResources.greycolorborder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formattedDateTime.isEmpty
                          ? "Select Date & Time"
                          : _formattedDateTime,
                      style: PoppinsReguler.copyWith(
                        fontSize: 13,
                        color: ColorResources.blackcolor11,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: ColorResources.TextColorForGrey,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _book,
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ColorResources.brandGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: _isBooking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Next",
                      style: PoppinsSemiBold.copyWith(
                        fontSize: 15,
                        color: ColorResources.whiteColor,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Pickup/drop are always editable here, not just at the initial search
  /// step — a rider hailing on someone else's behalf routinely needs to
  /// swap the pickup away from their own current location (or fix the
  /// destination) after already seeing vehicle options, and previously had
  /// no way to do that short of backing out and losing the whole trip.
  Widget _routeSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorResources.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _editPickupFromVehicleSelect,
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 9,
                  color: ColorResources.blueeebutton,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _pickupAddress.isEmpty ? "Loading..." : _pickupAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PoppinsMedium.copyWith(
                      fontSize: 13,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                ),
                Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorResources.TextColorForGrey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _editDestinationFromVehicleSelect,
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 9,
                  color: ColorResources.textColorRed,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _dropAddress.isEmpty ? "Loading..." : _dropAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PoppinsMedium.copyWith(
                      fontSize: 13,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                ),
                Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorResources.TextColorForGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Looks up a vehicle type's image (from the vehicle-type-list API) by id,
  /// so the fare-estimate cards (which have no image field of their own)
  /// can still show the real backend image for that type.
  String? _imageForVehicleTypeId(int? typeId) {
    if (typeId == null) return null;
    for (final type in bookingController.vehicleTypeList) {
      if (type.id == typeId) return type.image;
    }
    return null;
  }

  /// Renders a vehicle type's image from the backend (`ApiConstants.imageurl`
  /// + the relative path), falling back to the local car icon when the API
  /// didn't provide one (e.g. "Sedan" in the sample response has image: null)
  /// or the network image fails to load.
  ///
  /// The backend serves at least two different photo templates: car photos
  /// (e.g. Sedan/SUV) are ~1536x1024 with a lot of gray padding around the
  /// car, while two-wheeler/auto photos (Bike, Scooty, the Auto variants,
  /// E Rikshaw) are near-square (~1.0-1.3 aspect) transparent PNGs that
  /// already fill most of their own frame. A single fixed BoxFit.cover crop
  /// tuned for one family cropped into the vehicle itself for the other, so
  /// this uses BoxFit.contain (which never crops, regardless of the source's
  /// aspect ratio) inside a fixed-aspect box, with a neutral backdrop so any
  /// letterboxing blends in instead of looking like empty space.
  static const double _vehicleImageAspectRatio = 1.5;

  /// Traced whenever a vehicle type doesn't have a usable image, at either
  /// the missing-field or the load-failure point — this fallback (the
  /// generic cart.png) is what "the vehicle cars on the bottom sheet
  /// aren't loading" looks like, and neither path was logged at all
  /// before, so there was no way to tell whether the backend simply never
  /// sent an image for that vehicle type or a real one failed to load.
  final Set<String> _loggedMissingVehicleImages = {};

  Widget _vehicleTypeImage(String? image) {
    if (image == null || image.isEmpty) {
      if (_loggedMissingVehicleImages.add('(empty)')) {
        debugPrint(
          '[VehicleImage] no image field on this vehicle type at all — falling back to cart.png',
        );
      }
      return Container(
        color: ColorResources.backgroundColor,
        child: Center(child: Image.asset('assets/images/cart.png', height: 26)),
      );
    }
    final resolvedUrl = '${ApiConstants.imageurl}$image';
    return Container(
      color: ColorResources.backgroundColor,
      child: Image.network(
        resolvedUrl,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 1.6),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          if (_loggedMissingVehicleImages.add(resolvedUrl)) {
            debugPrint('[VehicleImage] failed to load "$resolvedUrl": $error');
          }
          return Center(
            child: Image.asset('assets/images/cart.png', height: 26),
          );
        },
      ),
    );
  }

  /// Real vehicle options laid out as selectable grid cards.
  Widget _vehicleList(List<dynamic> vehicles) {
    return _vehicleGrid(
      List.generate(vehicles.length, (index) {
        final vehicle = vehicles[index];
        final selected = _selectedVehicleIndex == index;
        return _vehicleListCard(
          name: vehicle.name ?? "",
          durationText: vehicle.estimatedTime,
          price: "₹ ${vehicle.price ?? 0}",
          image: _imageForVehicleTypeId(vehicle.vehicleTypeId),
          selected: selected,
          onTap: () {
            setState(() {
              _selectedVehicleIndex = index;
              _estimatedPrice = vehicle.price?.toString() ?? "";
              _vehicleTypeId = vehicle.vehicleTypeId?.toString() ?? "";
            });
          },
        );
      }),
    );
  }

  /// Combines the real trip duration (from the API) with a computed arrival
  /// clock-time — e.g. "3:40 PM • 3 min". The clock-time is a derived
  /// calculation (now + duration), not fabricated data; if the duration
  /// string can't be parsed, we just fall back to showing it as-is.
  String _formatRowTime(String? durationText) {
    if (durationText == null || durationText.trim().isEmpty) return "";

    final match = RegExp(r'\d+').firstMatch(durationText);
    if (match == null) return durationText;

    final minutes = int.tryParse(match.group(0)!);
    if (minutes == null) return durationText;

    final arrival = DateTime.now().add(Duration(minutes: minutes));
    final clockLabel = DateFormat('h:mm a').format(arrival);
    final durationLabel = durationText.toLowerCase().contains('min')
        ? durationText
        : "$durationText min";

    return "$clockLabel • $durationLabel";
  }

  Widget _vehicleListCard({
    required String name,
    required String? durationText,
    required String price,
    String? image,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final String timeLabel = _formatRowTime(durationText);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? ColorResources.blueeebutton
                : ColorResources.greycolorborder,
            width: selected ? 1.6 : 1,
          ),
          color: selected
              ? ColorResources.blueeebutton.withValues(alpha: 0.05)
              : ColorResources.whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: _vehicleImageAspectRatio,
                    child: _vehicleRowAvatar(image),
                  ),
                ),
                if (selected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: ColorResources.blueeebutton,
                      size: 18,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackcolor11,
              ),
            ),
            if (timeLabel.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                timeLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PoppinsReguler.copyWith(
                  fontSize: 11,
                  color: ColorResources.TextColorForGrey,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              price,
              style: PoppinsSemiBold.copyWith(
                fontSize: 14,
                color: ColorResources.blackcolor11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleRowAvatar(String? image) {
    if (image == null || image.isEmpty) {
      return Container(
        color: ColorResources.backgroundColor,
        child: Center(child: Image.asset('assets/images/cart.png', height: 26)),
      );
    }
    return Container(
      color: ColorResources.backgroundColor,
      child: Image.network(
        '${ApiConstants.imageurl}$image',
        fit: BoxFit.contain,
        alignment: Alignment.center,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 1.6),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Image.asset('assets/images/cart.png', height: 26),
          );
        },
      ),
    );
  }
}
