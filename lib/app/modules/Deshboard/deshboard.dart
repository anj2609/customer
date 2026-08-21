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
import 'package:myrideuser/data/modal/address_Model.dart';
import 'package:myrideuser/data/modal/vehicle_type_model.dart';
import 'package:myrideuser/data/services/nearby_drivers_search.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

/// Which section the single bottom sheet is currently showing.
enum _SheetStage { idle, searching, vehicleSelect }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final ProfileController controller = Get.find<ProfileController>();
  final BookingController bookingController = Get.find<BookingController>();

  /// Drives the pulsating ring around the rider's own location on the map.
  late final AnimationController _pulseController;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

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
  double _mapPaddingForCurrentSheet() {
    final height = MediaQuery.of(context).size.height;
    final fraction = _sheetController.isAttached
        ? _sheetController.size
        : _stageSize(_stage);
    return fraction * height;
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

  String _currentAddress = "Loading...";
  LatLng? _pickupLatLng;
  String? _currentAdminArea;
  bool _isEditingPickup = false;
  bool _isCheckingLocation = false;

  static const List<String> _allowedStates = ['delhi', 'tripura'];

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncMapPaddingToSheet());
    // Drives the pulsating "you are here" ring — see _buildMap. repeat()
    // rather than a one-shot: this is an ambient indicator that runs for as
    // long as the map is on screen.
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
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

  @override
  void dispose() {
    _pulseController.dispose();
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
      _pickupLatLng = LatLng(pos.latitude, pos.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

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
    setState(() {
      _stage = _SheetStage.idle;
      predictions = [];
      _isEditingPickup = false;
      _destinationController.clear();
    });
    _animateSheetTo(_idleSize);
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
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_placesApiKey";

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

    if (mounted) {
      setState(() {
        _pickupLatLng = LatLng(loc['lat'], loc['lng']);
        _currentAddress = place['description'];
        _isEditingPickup = false;
        predictions = [];
      });
    }
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

    setState(() {
      _stage = _SheetStage.vehicleSelect;
      _isLoadingEstimate = true;
      _dropLatLng = LatLng(dropLat, dropLng);
      _dropAddress = dropAddressText;
      _pickupAddress = _currentAddress;
      _selectedVehicleIndex = -1;
      predictions = [];
    });
    _animateSheetTo(_vehicleSize);

    await _drawRoute();

    await bookingController.bookingestimateListApi(
      pickup_lat: _pickupLatLng!.latitude,
      pickup_lng: _pickupLatLng!.longitude,
      drop_lat: dropLat,
      drop_lng: dropLng,
      context: context,
      navigateToRideOption: false,
    );

    if (mounted) setState(() => _isLoadingEstimate = false);
  }

  // ================= ROUTE DRAWING (same Directions API logic as before) =================

  Future<void> _drawRoute() async {
    if (_pickupLatLng == null || _dropLatLng == null) return;

    setState(() {
      _routeMarkers = {
        Marker(
          markerId: const MarkerId("pickup"),
          position: _pickupLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
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
              child: Stack(
                children: [
                  _buildMap(),
                  _buildNearbyDriversStatus(),
                  _buildSheet(),
                ],
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
                                  text: "Good Morning, ",
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

  // ---------- Nearby-drivers status banner ----------
  //
  // Distinct UI for every state the search can be in — loading, found
  // (no banner, the map markers are the UI), explicitly empty ("no
  // drivers nearby" — not an error), and the three failure modes
  // (permission denied, GPS timeout, request failed), each with a retry.
  // Must be a direct Stack child (Positioned only works there) — the
  // reactive GetBuilder goes inside it, not the other way round.
  Widget _buildNearbyDriversStatus() {
    return Positioned(
      top: 12,
      left: 16,
      right: 16,
      child: GetBuilder<BookingController>(
        builder: (bc) {
          final state = bc.nearbyDriversSearch.state.value;

          if (state.phase == NearbyDriversPhase.idle ||
              state.phase == NearbyDriversPhase.success) {
            return const SizedBox.shrink();
          }

          String message;
          IconData icon;
          Color color;
          bool showRetry = false;
          bool showLoading = false;

          switch (state.phase) {
            case NearbyDriversPhase.locating:
              message = "Finding your location...";
              icon = Icons.my_location;
              color = ColorResources.blueeebutton;
              showLoading = true;
              break;
            case NearbyDriversPhase.searching:
              message = "Looking for nearby drivers...";
              icon = Icons.directions_car;
              color = ColorResources.blueeebutton;
              showLoading = true;
              break;
            case NearbyDriversPhase.empty:
              message = "No drivers nearby right now";
              icon = Icons.info_outline;
              color = ColorResources.TextColorForGrey;
              break;
            case NearbyDriversPhase.locationDenied:
              message = state.message ?? "Location permission needed";
              icon = Icons.location_off;
              color = ColorResources.textColorRed;
              showRetry = true;
              break;
            case NearbyDriversPhase.locationTimeout:
              message = state.message ?? "Couldn't get your location";
              icon = Icons.gps_off;
              color = ColorResources.textColorRed;
              showRetry = true;
              break;
            case NearbyDriversPhase.requestFailed:
              message = state.message ?? "Couldn't load nearby drivers";
              icon = Icons.error_outline;
              color = ColorResources.textColorRed;
              showRetry = true;
              break;
            case NearbyDriversPhase.idle:
            case NearbyDriversPhase.success:
              return const SizedBox.shrink();
          }

          return Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ColorResources.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Colors.black12),
                ],
              ),
              child: Row(
                children: [
                  showLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: color,
                          ),
                        )
                      : Icon(icon, color: color, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      message,
                      style: PoppinsMedium.copyWith(
                        fontSize: 12.5,
                        color: ColorResources.blackcolor11,
                      ),
                    ),
                  ),
                  if (showRetry)
                    GestureDetector(
                      onTap: () => bc.refreshNearbyDrivers(),
                      child: Text(
                        "Retry",
                        style: PoppinsSemiBold.copyWith(
                          fontSize: 12.5,
                          color: ColorResources.blueeebutton,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- Map ----------

  /// The expanding, fading ring drawn around the rider's own position — the
  /// "pulsating dot" that replaced the red default map pin that used to be
  /// dropped at [BookingController.currentLatLng].
  ///
  /// Drawn as a map Circle rather than a Flutter widget layered over the map
  /// because a Circle is anchored to real coordinates: it stays put through
  /// pans and zooms for free, where an overlaid widget would have to be
  /// re-projected to screen space on every camera frame to avoid sliding off
  /// the rider's actual location.
  ///
  /// Only shown in the idle stage. Once a route is on screen (vehicle
  /// selection) the map is about the pickup→drop line, and an animating ring
  /// over it is noise — it also stops the per-frame circle updates while the
  /// rider is reading fares.
  Set<Circle> _locationPulseCircles(LatLng center) {
    if (_stage != _SheetStage.idle) return const <Circle>{};

    final t = _pulseController.value;
    // Radius grows over the cycle while opacity falls to zero, so the ring
    // reads as a ripple radiating outward rather than a throbbing blob.
    final radius = 20 + (70 * t);
    final fade = (1 - t).clamp(0.0, 1.0);

    return {
      Circle(
        circleId: const CircleId('user_location_pulse'),
        center: center,
        radius: radius,
        fillColor: const Color(0xFF4285F4).withValues(alpha: 0.16 * fade),
        strokeColor: const Color(0xFF4285F4).withValues(alpha: 0.55 * fade),
        strokeWidth: 2,
      ),
    };
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
      mapController.moveCamera(
        CameraUpdate.scrollBy(0, _mapBottomPadding / 2),
      );
    });
  }

  Widget _buildMap() {
    return GetBuilder<BookingController>(
      builder: (bc) {
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: bc.currentLatLng,
                zoom: 14,
              ),
              // Google's own location indicator — the solid blue dot at the
              // centre of the pulse above. Left to the platform rather than
              // drawn here: it already tracks live position and heading, and
              // is the marker riders recognise as "me".
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              circles: _locationPulseCircles(bc.currentLatLng),
              // Without this, "centered" meant centered in the map widget's
              // full bounds, including the portion the bottom sheet
              // permanently covers — see _mapPaddingForCurrentSheet.
              padding: EdgeInsets.only(bottom: _mapBottomPadding),
              markers: _stage == _SheetStage.vehicleSelect
                  ? _routeMarkers
                  : bc.markers,
              polylines: _polylines,
              onMapCreated: (mapController) {
                bc.mapController = mapController;
                _nudgeCameraAboveSheet(mapController);
              },
            );
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
                    bottom: 16 +
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
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          setState(() {
                            _isEditingPickup = false;
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

  Widget _routeSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorResources.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 9, color: ColorResources.blueeebutton),
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
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.circle, size: 9, color: ColorResources.textColorRed),
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
            ],
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

  Widget _vehicleTypeImage(String? image) {
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
