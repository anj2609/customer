import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/app/modules/Deshboard/completed_ride_sheet.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/controller/chat_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/modal/trackride_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myrideuser/widgets/custom_loader.dart';
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
    /// PICKUP ADDRESS
    List<Placemark> pick = await placemarkFromCoordinates(pickuplat, picklong);

    /// DROP ADDRESS
    List<Placemark> drop = await placemarkFromCoordinates(droplat, droplong);

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

    setState(() {
      pickupAddress = formatAddress(pick.first);
      dropAddress = formatAddress(drop.first);
    });
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

  final String googleApiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldUs";

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
              color: Colors.blue,
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

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        // apiKey: "YOUR_GOOGLE_MAP_KEY",
        request: PolylineRequest(
          origin: PointLatLng(
            currentLocation!.latitude,
            currentLocation!.longitude,
          ),
          destination: PointLatLng(
            driverLocation!.latitude,
            driverLocation!.longitude,
          ),
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
    markers.clear();

    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("user"),
          position: currentLocation!,
          infoWindow: const InfoWindow(title: "My Location"),
        ),
      );
    }

    if (driverLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("driver"),
          position: driverLocation!,
          icon: carIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: "Driver"),
        ),
      );
    }
    setState(() {});
  }

  void updateDriverLocation(double latitude, double longitude) {
    driverLocation = LatLng(latitude, longitude);

    updateMarkers();
    drawRoute1();

    mapController?.animateCamera(CameraUpdate.newLatLng(driverLocation!));
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
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() {
              final controller = Get.find<BookingController>();
              final status = controller.rideStatus.value;
              final driverdata = controller.tridRideDetailsData;
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
                        getCurrentLocation();
                        drawRoute();
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
                      onMapCreated: (controllerMap) async {
                        mapController = controllerMap;

                        await getCurrentLocation1();

                        if (currentLocation != null) {
                          mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: currentLocation!,
                                zoom: 16,
                              ),
                            ),
                          );
                        }
                        // 9090909090 ye daloo na okk
                        updateDriverLocation(
                          driverdata['pickup_lat'],
                          driverdata['pickup_lng'],
                        );
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
            child: Obx(() {
              final controller = Get.find<BookingController>();
              final data = controller.rideDetails;
              final driverdata = controller.tridRideDetailsData;
              if (!addressLoaded && driverdata.isNotEmpty) {
                addressLoaded = true;

                Future.microtask(() {
                  getAddress(
                    driverdata['pickup_lat'],
                    driverdata['pickup_lng'],
                    driverdata['drop_lat'],
                    driverdata['drop_lng'],
                  );
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
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(pickupAddress)),
                      ],
                    ),

                    const Divider(),

                    /// Drop
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(dropAddress)),
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
    final controller = Get.find<BookingController>();
    final otp = controller.rideDetails?.otp?.toString().padLeft(4, '0') ?? '';

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

          const SizedBox(height: 20),

          /// ── OTP Display ──
          if (otp.isNotEmpty) ...[
            const Text(
              "Your Ride OTP",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(otp.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue.shade200,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    otp[index],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade700,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 6),
            Text(
              "Share this OTP with your driver to start the ride",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],

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
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1.2),
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

  Widget _rowItem(
    String title,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

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
              icon: const Icon(Icons.call, color: Colors.blue),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////============================= fdfodf========================////////////////

  //////////////// ============================ ongoing paire =========================///////////////////////

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
                            color: Colors.blue.shade50,
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
                          Text(
                            "${driver.vehicalName ?? ""} - ${driver.vehicalNumber ?? ""}",
                            //"${driver['vehical_name']} - ${driver['vehical_number']}",
                            style: const TextStyle(fontSize: 13),
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

                /// EXTRA DETAILS (only ongoing)
                if (status == "ongoing")
                  buildFareSection(driverstatus, drivercollection),

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
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Text(
                        "Cancel Ride",
                        style: TextStyle(
                          color: Colors.red,
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

  Widget buildFareSection(String? status, Map details) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // _rowItem("Ride", "Economy"),
          // const SizedBox(height: 8),
          // _rowItem("Payment", "Wallet"),
          _rowItem("Trip Fare", "₹ ${details['base_fare']}", isBold: true),
          const Divider(),
          _rowItem(
            "Discount (20%)",
            "₹ ${details['discount_fare']}",
            isBold: true,
          ),
          const Divider(),
          _rowItem("Total", "₹ ${details['total_fare']}", isBold: true),

          ///driver['profile_image']
        ],
      ),
    );
  }

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
                  border: Border.all(color: Colors.blue.withValues(alpha: 1 - value)),
                ),
              ),

              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blue,
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

