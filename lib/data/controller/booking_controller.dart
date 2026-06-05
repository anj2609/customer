import 'dart:async';
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

import 'package:myrideuser/data/modal/cancellation_model.dart';
import 'package:myrideuser/data/modal/driveravailable_model.dart';
import 'package:myrideuser/data/modal/trackride_model.dart';
import 'package:myrideuser/data/modal/vehicle_model.dart';
import 'package:myrideuser/data/repository/booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingController extends GetxController implements GetxService {
  final BookingRepo bookingRepo;

  BookingController({
    required this.bookingRepo,
    // required profileRepo
  });

  //// ====== Google SignIn =============== //////////////
  ///final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  List<VehicleModel> vehicleList = [];
  RxString rideStatus = "pending".obs;
//    RxString rideStatus = "pending".obs;

  // RxMap rideData = {}.obs;
  RxString tridRideDetails = "pending".obs;
  RxMap tridRideDetailsData = {}.obs;
  TrackRideModel? trackRideModel;
  DatTrackRideDetails? rideDetails;
  DriverInfo? driverInfo;

  List<CancelationModelData> cancelationList = [];
  List<DriverAvailableDataModel> driverAvailableNearBy = [];
  int selectedReason = -1;
  int? selectedReasonId;
  Set<Marker> markers = {};
  BitmapDescriptor? driverCarIcons;
  BitmapDescriptor? customerProfile;

  GoogleMapController? mapController;
  LatLng currentLatLng = const LatLng(28.5355, 77.3910);
  bool _isMapReady = false;
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    // _googleSignIn.initialize(
    //   serverClientId:
    //       "816050400087-4pv5deujt52p78pv3u785cf32f9cv269.apps.googleusercontent.com",
    // );

    loadCarIcon();
    loadUserIcon();
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

      await driverAvailableNearByApi(
        context: Get.context!,
        latitude: currentLatLng.latitude,
        longitude: currentLatLng.longitude,
      );

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

        Get.toNamed(
          RouteHelper.getrideOptionScreen(),
          arguments: {
            "pickup_lat": pickup_lat,
            "pickup_lng": pickup_lng,
            "drop_lat": drop_lat,
            "drop_lng": drop_lng,
          },
        );
      } else {
       // EasyLoading.dismiss();
         AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
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
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
    } else {
     // EasyLoading.dismiss();
    }

    update();
    return response;
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
   /// EasyLoading.show(status: "Please wait...");
    update();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response = await bookingRepo.createBookingApi(
      pickup_lat: pickup_lat!,
      pickup_lng: pickup_lng!,
      drop_lat: drop_lat!,
      drop_lng: drop_lng!,
      estimated_price: estimated_price!,
      vehicle_type_id: vehicle_type_id,
      pickup_address: pickup_address,
      drop_address: drop_address,
      is_schedule: is_schedule,
      schedule_date_time: schedule_date_time,
    );

    if (response.body['code'] == '200') {
      //await EasyLoading.dismiss();

       AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ,
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
      print("Booking ID: ${response.body['data']}");

      var bookingid = response.body['data']['booking_id'].toString();

      print("Booking ID: $bookingid");
      await Future.delayed(const Duration(milliseconds: 500));
      // if (bookingid != null) {
      Get.toNamed(
        RouteHelper.getfindingDriverUI(),
        arguments: {'booking_id': bookingid},
      );
      await prefs.setString(ApiConstants.bookingid, bookingid);
      print("Booking ID: ${prefs.get(ApiConstants.bookingid)}");
    } else if (response.statusCode == 500) {
      await EasyLoading.dismiss();

        AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
    } else {
       AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
    }

    update();
    return response;
  }

  /////
  Future<Response> TrackRideApi({
    required BuildContext context,
    required String? bookingid,
  }) async {
    update();

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

        if (rideStatus.value == "completed") {
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
      }
    } else if (response.statusCode == 500) {}

    update();
    return response;
  }

  Future<Response> TrackRideApi2({
    required BuildContext context,
    required String? bookingid,
  }) async {
    update();

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

        if (rideStatus.value == "completed") {
          // Get.offAll(
          //   MainNavigation(),
          //   duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          //   transition: Transition.rightToLeft,
          // );
        } else {
          Get.toNamed(
            RouteHelper.getfindingDriverUI(),
            arguments: {'booking_id': bookingid},
          );
        }
      }
    } else if (response.statusCode == 500) {}

    update();
    return response;
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
      }
    } else if (response.statusCode == 500) {
      //  await EasyLoading.dismiss();

       AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
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
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
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
   /// EasyLoading.show(status: "Please wait...");
    update();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Response response = await bookingRepo.cancelRideApi(
      bookingid: bookingid.toString(),
      reseonId: reseonId.toString(),
    );

    if (response.statusCode == 200) {
      if (response.body['code'] == '200') {
        log('Vehicle List Length: ${vehicleList.length}');

       /// EasyLoading.dismiss();

        Get.offAllNamed(RouteHelper.getmainNavigationScreen());
        await prefs.remove(ApiConstants.bookingid);
        print("Booking ID: ${prefs.get(ApiConstants.bookingid)}");
      } else {
       /// EasyLoading.dismiss();
        Get.offAllNamed(RouteHelper.getmainNavigationScreen());
        await prefs.remove(ApiConstants.bookingid);
        AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
      }
    } else if (response.statusCode == 422) {
      ///EasyLoading.dismiss();
       AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
    } else {
     EasyLoading.dismiss();
    }

    update();
    return response;
  }

  Future<Response> rateForDriver({
    required BuildContext context,
    required String? bookingid,
    required dynamic rateId,
  }) async {
   /// EasyLoading.show(status: "Please wait...");
    update();

    Response response = await bookingRepo.rateDriver(
      bookingid: bookingid.toString(),
      rateId: rateId.toString(),
    );

    if (response.statusCode == 200) {
      if (response.body['code'] == '200') {
      //////  EasyLoading.dismiss();
        Get.offAllNamed(RouteHelper.getmainNavigationScreen());

        // Get.toNamed(
        //   RouteHelper.getrideOptionScreen(),
        //   arguments: {
        //     "pickup_lat": pickup_lat,
        //     "pickup_lng": pickup_lng,
        //     "drop_lat": drop_lat,
        //     "drop_lng": drop_lng,
        //   },
        // );
      } else {
      ///  EasyLoading.dismiss();
        Get.snackbar(
          'Error',
          response.body['error'] ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else if (response.statusCode == 422) {
     // EasyLoading.dismiss();
        AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
    } else {
     // EasyLoading.dismiss();
    }

    update();
    return response;
  }

  Future<Response> driverAvailableNearByApi({
    required BuildContext context,
    required dynamic latitude,
    required dynamic longitude,
  }) async {
    //EasyLoading.show(status: "Please wait...");
    update();

    Response response = await bookingRepo.driverAvailbledata(
      latitude: latitude!,
      longitude: longitude!,
    );

    if (response.statusCode == 200) {
      final body = response.body;
      print('all car::::::${body}');

      if (body['code'] == "200") {
        DriverAvailableModel model = DriverAvailableModel.fromJson(body);

        driverAvailableNearBy = model.data ?? [];
        setMarkers();
      }
    } else if (response.statusCode == 500) {
       AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
    } else {}

    update();
    return response;
  }

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

  Future<void> loadUserIcon() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userProfile = prefs.getString("profile_image");

    print("Stored Image Path: $userProfile");

    if (userProfile != null && userProfile.isNotEmpty) {
      String imageUrl = userProfile.startsWith("http")
          ? userProfile
          : "https://myride.infinititechsolution.com/$userProfile";

      print("Final Image URL: $imageUrl");

      customerProfile = await resizeMarker(imageUrl, 120);

      update();
    }
  }

  void setMarkers() {
    markers.clear();

    List<LatLng> allPositions = [];

    /// USER MARKER
    markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: currentLatLng,
        infoWindow: const InfoWindow(title: "You"),
        icon: customerProfile ?? BitmapDescriptor.defaultMarker,
      ),
    );

    allPositions.add(currentLatLng);

    /// DRIVER MARKERS
    for (int i = 0; i < driverAvailableNearBy.length; i++) {
      var driver = driverAvailableNearBy[i];

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

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  void selectReason(int index) {
    selectedReason = index;
    selectedReasonId = cancelationList[index].id;
    update();
  }
}
