import 'dart:async';
import 'dart:ui' as ui;
import 'package:evfual/app/modules/Deshboard/driverrating_screen.dart';
import 'package:evfual/app/modules/Deshboard/search_screen.dart';
import 'package:evfual/app/modules/chats/chat_screen.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:evfual/config/route.dart';
import 'package:evfual/config/utils/app_constants.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/helper/get_di.dart' as di;

class DriverHeadingScreen extends StatefulWidget {
  const DriverHeadingScreen({super.key});

  @override
  State<DriverHeadingScreen> createState() => _DriverHeadingScreenState();
}

class _DriverHeadingScreenState extends State<DriverHeadingScreen> {
  GoogleMapController? mapController;

  /// Dummy positions (replace with realtime)
  final LatLng userLocation = const LatLng(28.6139, 77.2090);
  final LatLng driverLocation = const LatLng(28.6148, 77.2050);
  BitmapDescriptor? carIcon;
  Future<void> loadCarIcon() async {
    final ByteData data = await rootBundle.load("assets/images/cab.png");

    // IMAGE RESIZE KAR RAHE HAIN 👇
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 80, // 👈 yaha size control karo
    );

    final ui.FrameInfo fi = await codec.getNextFrame();

    final ByteData? resized = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    carIcon = BitmapDescriptor.fromBytes(resized!.buffer.asUint8List());

    setState(() {});
  }

  /// ================= AUTO MID POINT =================
  LatLng getMiddlePoint() {
    return LatLng(
      (userLocation.latitude + driverLocation.latitude) / 2,
      (userLocation.longitude + driverLocation.longitude) / 2,
    );
  }

  /// ================= MARKERS =================
  Set<Marker> getMarkers() {
    return {
      /// USER MARKER
      Marker(
        markerId: const MarkerId("user"),
        position: userLocation,
        infoWindow: const InfoWindow(title: "My Location"),
      ),

      /// DRIVER CAR IMAGE MARKER
      Marker(
        markerId: const MarkerId("driver"),
        position: driverLocation,
        icon: carIcon ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.5),
      ),
    };
  }

  Set<Polyline> getPolylines() {
    return {
      Polyline(
        polylineId: const PolylineId("route"),
        width: 5,
        points: [userLocation, getMiddlePoint(), driverLocation],
      ),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCarIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
          /// ================= MAP =================
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: getMiddlePoint(),
              zoom: 14,
            ),
            markers: getMarkers(),
            polylines: getPolylines(), // 👈 YE IMPORTANT
            myLocationEnabled: true,
            onMapCreated: (c) {
              mapController = c;
              setState(() {}); // refresh markers
            },
          ),

          /// ================= TOP LOCATION BAR =================
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Column(
                children: const [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(child: Text("Bobst Library")),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(child: Text("Larchmont Hotel")),
                      Icon(Icons.add, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// ================= BOTTOM DRIVER CARD =================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Driver is heading to your location...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Driver will arriving in 1 min...",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "TATA TIGOR, White - TR 05 CB 2446",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// DRIVER ROW
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=3",
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Troska Sangam",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "⭐ 4.8   +91 987 654 3210",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      /// CHAT BUTTON
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ChatScreen()),
                          );
                        },
                        child: Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(Icons.chat, color: Colors.white),
                        ),
                      ),
                      //                     Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => RideOptionScreen(
                      //       destination: selectedLatLng,
                      //       pickup: currentLatLng!,
                      //     ),
                      //   ),
                      // );
                      // CustomPrimaryButton(
                      //   text: "Sign in",
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (_) => ChatScreen()),
                      //     );
                      //   },
                      // ),
                      const SizedBox(width: 10),

                      /// CALL BUTTON
                      Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(Icons.call, color: Colors.white),
                      ),
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Ride Row
                        _rowItem("Ride", "Economy (Non-AC)"),

                        const SizedBox(height: 8),

                        /// Payment Row
                        _rowItem("Payment", "MyRide Wallet"),

                        const Divider(height: 24),

                        /// Trip Fare
                        _rowItem("Trip Fare", "₹ 560", isBold: true),

                        const SizedBox(height: 8),

                        /// Discount
                        _rowItem(
                          "Discount (20%)",
                          "- ₹ 112",
                          valueColor: Colors.black87,
                        ),

                        const Divider(height: 24),

                        /// Total Paid
                        _rowItem("Total Paid", "₹ 448", isBold: true),
                      ],
                    ),
                  ),

                  /// CANCEL BUTTON
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DriverRatingScreen(),
                        ),
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
          ),
        ],
      ),
    );
  }

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
}
