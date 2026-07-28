import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

import 'package:myrideuser/app/modules/Promos/promos_screen.dart';
import 'package:myrideuser/app/modules/acoount/notification_screen.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
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

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

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
    controller.getAddressCustomer(context: context);
    Get.find<ProfileController>().getActivityData(
      context: context,
      typeOfSlug: 'ongoing',
    );
    Get.find<ProfileController>().customerWalletAmount();
    _loadCurrentAddress();
  }

  @override
  void dispose() {
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
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
            List<PointLatLng> decoded =
                PolylinePoints.decodePolyline(polyline);
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
      _formattedDateTime = "${_selectedDateTime!.year}-"
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
        body: Column(
          children: [
            SafeArea(bottom: false, child: _buildHeader()),
            Expanded(
              child: Stack(
                children: [
                  _buildMap(),
                  if (_stage == _SheetStage.idle) _buildNearbyCarsBanner(),
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

  // ---------- Map ----------

  Widget _buildMap() {
    return GetBuilder<BookingController>(
      builder: (bc) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: bc.currentLatLng,
            zoom: 14,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          markers: _stage == _SheetStage.vehicleSelect
              ? _routeMarkers
              : bc.markers,
          polylines: _polylines,
          onMapCreated: (mapController) {
            bc.mapController = mapController;
          },
        );
      },
    );
  }

  // ---------- "X cars available near you" banner ----------

  Widget _buildNearbyCarsBanner() {
    return Positioned(
      top: 12,
      left: 16,
      right: 16,
      child: GetBuilder<BookingController>(
        builder: (bc) {
          final count = bc.driverAvailableNearBy.length;
          return GestureDetector(
            onTap: _openSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ColorResources.brandGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: ColorResources.blueeebutton.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          count > 0
                              ? "$count cars available near you"
                              : "Searching cars near you…",
                          style: PoppinsSemiBold.copyWith(
                            fontSize: 14,
                            color: ColorResources.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Tap to book your ride",
                          style: PoppinsReguler.copyWith(
                            fontSize: 12,
                            color: ColorResources.whiteColor.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: ColorResources.whiteColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
            boxShadow: const [
              BoxShadow(blurRadius: 16, color: Colors.black12),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: 16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dragHandle(),
                switch (_stage) {
                  _SheetStage.idle => _idleContent(),
                  _SheetStage.searching => _searchContent(),
                  _SheetStage.vehicleSelect => _vehicleContent(),
                },
              ],
            ),
          ),
        );
      },
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

  Widget _idleContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _whereToBar(),
          const SizedBox(height: 18),
          _quickActionsRow(),
          const SizedBox(height: 18),
          _promoBanner(),
          const SizedBox(height: 20),
          _recentPlacesSection(),
          const SizedBox(height: 20),
          _chooseRideSection(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

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
                  Icon(Icons.search, color: ColorResources.TextColorForGrey, size: 20),
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
                Icon(Icons.access_time_rounded, size: 16, color: ColorResources.whiteColor),
                const SizedBox(width: 6),
                Text(
                  _isScheduled ? "Scheduled" : "Now",
                  style: PoppinsMedium.copyWith(
                    fontSize: 13,
                    color: ColorResources.whiteColor,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.white),
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
          subtitle: _findAddressByLabel('home') != null ? "Go home" : "Set location",
          onTap: () => _onQuickAction('home'),
        ),
        _quickActionItem(
          icon: Icons.work_rounded,
          label: "Work",
          subtitle: _findAddressByLabel('work') != null ? "Go to work" : "Set location",
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

        return GestureDetector(
          onTap: () => Get.to(() => PromoScreen()),
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
                if (image != null && image.isNotEmpty)
                  Positioned.fill(
                    child: Image.network(
                      '${ApiConstants.imageurl}$image',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                // Scrim so text stays readable over an arbitrary photo.
                if (image != null && image.isNotEmpty)
                  Positioned.fill(
                    child: Container(color: Colors.black.withValues(alpha: 0.25)),
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
                          color: ColorResources.whiteColor.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                              color: ColorResources.blueeebutton.withValues(alpha: 0.08),
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
                                if (data.address != null && data.address!.isNotEmpty)
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
            if (bc.isVehicleTypeLoading) {
              return _vehicleSkeletonGrid();
            }
            if (bc.vehicleTypeList.isEmpty) {
              return _vehicleSkeletonGrid();
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 10.0;
                final cardWidth = (constraints.maxWidth - spacing * 2) / 3;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: bc.vehicleTypeList.map((type) {
                    return SizedBox(
                      width: cardWidth,
                      child: _idleVehicleTypeCard(type),
                    );
                  }).toList(),
                );
              },
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorResources.greycolorborder),
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: _vehicleTypeImage(type.image),
            ),
            const SizedBox(height: 6),
            Text(
              type.name ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsMedium.copyWith(
                fontSize: 12,
                color: ColorResources.blackcolor11,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 40,
              height: 10,
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
                child: Icon(Icons.arrow_back_rounded, color: ColorResources.blackcolor11),
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
                        Icon(Icons.my_location, size: 18, color: ColorResources.blueeebutton),
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
                        Icon(Icons.edit, size: 14, color: ColorResources.TextColorForGrey),
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
                  style: PoppinsReguler.copyWith(fontSize: 14),
                  onChanged: (value) {
                    if (!_isEditingPickup) _searchPlaces(value);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Where to?",
                    hintStyle: PoppinsReguler.copyWith(
                      fontSize: 14,
                      color: ColorResources.TextColorForGrey,
                    ),
                    prefixIcon: Icon(Icons.location_on_outlined,
                        size: 20, color: ColorResources.textColorRed),
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
                  leading: Icon(Icons.location_on_outlined,
                      color: ColorResources.TextColorForGrey),
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
                child: Icon(Icons.arrow_back_rounded, color: ColorResources.blackcolor11),
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
            _vehicleSkeletonGrid()
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
                return _vehicleGrid(bc.vehicleList);
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
                    Icon(Icons.calendar_today, size: 16, color: ColorResources.TextColorForGrey),
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
  /// The backend's vehicle-type photos are all the same template: a car
  /// centered in a large gray canvas with the "N RIDE" door branding —
  /// analysis of the live images shows the car+logo consistently occupies
  /// only the middle ~52% of the photo's height. Shrinking the whole padded
  /// photo down to icon size (the old behavior) made the logo illegible, so
  /// instead we fill the card's full width and crop vertically (via a wider
  /// aspect ratio + BoxFit.cover, centered) to zoom into just that band.
  static const double _vehicleImageAspectRatio = 2.9;

  Widget _vehicleTypeImage(String? image) {
    if (image == null || image.isEmpty) {
      return AspectRatio(
        aspectRatio: _vehicleImageAspectRatio,
        child: Center(
          child: Image.asset('assets/images/cart.png', height: 26),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: _vehicleImageAspectRatio,
        child: Image.network(
          '${ApiConstants.imageurl}$image',
          fit: BoxFit.cover,
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
      ),
    );
  }

  /// Real vehicle cards, laid out in the exact same card "slots" as the
  /// idle-stage Mini/Sedan/SUV preview — 3 per row, wrapping if there are more.
  Widget _vehicleGrid(List<dynamic> vehicles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final cardWidth = (constraints.maxWidth - spacing * 2) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(vehicles.length, (index) {
            final vehicle = vehicles[index];
            final selected = _selectedVehicleIndex == index;
            return SizedBox(
              width: cardWidth,
              child: _vehicleCard(
                name: vehicle.name ?? "",
                subtitle: vehicle.estimatedTime ?? "",
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
              ),
            );
          }),
        );
      },
    );
  }

  Widget _vehicleCard({
    required String name,
    required String subtitle,
    required String price,
    String? image,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? ColorResources.blueeebutton
                : ColorResources.greycolorborder,
            width: selected ? 1.4 : 1,
          ),
          color: selected
              ? ColorResources.blueeebutton.withValues(alpha: 0.05)
              : ColorResources.whiteColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: _vehicleTypeImage(image),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsMedium.copyWith(
                fontSize: 12,
                color: ColorResources.blackcolor11,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
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
            const SizedBox(height: 6),
            Text(
              price,
              style: PoppinsSemiBold.copyWith(
                fontSize: 13,
                color: ColorResources.blackcolor11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleSkeletonGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final cardWidth = (constraints.maxWidth - spacing * 2) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(
            3,
            (_) => SizedBox(width: cardWidth, child: _vehicleCardSkeleton()),
          ),
        );
      },
    );
  }

  Widget _vehicleCardSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorResources.greycolorborder),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: _vehicleImageAspectRatio,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorResources.blueeebutton.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 44,
            height: 10,
            decoration: BoxDecoration(
              color: ColorResources.blueeebutton.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 34,
            height: 10,
            decoration: BoxDecoration(
              color: ColorResources.backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
