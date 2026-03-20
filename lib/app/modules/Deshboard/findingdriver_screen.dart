import 'package:evfual/app/modules/Deshboard/driverheading_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FindingDriverUI extends StatefulWidget {
  const FindingDriverUI({super.key});

  @override
  State<FindingDriverUI> createState() => _FindingDriverUIState();
}

class _FindingDriverUIState extends State<FindingDriverUI> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
          Get.to(
            Get.to(DriverHeadingScreen()),
            transition: Transition.leftToRight,
            duration: Duration(milliseconds: 0),
          );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => const DriverHeadingScreen()),
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController? mapController;
    return Scaffold(
      body: Stack(
        children: [
          /// ================= MAP AREA =================
          /// Yaha later GoogleMap widget laga dena
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(28.6139, 77.2090), // example Delhi
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),

          /// ================= TOP LOCATION CARD =================
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(.08),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Pickup
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Expanded(child: Text("Bobst Library")),
                    ],
                  ),

                  const Divider(),

                  /// Drop
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Expanded(child: Text("Larchmont Hotel")),
                      Icon(Icons.add, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
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
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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

                  Text(
                    "The driver will pick you up as soon as possible after they confirm your order.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 24),

                  const RippleLoader(),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 14),

                  /// Cancel Ride
                  Container(
                    height: 55,
                    width: double.infinity,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
                  border: Border.all(color: Colors.blue.withOpacity(1 - value)),
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
