import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myrideuser/app/modules/Deshboard/buttom_navigation.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';

import 'package:myrideuser/data/modal/banner_model.dart';
import 'package:myrideuser/data/modal/cancellation_model.dart';
import 'package:myrideuser/data/modal/driveravailable_model.dart';
import 'package:myrideuser/data/modal/trackride_model.dart';
import 'package:myrideuser/data/modal/trip_detail_model.dart';
import 'package:myrideuser/data/services/nearby_drivers_search.dart';
import 'package:myrideuser/data/modal/vehicle_model.dart';
import 'package:myrideuser/data/modal/vehicle_type_model.dart';
import 'package:myrideuser/data/modal/rental_estimate_model.dart';
import 'package:myrideuser/data/modal/outstation_estimate_model.dart';
import 'package:myrideuser/data/repository/booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BookingStatus {
  pending,
  accepted,
  arrived,
  ongoing,
  completed,
  cancelled,
  none,
  unknown,
}

class BookingActiveState {
  final String? bookingId;
  final BookingStatus status;
  const BookingActiveState({this.bookingId, this.status = BookingStatus.none});
}

class BookingController extends GetxController implements GetxService {
  final BookingRepo bookingRepo;

  BookingController({
    required this.bookingRepo,
    // required profileRepo
  });

  //// ====== Google SignIn =============== //////////////
  ///final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  List<VehicleModel> vehicleList = [];
  List<VehicleTypeModel> vehicleTypeList = [];
  bool isVehicleTypeLoading = false;
  bool isHomeBannerLoading = false;
  BannerModel? homeBanner;
  RxString rideStatus = "pending".obs;
//    RxString rideStatus = "pending".obs;

  // RxMap rideData = {}.obs;
  RxString tridRideDetails = "pending".obs;
  RxMap tridRideDetailsData = {}.obs;
  // Typed parse of the same /trip-detail response above — used for the
  // real price breakdown (base fare, platform fee, CGST, SGST, final
  // amount, etc.) wherever a booking actually exists. The raw Map above
  // is left as-is since other code already reads other fields off it.
  Rx<TripDetailModel?> tripDetailModel = Rx<TripDetailModel?>(null);

  /// Latches the last /trip-detail snapshot that actually carried a real
  /// duration/distance. tripDetailModel above keeps getting overwritten by
  /// this same 3s poll for as long as findingdriver_screen stays mounted —
  /// including all the way through the payment step — and if a later poll,
  /// once the booking is further along (paid/closed out), ever comes back
  /// without those two fields, the rating screen would silently lose values
  /// it had already shown correctly moments earlier on the "You have
  /// arrived!" sheet. Only ever updated when the fresh data actually has
  /// something in it, so it always holds the last real reading rather than
  /// being blanked out by a subsequent response that doesn't.
  TripDetailData? completedTripStats;

  /// The real fare components (base fare, CGST, SGST, booking fee, platform
  /// fee) for the booking this app session created, captured from
  /// create-booking's `fare_details` — see
  /// [PriceBreakdown.fromCreateBooking].
  ///
  /// create-booking is the only endpoint confirmed to return these.
  /// trip-detail, which every fare display actually reads from, often sends
  /// only the lighter `payment` object, which carries no tax or fee
  /// components at all — so without holding on to this, the receipt has
  /// nothing to itemise and collapses to subtotal-and-total.
  ///
  /// Persisted rather than kept purely in memory so the breakdown survives
  /// the app being killed and reopened mid-ride, which is exactly when the
  /// rider is most likely to be looking at it.
  PriceBreakdown? _createdBreakdown;
  String? _createdBreakdownBookingId;
  TrackRideModel? trackRideModel;
  DatTrackRideDetails? rideDetails;
  DriverInfo? driverInfo;

  List<CancelationModelData> cancelationList = [];
  int selectedReason = -1;
  int? selectedReasonId;
  Set<Marker> markers = {};
  BitmapDescriptor? driverCarIcons;

  GoogleMapController? mapController;
  LatLng currentLatLng = const LatLng(28.5355, 77.3910);
  bool _isMapReady = false;
  bool _isDisposed = false;

  /// Owns the whole "find nearby drivers" flow (location capture, the
  /// backend request, auto-refresh, and every resulting state — loading /
  /// found / empty / denied / timed out / failed). Replaces the old
  /// one-shot getCurrentLocation()-does-everything approach, which fetched
  /// location and nearby drivers exactly once at app startup and never
  /// again, and silently showed nothing on any kind of failure.
  late final NearbyDriversSearch nearbyDriversSearch;

  final Rx<BookingActiveState> activeBookingState =
      BookingActiveState().obs;

  /// Cross-tab navigation signal: which bottom-nav tab is active, and
  /// whether the Home tab should auto-open its destination search as soon
  /// as it mounts (set when a vehicle is tapped on the Services tab).
  final RxInt bottomNavIndex = 0.obs;
  final RxBool pendingOpenSearch = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    // _googleSignIn.initialize(
    //   serverClientId:
    //       "816050400087-4pv5deujt52p78pv3u785cf32f9cv269.apps.googleusercontent.com",
    // );

    nearbyDriversSearch = NearbyDriversSearch(
      locationClient: const GeolocatorLocationClient(),
      fetchNearbyDrivers: (lat, lng) =>
          bookingRepo.driverAvailbledata(latitude: lat, longitude: lng),
    );
    // Redraw markers on every state change (loading/found/empty/error) —
    // setMarkers() itself decides what (if anything) to show for each.
    ever<NearbyDriversState>(nearbyDriversSearch.state, (_) => setMarkers());
    nearbyDriversSearch.search();

    // Was started here unconditionally — since BookingController itself is a
    // fenix:true singleton alive for the whole app session (created on first
    // Get.find(), never disposed just for navigating away), that meant
    // driver-availble-list was polled every 20s continuously for as long as
    // the app was open, on every screen — chat, profile, promos, even mid-ride
    // — not just the home/map tab that actually shows these markers. The
    // service's own doc comment already says it's meant to run "while the
    // rider is on a screen that shows nearby drivers"; this wires it to
    // actually do that instead of running unconditionally for the app's
    // entire lifetime.
    _syncNearbyDriversAutoRefresh();
    ever<int>(bottomNavIndex, (_) => _syncNearbyDriversAutoRefresh());
    ever<BookingActiveState>(
      activeBookingState,
      (_) => _syncNearbyDriversAutoRefresh(),
    );

    loadCarIcon();
    getVehicleTypeList();
    getHomeBanner();
  }

  @override
  void onClose() {
    // Was declared but never actually set — the pending home-banner retry
    // Future (see getHomeBanner()) is delayed up to several seconds, and
    // without this its callback could still fire and call update() on a
    // controller GetX has already torn down.
    _isDisposed = true;
    nearbyDriversSearch.dispose();
    super.onClose();
  }

  /// Manual retry/refresh — wired to the "tap to retry" and "no drivers
  /// nearby" UI states, and to a pull-to-refresh if one is added later.
  Future<void> refreshNearbyDrivers() => nearbyDriversSearch.search();

  /// Starts or stops the nearby-drivers 20s poll to match whether its
  /// markers are actually visible: the Home tab, with no ride already booked
  /// (once a ride is active the rider has a driver — there's nothing left to
  /// search for, and findingdriver_screen has its own 3s tracking poll for
  /// that). Re-run on every relevant state change via the `ever` workers in
  /// onInit — a plain if-check at those call sites, rather than a bigger
  /// rework of nearbyDriversSearch's own lifecycle, since it already exposes
  /// exactly the start/stop calls this needs.
  void _syncNearbyDriversAutoRefresh() {
    final bool onHomeTab = bottomNavIndex.value == 0;
    final bool hasActiveBooking =
        activeBookingState.value.status != BookingStatus.none;

    if (onHomeTab && !hasActiveBooking) {
      nearbyDriversSearch.startAutoRefresh();
    } else {
      nearbyDriversSearch.stopAutoRefresh();
    }
  }

  /// getHomeBanner() runs once from onInit(), at the same moment as every
  /// other startup call this controller fires (nearby drivers, vehicle
  /// types, etc.) — right when BookingController is first constructed after
  /// login/app-resume. ApiClient's own known-issue comment
  /// (_handleSessionExpiry, "Header User id is required") already documents
  /// that this exact endpoint shape can come back 401 from a startup race
  /// before the auth headers are consistently attached, and — correctly —
  /// treats that as "not a real session expiry". But nothing here ever
  /// retried after that, so a banner that lost that race just stayed blank
  /// (silently, behind the gradient fallback) for the rest of the app
  /// session: exactly the "doesn't load in production" pattern reported,
  /// since production networks/devices hit that startup window far more
  /// often than a dev device sitting next to a debugger. Bounded retries
  /// below give the same request a few more chances once that race has had
  /// time to resolve, instead of a single unrepeated attempt.
  int _homeBannerRetryCount = 0;
  static const int _homeBannerMaxRetries = 3;

  /////==========  home screen promo banner (title/sub_title/image)  ======================///////
  Future<void> getHomeBanner() async {
    isHomeBannerLoading = true;
    update();

    bool succeeded = false;
    try {
      Response response = await bookingRepo.getBannerApi();

      if (response.statusCode == 200 && response.body is Map) {
        final body = Map<String, dynamic>.from(response.body);
        final data = body['data'];

        // The API has returned both a single object and a list of banners.
        // Accept either shape so an otherwise valid response does not leave
        // the UI on its static fallback.
        final dynamic bannerData = data is List && data.isNotEmpty
            ? data.first
            : data;

        if (bannerData is Map) {
          homeBanner = BannerModel.fromJson(
            Map<String, dynamic>.from(bannerData),
          );
          // The banner Container's own errorBuilder only fires once
          // Image.network actually attempts (and fails) to load a URL — an
          // empty/null image field here never reaches that point at all, and
          // silently produces the exact same "nothing shown" result. This is
          // what actually shows what the backend sent, empty or not.
          // Was log() (dart:developer) — not reliably visible in adb
          // logcat on a real device, the same visibility gap already found
          // and fixed once this session in api_client.dart. That's very
          // likely why this exact "banner image not showing" symptom has
          // stayed unresolved despite the trace already being here: the
          // one thing meant to catch it couldn't actually be seen.
          debugPrint('[HomeBanner] image field: "${homeBanner?.image}"');
          succeeded = true;
        }
      } else {
        debugPrint(
          '[HomeBanner] request failed: status ${response.statusCode}, '
          'body ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('[HomeBanner] error: $e');
    } finally {
      isHomeBannerLoading = false;
      update();
    }

    if (succeeded) {
      _homeBannerRetryCount = 0;
    } else if (_homeBannerRetryCount < _homeBannerMaxRetries) {
      _homeBannerRetryCount++;
      // 2s, 4s, 6s — long enough for a genuine startup-header race (or a
      // transient network blip) to have cleared, short enough the banner
      // still shows up well within the same Home-tab visit rather than the
      // rider having to background/reopen the app to see it.
      final delay = Duration(seconds: 2 * _homeBannerRetryCount);
      log(
        'Home banner retry $_homeBannerRetryCount/$_homeBannerMaxRetries '
        'in ${delay.inSeconds}s',
      );
      Future.delayed(delay, () {
        if (!_isDisposed) getHomeBanner();
      });
    }
  }

  /////==========  vehicle type list (names + images shown on the home screen)  ======================///////
  Future<void> getVehicleTypeList() async {
    isVehicleTypeLoading = true;
    update();

    try {
      Response response = await bookingRepo.vehicleTypeListApi();

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['code'].toString() == '200') {
        vehicleTypeList.clear();
        List<dynamic> dataList = response.body['data'] ?? [];
        for (var item in dataList) {
          vehicleTypeList.add(VehicleTypeModel.fromJson(item));
        }
      }
    } catch (e) {
      log('Vehicle type list error: $e');
    } finally {
      isVehicleTypeLoading = false;
      update();
    }
  }

  /////==========  rental vehicle + price estimate for N hours  ======================///////
  List<RentalEstimateModel> rentalEstimateList = [];
  bool isRentalEstimateLoading = false;

  Future<void> getRentalEstimate(int hours) async {
    isRentalEstimateLoading = true;
    rentalEstimateList = [];
    update();

    try {
      Response response = await bookingRepo.rentalEstimateApi(hours: hours);

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['code'].toString() == '200') {
        List<dynamic> dataList = response.body['data'] ?? [];
        rentalEstimateList =
            dataList.map((item) => RentalEstimateModel.fromJson(item)).toList();
      }
    } catch (e) {
      log('Rental estimate error: $e');
    } finally {
      isRentalEstimateLoading = false;
      update();
    }
  }

  /// The /rental/estimate row for a given package, or null if the estimate has
  /// since been refreshed for a different duration and no longer holds it.
  RentalEstimateModel? rentalEstimateFor(int packageId) {
    for (final estimate in rentalEstimateList) {
      if (estimate.packageId == packageId) return estimate;
    }
    return null;
  }

  /////==========  outstation vehicle + price estimate for a trip  ======================///////
  List<OutstationEstimateModel> outstationEstimateList = [];
  bool isOutstationEstimateLoading = false;
  // Non-null only when the backend rejects the trip itself (e.g. under the
  // 150km minimum) — distinct from "no vehicles", since that's a real
  // reason from the server, not an empty catalog.
  String? outstationEstimateError;

  Future<void> getOutstationEstimate({
    required String tripType,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    isOutstationEstimateLoading = true;
    outstationEstimateList = [];
    outstationEstimateError = null;
    update();

    try {
      Response response = await bookingRepo.outstationEstimateApi(
        tripType: tripType,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
      );

      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['code'].toString() == '200') {
        List<dynamic> dataList = response.body['data'] ?? [];
        outstationEstimateList = dataList
            .map((item) => OutstationEstimateModel.fromJson(item))
            .toList();
      } else if (response.body is Map && response.body['message'] != null) {
        outstationEstimateError = response.body['message'].toString();
      }
    } catch (e) {
      log('Outstation estimate error: $e');
    } finally {
      isOutstationEstimateLoading = false;
      update();
    }
  }

  /// The /outstation/estimate row for a given pricing id, or null if the
  /// estimate has since been re-run for a different trip and no longer holds
  /// it.
  OutstationEstimateModel? outstationEstimateFor(int outstationPricingId) {
    for (final estimate in outstationEstimateList) {
      if (estimate.outstationPricingId == outstationPricingId) return estimate;
    }
    return null;
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        print("Location permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLatLng = LatLng(position.latitude, position.longitude);

      print("Lat: ${currentLatLng.latitude}");
      print("Lng: ${currentLatLng.longitude}");

      // Show the current-location pin immediately. The nearby-drivers
      // search (location capture + timeout/permission handling + the
      // actual API call) is owned entirely by nearbyDriversSearch now —
      // see onInit() — so this method only needs to place the "you are
      // here" pin for map-centering purposes elsewhere in the app.
      setMarkers();

      update();
    } catch (e) {
      print("Location Error: $e");
    }
  }

  Future<Response> bookingestimateListApi({
    required BuildContext context,
    double? pickup_lat,
    double? pickup_lng,
    double? drop_lat,
    double? drop_lng,
    bool navigateToRideOption = true,
  }) async {
  //  EasyLoading.show();
    update();

    Response response = await bookingRepo.bookingestimateListUrl(
      pickup_lat: pickup_lat,
      pickup_lng: pickup_lng,
      drop_lat: drop_lat,
      drop_lng: drop_lng,
    );

    if (response.statusCode == 200) {
      if (response.body['code'] == '200') {
        vehicleList.clear();

        List<dynamic> dataList = response.body['data'];

        for (var item in dataList) {
          vehicleList.add(VehicleModel.fromJson(item));
        }

        log('Vehicle List Length: ${vehicleList.length}');

       /// EasyLoading.dismiss();

        if (navigateToRideOption) {
          Get.toNamed(
            RouteHelper.getrideOptionScreen(),
            arguments: {
              "pickup_lat": pickup_lat,
              "pickup_lng": pickup_lng,
              "drop_lat": drop_lat,
              "drop_lng": drop_lng,
            },
          );
        }
      } else {
       // EasyLoading.dismiss();
         AnimatedTopToast.show(
         context: context,
         message:
             _getUserFriendlyMessage(response.body['message'] ?? "Oops! Something went wrong. Please try again."),
         backgroundColor: ColorResources.textColorBaclColor,
         icon: Icons.error_outline,
       );
        // Get.snackbar(
        //   'Error',
        //   response.body['error'] ?? "Something went wrong",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
      }
    } else if (response.statusCode == 422) {
       AnimatedTopToast.show(
        context: context,
        message:
            _getUserFriendlyMessage(response.body['message'] ?? "Please check your details and try again."),
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    } else {
      AnimatedTopToast.show(
        context: context,
        message: "Unable to get ride estimates. Please check your connection and try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    }

    update();
    return response;
  }

  /// The /estimate-ride-list row for a given vehicle type, or null if the
  /// estimate has since been cleared or never returned that vehicle. Callers
  /// treat a null as "let the backend price it" rather than sending zeros.
  VehicleModel? selectedEstimateFor(String vehicleTypeId) {
    final String id = vehicleTypeId.trim();
    if (id.isEmpty) return null;

    for (final vehicle in vehicleList) {
      if (vehicle.vehicleTypeId?.toString() == id) return vehicle;
    }
    return null;
  }

  Future<Response> CreateBooking({
    required BuildContext context,
    required double? pickup_lat,
    required double? pickup_lng,
    required double? drop_lat,
    required double? drop_lng,
    required String estimated_price,
    required String vehicle_type_id,
    required String pickup_address,
    required String drop_address,
    required String is_schedule,
    required String schedule_date_time,
  }) async {
    update();

    // Backup validation — prevent API call with empty required fields
    if (vehicle_type_id.trim().isEmpty) {
      AnimatedTopToast.show(
        context: context,
        message: "Please select a vehicle type before booking.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
      update();
      return Response(statusCode: 400, statusText: 'vehicle_type_id empty');
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // The fare breakdown belongs to the vehicle row the rider picked on the
      // estimate screen, so it is read back out of the stored estimate here
      // rather than threaded through every booking screen by hand.
      final VehicleModel? estimate = selectedEstimateFor(vehicle_type_id);

      // Diagnostic: if this logs "estimate=NULL", the fare/distance/duration
      // fields are being omitted because no matching row was found in
      // vehicleList (its length and the id searched are printed so the
      // mismatch is obvious) — not because the repo isn't sending them. If it
      // logs a real row but the server still receives none of the extra
      // fields, the running build is stale.
      debugPrint(
        '[CreateBooking] vehicle_type_id=$vehicle_type_id '
        'vehicleList=${vehicleList.length} '
        'estimate=${estimate == null ? "NULL" : "found "
            "dist=${estimate.distanceKm} min=${estimate.estimatedMinutes} "
            "base=${estimate.basePrice} plat=${estimate.platformFee} "
            "gstP=${estimate.gstPercent} gstA=${estimate.gstAmount}"}',
      );

      Response response = await bookingRepo.createBookingApi(
        pickup_lat: pickup_lat!,
        pickup_lng: pickup_lng!,
        drop_lat: drop_lat!,
        drop_lng: drop_lng!,
        estimated_price: estimated_price,
        vehicle_type_id: vehicle_type_id,
        pickup_address: pickup_address,
        drop_address: drop_address,
        is_schedule: is_schedule,
        schedule_date_time: schedule_date_time,
        estimated_distance: estimate?.distanceKm,
        estimated_duration: estimate?.estimatedMinutes,
        base_price: estimate?.basePrice,
        platform_fee: estimate?.platformFee,
        gst_percent: estimate?.gstPercent,
        gst_amount: estimate?.gstAmount,
      );

      // Safe-read the response body
      final body = response.body;
      final String code = (body is Map && body['code'] != null)
          ? body['code'].toString()
          : '';
      final String rawMessage = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : '';

      debugPrint('CreateBooking Response: status=${response.statusCode}, body=$body');

      // Convert backend error messages to user-friendly text
      String userMessage = _getUserFriendlyMessage(rawMessage);

      if (code == '200') {
        // Dismiss the loader before navigating
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        AnimatedTopToast.show(
          context: context,
          message: userMessage.isNotEmpty ? userMessage : "Ride booked successfully!",
          backgroundColor: ColorResources.appColor,
          icon: Icons.check_circle_rounded,
        );

        print("Booking ID: ${body['data']}");

        var bookingid = body['data']['booking_id'].toString();
        print("Booking ID: $bookingid");

        // Capture the itemised fare while we actually have it. This is the
        // only response that carries base fare / CGST / SGST / booking fee /
        // platform fee; trip-detail (what the fare card reads) frequently
        // does not, and once this response is discarded there is nowhere
        // left to recover the components from.
        await _rememberCreatedBreakdown(bookingid, body['data']);

        await Future.delayed(const Duration(milliseconds: 500));

        Get.toNamed(
          RouteHelper.getfindingDriverUI(),
          arguments: {'booking_id': bookingid},
        );

        await prefs.setString(ApiConstants.bookingid, bookingid);
        print("Booking ID: ${prefs.get(ApiConstants.bookingid)}");
      } else {
        // Error case — show user-friendly error toast
        AnimatedTopToast.show(
          context: context,
          message: userMessage.isNotEmpty
              ? userMessage
              : "Unable to book ride. Please try again.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }

      update();
      return response;
    } catch (e) {
      debugPrint('CreateBooking Error: $e');

      AnimatedTopToast.show(
        context: context,
        message: "Something went wrong. Please check your connection and try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );

      update();
      rethrow;
    }
  }

  Future<Response> CreateRentalBooking({
    required BuildContext context,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    required num estimatedPrice,
    required int vehicleTypeId,
    required String pickupAddress,
    required String dropAddress,
    required int packageId,
    required int finalHour,
    num? finalDistance,
  }) async {
    update();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fare breakdown for the package the rider picked, read back out of the
      // stored /rental/estimate result — same approach as CreateBooking.
      final RentalFareDetails? fare =
          rentalEstimateFor(packageId)?.fareDetails;

      Response response = await bookingRepo.createRentalBookingApi(
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        estimatedPrice: estimatedPrice,
        vehicleTypeId: vehicleTypeId,
        pickupAddress: pickupAddress,
        dropAddress: dropAddress,
        packageId: packageId,
        finalHour: finalHour,
        finalDistance: finalDistance,
        basePrice: fare?.basePrice,
        platformFee: fare?.platformFee,
        gstPercent: fare?.gstPercent,
        gstAmount: fare?.gstAmount,
      );

      final body = response.body;
      final String code = (body is Map && body['code'] != null)
          ? body['code'].toString()
          : '';
      final String rawMessage = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : '';

      debugPrint('CreateRentalBooking Response: status=${response.statusCode}, body=$body');

      String userMessage = _getUserFriendlyMessage(rawMessage);

      if (code == '200') {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        AnimatedTopToast.show(
          context: context,
          message: userMessage.isNotEmpty ? userMessage : "Rental booked successfully!",
          backgroundColor: ColorResources.appColor,
          icon: Icons.check_circle_rounded,
        );

        var bookingid = body['data']['booking_id'].toString();

        await Future.delayed(const Duration(milliseconds: 500));

        Get.toNamed(
          RouteHelper.getfindingDriverUI(),
          arguments: {'booking_id': bookingid},
        );

        await prefs.setString(ApiConstants.bookingid, bookingid);
      } else {
        AnimatedTopToast.show(
          context: context,
          message: userMessage.isNotEmpty
              ? userMessage
              : "Unable to book rental. Please try again.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }

      update();
      return response;
    } catch (e) {
      debugPrint('CreateRentalBooking Error: $e');

      AnimatedTopToast.show(
        context: context,
        message: "Something went wrong. Please check your connection and try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );

      update();
      rethrow;
    }
  }

  Future<Response> CreateOutstationBooking({
    required BuildContext context,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    required num estimatedPrice,
    required int vehicleTypeId,
    required String pickupAddress,
    required String dropAddress,
    required int isSchedule,
    required String scheduleDateTime,
    required int outstationPricingId,
    required String tripType,
    required num estimatedDistance,
    required num estimatedDuration,
    required num billableDistance,
    required int estimatedDays,
    required num driverAllowance,
  }) async {
    update();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fare breakdown for the pricing row the rider picked, read back out of
      // the stored /outstation/estimate result — same approach as the
      // city-ride and rental bookings.
      final OutstationFareDetails? fare =
          outstationEstimateFor(outstationPricingId)?.fareDetails;

      Response response = await bookingRepo.createOutstationBookingApi(
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        estimatedPrice: estimatedPrice,
        vehicleTypeId: vehicleTypeId,
        pickupAddress: pickupAddress,
        dropAddress: dropAddress,
        isSchedule: isSchedule,
        scheduleDateTime: scheduleDateTime,
        outstationPricingId: outstationPricingId,
        tripType: tripType,
        estimatedDistance: estimatedDistance,
        estimatedDuration: estimatedDuration,
        billableDistance: billableDistance,
        estimatedDays: estimatedDays,
        driverAllowance: driverAllowance,
        basePrice: fare?.basePrice,
        platformFee: fare?.platformFee,
        gstPercent: fare?.gstPercent,
        gstAmount: fare?.gstAmount,
      );

      final body = response.body;
      final String code = (body is Map && body['code'] != null)
          ? body['code'].toString()
          : '';
      final String rawMessage = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : '';

      debugPrint('CreateOutstationBooking Response: status=${response.statusCode}, body=$body');

      String userMessage = _getUserFriendlyMessage(rawMessage);

      if (code == '200') {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        AnimatedTopToast.show(
          context: context,
          message: userMessage.isNotEmpty ? userMessage : "Outstation ride booked successfully!",
          backgroundColor: ColorResources.appColor,
          icon: Icons.check_circle_rounded,
        );

        var bookingid = body['data']['booking_id'].toString();

        await Future.delayed(const Duration(milliseconds: 500));

        Get.toNamed(
          RouteHelper.getfindingDriverUI(),
          arguments: {'booking_id': bookingid},
        );

        await prefs.setString(ApiConstants.bookingid, bookingid);
      } else {
        AnimatedTopToast.show(
          context: context,
          message: userMessage.isNotEmpty
              ? userMessage
              : "Unable to book outstation ride. Please try again.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }

      update();
      return response;
    } catch (e) {
      debugPrint('CreateOutstationBooking Error: $e');

      AnimatedTopToast.show(
        context: context,
        message: "Something went wrong. Please check your connection and try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );

      update();
      rethrow;
    }
  }

  /// Converts raw backend error messages to user-friendly text
  String _getUserFriendlyMessage(String backendMessage) {
    final msg = backendMessage.toLowerCase().trim();

    if (msg.contains('server') || msg.contains('internal') || msg.contains('exception') || msg.contains('500')) {
      return "We're having trouble connecting. Please try again.";
    }
    if (msg.contains('vehicle') && msg.contains('required')) {
      return "Please select a vehicle type before booking.";
    }
    if (msg.contains('pickup') && msg.contains('required')) {
      return "Please set your pickup location.";
    }
    if (msg.contains('drop') && msg.contains('required')) {
      return "Please set your drop-off location.";
    }
    if (msg.contains('price') && msg.contains('required')) {
      return "Unable to calculate fare. Please try again.";
    }
    if (msg.contains('schedule') && msg.contains('required')) {
      return "Please select a date and time for your scheduled ride.";
    }
    if (msg.contains("data truncated for column 'status'") ||
        msg.contains('data truncated for column "status"')) {
      return "Scheduled ride status is not configured on the server. Please try a regular ride or contact support.";
    }
    if (msg.contains('already') && msg.contains('booking')) {
      return "You already have an active booking. Please complete or cancel it first.";
    }
    if (msg.contains('in process') || msg.contains('request is in')) {
      return "You already have an active booking. Please complete or cancel it first.";
    }
    if (msg.contains('unauthorized') || msg.contains('unauthenticated')) {
      return "Your session has expired. Please log in again.";
    }
    if (msg.contains('server') || msg.contains('internal')) {
      return "Our servers are busy. Please try again in a moment.";
    }
    if (msg.contains('data not found') || msg.contains('no data') || msg.contains('not found')) {
      return "No results available at the moment.";
    }
    if (msg.contains('network') || msg.contains('connection') || msg.contains('timeout')) {
      return "Please check your internet connection and try again.";
    }
    if (msg.contains('validation') || msg.contains('invalid')) {
      return "Please check your details and try again.";
    }
    if (msg.contains('token') && msg.contains('expired')) {
      return "Your session has expired. Please log in again.";
    }

    // If the message looks like a proper sentence (has spaces), show it as-is
    if (backendMessage.contains(' ') && !backendMessage.contains('_')) {
      return backendMessage;
    }

    // If it looks like a backend field name (has underscores), make it generic
    if (backendMessage.contains('_')) {
      return "Oops! Something went wrong. Please try again.";
    }

    return backendMessage;
  }

  /// Calls customer-booking-active and updates [activeBookingState].
  /// Always checks that booking_id is present before setting any non-none status.
  Future<void> checkActiveBookingApi() async {
    try {
      final Response response = await bookingRepo.checkActiveBookingRepo();

      if (response.statusCode == 200 && response.body is Map) {
        final String code = (response.body['code'] ?? '').toString();
        final data = response.body['data'];

        if (code == '200' && data != null && data is Map) {
          final String? bookingId = data['booking_id']?.toString();
          final String statusStr = (data['status'] ?? '').toString();

          if (bookingId != null && bookingId.isNotEmpty) {
            activeBookingState.value = BookingActiveState(
              bookingId: bookingId,
              status: _parseBookingStatus(statusStr),
            );
          } else {
            // booking_id absent — treat as no active booking
            activeBookingState.value =
                const BookingActiveState(status: BookingStatus.none);
          }
        } else {
          // code 401 "Data not found" or null data → no active booking
          activeBookingState.value =
              const BookingActiveState(status: BookingStatus.none);
        }
      } else {
        activeBookingState.value =
            const BookingActiveState(status: BookingStatus.none);
      }
    } catch (e) {
      debugPrint('checkActiveBookingApi error: $e');
      activeBookingState.value =
          const BookingActiveState(status: BookingStatus.none);
    }
  }

  BookingStatus _parseBookingStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'accepted':
      case 'driver_assigned':
        return BookingStatus.accepted;
      case 'arrived':
        return BookingStatus.arrived;
      case 'ongoing':
      case 'in_progress':
      case 'started':
        return BookingStatus.ongoing;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
      case 'canceled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.unknown;
    }
  }

  /////
  Future<Response> TrackRideApi({
    required BuildContext context,
    required String? bookingid,
  }) async {
    update();

    try {
      Response response = await bookingRepo.trackRideApi(
        bookingId: bookingid.toString(),
      );

      print("Status Code : ${response.statusCode}");
      print("Response : ${response.body}");

      if (response.statusCode == 200) {
        trackRideModel = TrackRideModel.fromJson(response.body);

        if (trackRideModel?.code == "200") {
          // full ride details
          rideDetails = trackRideModel?.data;
          update();
          // driver details
          driverInfo = trackRideModel?.data?.driverInfo;
          rideStatus.value = rideDetails?.status ?? "pending";

          print("Ride Status : ${rideStatus.value}");

          print("Booking Id: ${rideDetails?.bookingId}");
          print("Ride Status: ${rideDetails?.status}");
          print("OTP: ${rideDetails?.otp}");

          print("Driver Name: ${driverInfo?.name}");
          print("Driver Phone: ${driverInfo?.phone}");
          print("Vehicle: ${driverInfo?.vehicalName}");
          print("Vehicle Number: ${driverInfo?.vehicalNumber}");

          if (rideStatus.value == "completed") {
            // Clear booking ID for completed rides
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove(ApiConstants.bookingid);
            Get.offAll(
              MainNavigation(),
              duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
              transition: Transition.rightToLeft,
            );
          } else {
            Get.toNamed(
              RouteHelper.getfindingDriverUI(),
              arguments: {'booking_id': bookingid},
            );
          }
        } else {
          // API returned 200 but code is not "200" - booking may be invalid
          print("TrackRideApi: Invalid response code: ${trackRideModel?.code}");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove(ApiConstants.bookingid);
          Get.offAll(
            MainNavigation(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        }
      } else {
        // Non-200 HTTP status - navigate to main screen
        print("TrackRideApi: HTTP error ${response.statusCode}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(ApiConstants.bookingid);
        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      }

      update();
      return response;
    } catch (e) {
      print("TrackRideApi exception: $e");
      // On any exception, clear stale booking and navigate to main
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.bookingid);
      Get.offAll(
        MainNavigation(),
        duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
        transition: Transition.rightToLeft,
      );
      rethrow;
    }
  }

  Future<Response> TrackRideApi2({
    required BuildContext context,
    required String? bookingid,
  }) async {
    update();

    // Was entirely unguarded — TrackRideApi2 is polled every 3s from
    // findingdriver_screen.dart (the rider's live in-ride map/status
    // screen) for the whole duration of a ride. Any exception out of
    // fromJson() below (malformed response, a field arriving in an
    // unexpected shape) used to propagate straight out of this function
    // uncaught, every single poll — rideDetails/driverInfo/rideStatus
    // never got updated, which is exactly what leaves that screen frozen
    // (no live driver position, no status change) the instant a ride
    // starts, instead of just skipping the one bad poll and trying again
    // in 3s like every other poller in this app already does.
    try {
      Response response = await bookingRepo.trackRideApi(
        bookingId: bookingid.toString(),
      );

      print("Status Code : ${response.statusCode}");
      print("Response : ${response.body}");

      if (response.statusCode == 200) {
        trackRideModel = TrackRideModel.fromJson(response.body);

        if (trackRideModel?.code == "200") {
          // full ride details
          rideDetails = trackRideModel?.data;
          update();
          // driver details
          driverInfo = trackRideModel?.data?.driverInfo;
          rideStatus.value = rideDetails?.status ?? "pending";

          print("Ride Status : ${rideStatus.value}");

          print("Booking Id: ${rideDetails?.bookingId}");
          print("Ride Status: ${rideDetails?.status}");
          print("OTP: ${rideDetails?.otp}");

          print("Driver Name: ${driverInfo?.name}");
          print("Driver Phone: ${driverInfo?.phone}");
          print("Vehicle: ${driverInfo?.vehicalName}");
          print("Vehicle Number: ${driverInfo?.vehicalNumber}");

          // await Future.delayed(Duration(milliseconds: 500));

          // State updated above; the FindingDriverUI widget reacts reactively.
          // Do NOT navigate here — TrackRideApi2 is called on every poll and
          // pushing FindingDriverUI on each tick stacks screens endlessly.
        }
      } else if (response.statusCode == 500) {}

      update();
      return response;
    } catch (e) {
      debugPrint('[TrackRideApi2] error: $e');
      update();
      return Response(statusCode: 0, statusText: e.toString());
    }
  }

  /// SharedPreferences key holding {booking_id, data} for the last booking
  /// created on this device, where `data` is create-booking's response data
  /// verbatim.
  static const String _createdBreakdownPrefsKey = 'last_booking_fare_details';

  Future<void> _rememberCreatedBreakdown(
    String bookingId,
    dynamic data,
  ) async {
    if (data is! Map) return;
    try {
      final map = Map<String, dynamic>.from(data);
      _createdBreakdown = PriceBreakdown.fromCreateBooking(map);
      _createdBreakdownBookingId = bookingId;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _createdBreakdownPrefsKey,
        jsonEncode({'booking_id': bookingId, 'data': map}),
      );
    } catch (e) {
      // A fare card that falls back to the shorter summary is a far better
      // outcome than a failed booking, and the booking has already
      // succeeded by this point — so this must never throw upward.
      log('Could not store created-booking fare details: $e');
    }
  }

  /// The stored breakdown for [bookingId], reloading from disk if this
  /// controller was rebuilt (or the app restarted) since the booking was
  /// made. Returns null for any other booking — notably an older ride
  /// opened from Activity, whose create-booking response is long gone.
  Future<PriceBreakdown?> _breakdownForBooking(String? bookingId) async {
    if (bookingId == null || bookingId.isEmpty) return null;
    if (_createdBreakdownBookingId == bookingId && _createdBreakdown != null) {
      return _createdBreakdown;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_createdBreakdownPrefsKey);
      if (raw == null || raw.isEmpty) return null;

      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      if (decoded['booking_id']?.toString() != bookingId) return null;
      if (decoded['data'] is! Map) return null;

      _createdBreakdown = PriceBreakdown.fromCreateBooking(
        Map<String, dynamic>.from(decoded['data'] as Map),
      );
      _createdBreakdownBookingId = bookingId;
      return _createdBreakdown;
    } catch (e) {
      log('Could not read stored fare details: $e');
      return null;
    }
  }

  Future<Response> TripRideDetailsApi({
    required BuildContext context,
    required String? bookingid,
  }) async {
    // EasyLoading.show(status: "Please wait...");
    update();

    Response response = await bookingRepo.tripDetailsRideApi(
      bookingId: bookingid.toString(),
    );

    if (response.statusCode == 200) {
      final body = response.body;

      if (body['code'] == "200") {
        tridRideDetails.value = body['data']['status'];
        tridRideDetailsData.value = body['data'];
        try {
          var parsed = TripDetailModel.fromJson(
            Map<String, dynamic>.from(body as Map),
          );

          // trip-detail commonly returns only the lighter `payment` object,
          // which has no tax or fee components in it — so the fare card had
          // nothing to itemise and fell back to just a subtotal and a total.
          // create-booking did send the real components for this booking, so
          // fill them in from what we stored then rather than leaving the
          // rider with a receipt that can't show what they were charged for.
          // Only ever fills a gap: a price_breakdown that trip-detail *did*
          // send always wins, since that reflects the ride as completed
          // (waiting charges, extra distance) where the create-booking
          // figures are the estimate at the time of booking.
          if (parsed.data != null && parsed.data!.priceBreakdown == null) {
            final stored = await _breakdownForBooking(bookingid?.toString());
            if (stored != null) {
              parsed = TripDetailModel(
                code: parsed.code,
                message: parsed.message,
                data: parsed.data!.copyWithPriceBreakdown(stored),
              );
            }
          }

          tripDetailModel.value = parsed;

          // Duration/distance previously came back blank on the rating
          // screen because their source path in the response wasn't
          // actually confirmed (see TripDetailData._rideStatsSource). Left
          // in as a one-line trace rather than removed once fixed, so any
          // future ride type/shape that still doesn't parse shows up
          // immediately in logcat instead of silently rendering "-" again.
          // distance defaults to 0 rather than null when absent (see
          // TripRideStats), so "has a real reading" is a >0 check on
          // either field, not a null check.
          final stats = parsed.data?.rideStats;
          final bool hasStats =
              (stats?.duration ?? 0) > 0 || (stats?.distance ?? 0) > 0;
          if (!hasStats) {
            final dataMap = body['data'] is Map ? body['data'] as Map : null;
            debugPrint(
              '[TripDetail] duration/distance not found in response data keys: '
              '${dataMap?.keys.toList() ?? body['data']}',
            );
            // trip_summary is the current best guess for where the real
            // figures live (see _rideStatsSource) — if it exists but still
            // doesn't parse, this shows exactly what's inside it instead of
            // just "not found" again.
            final tripSummary = dataMap?['trip_summary'];
            if (tripSummary != null) {
              debugPrint('[TripDetail] trip_summary contents: $tripSummary');
            }
          } else {
            // Latched, not just assigned — see completedTripStats' own
            // comment on why this must never be overwritten by a later
            // response that came back without a reading.
            completedTripStats = parsed.data;
          }
        } catch (e) {
          debugPrint('TripDetailModel parse error: $e');
        }
      }
    } else if (response.statusCode == 500) {
      //  await EasyLoading.dismiss();

       AnimatedTopToast.show(
        context: context,
        message:
            "We're having trouble connecting. Please try again shortly.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    } else {}

    update();
    return response;
  }

  Future<Response> cancelationListApi({
    required BuildContext context,
    //  required String? bookingid,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // EasyLoading.show(status: "Please wait...");
    update();

    Response response = await bookingRepo.cancelationlist();

    if (response.statusCode == 200) {
      final body = response.body;

      if (body['code'] == "200") {
        CancelationModel model = CancelationModel.fromJson(body);

        cancelationList = model.data ?? [];
        await prefs.remove(ApiConstants.bookingid);
        ////await sharedPreferences.clear();
        update();

        //  await EasyLoading.dismiss();
      }
    } else if (response.statusCode == 500) {
      //await EasyLoading.dismiss();

       AnimatedTopToast.show(
        context: context,
        message:
            "We're having trouble connecting. Please try again shortly.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    } else {}

    update();
    return response;
  }

  Future<Response> cancelRideApi({
    required BuildContext context,
    required String? bookingid,
    required int? reseonId,
  }) async {
    update();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Response response = await bookingRepo.cancelRideApi(
        bookingid: bookingid.toString(),
        reseonId: reseonId.toString(),
      );

      final body = response.body;
      final String code = (body is Map && body['code'] != null)
          ? body['code'].toString()
          : '';
      final String rawMessage = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : '';
      String userMessage = _getUserFriendlyMessage(rawMessage);

      if (response.statusCode == 200 && code == '200') {
        log('Ride cancelled successfully');
        Get.offAllNamed(RouteHelper.getmainNavigationScreen());
        await prefs.remove(ApiConstants.bookingid);
      } else {
        AnimatedTopToast.show(
          context: context,
          message: userMessage.isNotEmpty
              ? userMessage
              : "Unable to cancel ride. Please try again.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }

      update();
      return response;
    } catch (e) {
      debugPrint('cancelRideApi Error: $e');
      AnimatedTopToast.show(
        context: context,
        message: "Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
      update();
      rethrow;
    }
  }

  Future<Response> rateForDriver({
    required BuildContext context,
    required String? bookingid,
    required dynamic rateId,
    String review = '',
  }) async {
    update();

    try {
      Response response = await bookingRepo.rateDriver(
        bookingid: bookingid.toString(),
        rateId: rateId.toString(),
        review: review,
      );

      final body = response.body;
      final String code = (body is Map && body['code'] != null)
          ? body['code'].toString()
          : '';
      final String rawMessage = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : '';
      String userMessage = _getUserFriendlyMessage(rawMessage);

      if (response.statusCode == 200 && code == '200') {
        Get.offAllNamed(RouteHelper.getmainNavigationScreen());
      } else {
        AnimatedTopToast.show(
          context: context,
          message: userMessage.isNotEmpty
              ? userMessage
              : "Unable to submit rating. Please try again.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }

      update();
      return response;
    } catch (e) {
      debugPrint('rateForDriver Error: $e');
      AnimatedTopToast.show(
        context: context,
        message: "Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
      update();
      rethrow;
    }
  }

  /// Posts the post-ride star rating and optional review, for
  /// [TripCompletedScreen]. Deliberately separate from [rateForDriver]
  /// above rather than reused directly: that method's job includes showing
  /// its own toast and navigating Home on success, both of which
  /// TripCompletedScreen already owns itself (Done navigates Home
  /// regardless of whether the rating submit succeeded — a failed rating
  /// must never trap the rider on a finished ride). This just posts and
  /// reports success/failure, with no side effects of its own.
  Future<bool> submitTripRating({
    required String bookingId,
    required int rating,
    String review = '',
  }) async {
    try {
      final response = await bookingRepo.rateDriver(
        bookingid: bookingId,
        rateId: rating.toString(),
        review: review,
      );
      final body = response.body;
      final success = response.statusCode == 200 &&
          body is Map &&
          body['code']?.toString() == '200';
      if (!success) {
        debugPrint('submitTripRating failed: status=${response.statusCode} body=$body');
      }
      return success;
    } catch (e) {
      debugPrint('submitTripRating error: $e');
      return false;
    }
  }

  // Nearby-drivers fetching now lives entirely in nearbyDriversSearch (see
  // onInit()) — it used to be a one-shot call made only from
  // getCurrentLocation(), fetched exactly once at app startup, silently
  // swallowing any failure past a debug log.

  // Future<BitmapDescriptor> resizeMarker(String path, int width) async {
  //   final ByteData data = await rootBundle.load(path);
  //   final codec = await instantiateImageCodec(
  //     data.buffer.asUint8List(),
  //     targetWidth: width,
  //   );
  //   final frame = await codec.getNextFrame();

  //   final bytes = await frame.image.toByteData(format: ImageByteFormat.png);

  //   return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  // }

  Future<BitmapDescriptor> resizeMarker(String path, int width) async {
    try {
      final ByteData data = await rootBundle.load(path);

      final codec = await instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width,
      );

      final frame = await codec.getNextFrame();

      final byteData = await frame.image.toByteData(
        format: ImageByteFormat.png,
      );

      if (byteData == null) {
        return BitmapDescriptor.defaultMarker;
      }

      final Uint8List resizedBytes = byteData.buffer.asUint8List();

      return BitmapDescriptor.bytes(resizedBytes);
    } catch (e) {
      debugPrint("Marker resize error: $e");
      return BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> loadCarIcon() async {
    driverCarIcons = await resizeMarker('assets/images/ridecar.png', 20);
  }

  // loadUserIcon() lived here: it downloaded and resized the rider's profile
  // photo into a BitmapDescriptor for the "user" map marker. That marker is
  // gone (see setMarkers below — the rider's position is the native location
  // dot and its pulsing ring now), which left this doing a network image
  // fetch and decode on every app start to produce something nothing draws.

  void setMarkers() {
    markers.clear();

    List<LatLng> allPositions = [];

    /// NO USER MARKER — the rider's own position is shown by GoogleMap's
    /// native blue location dot plus the pulsating ring drawn around it (see
    /// _locationPulseCircles in deshboard.dart), not by a pin.
    ///
    /// This used to add a Marker here with `customerProfile ??
    /// BitmapDescriptor.defaultMarker`. customerProfile is the rider's
    /// profile photo, which is null whenever they haven't set one or the
    /// download failed — and defaultMarker is the stock *red* pin, so the
    /// common case was a red teardrop planted on the rider's own location,
    /// visually identical to a destination pin and sitting directly on top
    /// of the blue dot already marking the same spot.
    ///
    /// Still contributes to allPositions so the camera-fitting bounds below
    /// keep including the rider — only the drawn pin is gone.
    allPositions.add(currentLatLng);

    /// DRIVER MARKERS — only meaningful once a search has actually
    /// succeeded; loading/empty/error states just show the "You" pin.
    final nearbyDrivers = nearbyDriversSearch.state.value.phase ==
            NearbyDriversPhase.success
        ? nearbyDriversSearch.state.value.drivers
        : const <DriverAvailableDataModel>[];

    for (int i = 0; i < nearbyDrivers.length; i++) {
      var driver = nearbyDrivers[i];

      double? lat = double.tryParse(driver.latitude.toString());
      double? lng = double.tryParse(driver.longitude.toString());

      print("============== DRIVER ==============");
      print("Driver Name : ${driver.name}");
      print("Latitude    : $lat");
      print("Longitude   : $lng");

      if (lat != null && lng != null) {
        /// BIGGER OFFSET
        double adjustedLat = lat + (i * 0.0002);
        double adjustedLng = lng + (i * 0.0002);

        LatLng position = LatLng(adjustedLat, adjustedLng);

        markers.add(
          Marker(
            markerId: MarkerId("driver_${driver.id}"),
            position: position,
            zIndex: i.toDouble(),

            icon:
                driverCarIcons ??
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

            infoWindow: InfoWindow(
              title: driver.name ?? "Driver",
              snippet:
                  "Distance: ${(driver.distance ?? 0).toStringAsFixed(2)} km",
            ),
          ),
        );

        allPositions.add(position);

        print("Marker Added : ${driver.id}");
      }
    }

    /// FIT MAP
    Future.delayed(const Duration(milliseconds: 500), () {
      fitMapToBounds(allPositions);
    });

    update();
  }
  // void setMarkers() {
  //   markers.clear();

  //   List<LatLng> allPositions = [];

  //   markers.add(
  //     Marker(
  //       markerId: MarkerId("user"),
  //       position: currentLatLng,
  //       infoWindow: InfoWindow(title: "You"),
  //       icon: customerProfile ?? BitmapDescriptor.defaultMarker,
  //       // BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //     ),
  //   );

  //   allPositions.add(currentLatLng);

  //   for (var driver in driverAvailableNearBy) {
  //     double? lat = double.tryParse(driver.latitude ?? "");
  //     double? lng = double.tryParse(driver.longitude ?? "");
  //     if (lat != null && lng != null) {
  //       LatLng position = LatLng(lat, lng);

  //       markers.add(
  //         Marker(
  //           markerId: MarkerId("driver_${driver.id}"),
  //           position: position,
  //           icon: driverCarIcons ?? BitmapDescriptor.defaultMarker,
  //           infoWindow: InfoWindow(
  //             title: driver.name ?? "Driver",
  //             snippet: "Distance: ${driver.distance?.toStringAsFixed(2)} km",
  //           ),
  //         ),
  //       );

  //       allPositions.add(position);
  //     }
  //   }

  //   if (allPositions.length > 1) {
  //     Future.delayed(Duration(milliseconds: 500), () {
  //       fitMapToBounds(allPositions);
  //     });
  //   }

  //   update();
  // }

  void fitMapToBounds(List<LatLng> positions) {
    if (mapController == null || positions.isEmpty) return;

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (var pos in positions) {
      if (pos.latitude < minLat) minLat = pos.latitude;
      if (pos.latitude > maxLat) maxLat = pos.latitude;
      if (pos.longitude < minLng) minLng = pos.longitude;
      if (pos.longitude > maxLng) maxLng = pos.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    try {
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
    } catch (e) {
      debugPrint('fitMapToBounds: Map controller disposed, skipping. $e');
    }
  }

  void selectReason(int index) {
    selectedReason = index;
    selectedReasonId = cancelationList[index].id;
    update();
  }
}
