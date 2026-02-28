import 'package:evfual/app/modules/Deshboard/deshboard.dart';
import 'package:evfual/app/modules/Deshboard/promovoucher_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideOptionScreen extends StatefulWidget {
  final LatLng pickup;
  final LatLng destination;

  const RideOptionScreen({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  State<RideOptionScreen> createState() => _RideOptionScreenState();
}

class _RideOptionScreenState extends State<RideOptionScreen> {
  GoogleMapController? mapController;
  Future<void> getAddress() async {
    /// PICKUP ADDRESS
    List<Placemark> pick = await placemarkFromCoordinates(
      widget.pickup.latitude,
      widget.pickup.longitude,
    );

    /// DROP ADDRESS
    List<Placemark> drop = await placemarkFromCoordinates(
      widget.destination.latitude,
      widget.destination.longitude,
    );

    setState(() {
      pickupAddress = pick.first.locality ?? pick.first.subLocality ?? "";
      dropAddress = drop.first.name ?? "";
    });
  }

  int selectedIndex = 0;
  String pickupAddress = "";
  String dropAddress = "";

  /// ===== DEMO POLYLINE (DIRECT LINE) =====
  Set<Polyline> getPolyline() {
    return {
      Polyline(
        polylineId: const PolylineId("route"),
        color: Colors.blue,
        width: 5,
        points: [widget.pickup, widget.destination],
      ),
    };
  }

  /// ===== MARKERS =====
  Set<Marker> getMarkers() {
    return {
      Marker(
        markerId: const MarkerId("pickup"),
        position: widget.pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      Marker(
        markerId: const MarkerId("drop"),
        position: widget.destination,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  List rides = [
    {
      "title": "Cab Economy (Non-AC)",
      "price": "₹ 560",
      "time": "3-5 mins",
      "seat": "4 passengers",
    },
    {
      "title": "Cab Plus",
      "price": "₹ 780",
      "time": "4-6 mins",
      "seat": "6 passengers",
    },
    {
      "title": "Cab Premium",
      "price": "₹ 983",
      "time": "4-5 mins",
      "seat": "4 passengers",
    },
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ================= GOOGLE MAP =================
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.pickup,
              zoom: 14,
            ),
            markers: getMarkers(),
            polylines: getPolyline(),
            onMapCreated: (c) {
              mapController = c;
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
                  BoxShadow(blurRadius: 10, color: Colors.black12),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        pickupAddress.isEmpty ? "Loading..." : pickupAddress,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        dropAddress.isEmpty ? "Loading..." : dropAddress,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // /// ================= BACK BUTTON =================
          // Positioned(
          //   left: 16,
          //   top: 120,
          //   child: CircleAvatar(
          //     backgroundColor: Colors.white,
          //     child: IconButton(
          //       icon: const Icon(Icons.arrow_back),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //     ),
          //   ),
          // ),

          /// ================= BOTTOM CARD =================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * .45,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  /// ===== RIDE LIST =====
                  Expanded(
                    child: ListView.builder(
                      itemCount: rides.length,
                      itemBuilder: (context, index) {
                        bool selected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedIndex = index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.directions_car, size: 40),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rides[index]["title"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${rides[index]["time"]} • ${rides[index]["seat"]}",
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  rides[index]["price"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Payment"), Text("My Ride Wallet")],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Get.to(PromoVoucherScreen());
                      },
                      child: const Text("Next"),
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
//-=-=-==-

