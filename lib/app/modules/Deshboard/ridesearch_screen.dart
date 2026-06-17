import 'dart:convert';
import 'dart:io';

import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:myrideuser/widgets/custom_loader.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

class RideOptionScreen extends StatefulWidget {
  final double pickup_lat;
  final double pickup_lng;
  final double drop_lat;
  final double drop_lng;

  RideOptionScreen({
    super.key,
    required this.pickup_lat,
    required this.pickup_lng,
    required this.drop_lat,
    required this.drop_lng,
  });

  @override
  State<RideOptionScreen> createState() => _RideOptionScreenState();
}

class _RideOptionScreenState extends State<RideOptionScreen> {
  GoogleMapController? mapController;
  bool isScheduled = false;
  DateTime? selectedDateTime;
  String formattedDateTime = "";
  String? estimated_price = "";
  String vehicletypeid = "";
  String pickupaddress = "";
  String dropaddress = "";
  String isschedule = "";
  String scheduledatetime = "";
  Future<void> getAddress() async {
    /// PICKUP ADDRESS
    List<Placemark> pick = await placemarkFromCoordinates(
      widget.pickup_lat,
      widget.pickup_lng,
    );

    /// DROP ADDRESS
    List<Placemark> drop = await placemarkFromCoordinates(
      widget.drop_lat,
      widget.drop_lng,
    );

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

  int selectedIndex = -1;
  String pickupAddress = "";
  String dropAddress = "";

  /// ===== DEMO POLYLINE (DIRECT LINE) =====
  Set<Polyline> getPolyline() {
    return {
      Polyline(
        polylineId: PolylineId("route"),
        color: ColorResources.blueeebutton,
        width: 5,
        points: [
          LatLng(widget.pickup_lat, widget.pickup_lng),
          LatLng(widget.drop_lat, widget.drop_lng),
        ],
      ),
    };
  }

  List<Polyline> polylines = [];

  final String googleApiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";
  Set<Marker> getMarkers() {
    return {
      Marker(
        markerId: const MarkerId("pickup"),
        position: LatLng(widget.pickup_lat, widget.pickup_lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
      Marker(
        markerId: const MarkerId("drop"),
        position: LatLng(widget.drop_lat, widget.drop_lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  Future<void> drawRoute() async {
    try {
      final origin = "${widget.pickup_lat},${widget.pickup_lng}";
      final destination = "${widget.drop_lat},${widget.drop_lng}";

      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$googleApiKey";

      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      final data = jsonDecode(body);

      List<LatLng> routePoints = [];

      if (data["routes"].isNotEmpty) {
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

        /// 🔥 Auto zoom map
        fitMap();
      } else {
        print("❌ No route found");
      }
    } catch (e) {
      print("❌ Route Error: $e");
    }
  }

  void fitMap() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        widget.pickup_lat < widget.drop_lat
            ? widget.pickup_lat
            : widget.drop_lat,
        widget.pickup_lng < widget.drop_lng
            ? widget.pickup_lng
            : widget.drop_lng,
      ),
      northeast: LatLng(
        widget.pickup_lat > widget.drop_lat
            ? widget.pickup_lat
            : widget.drop_lat,
        widget.pickup_lng > widget.drop_lng
            ? widget.pickup_lng
            : widget.drop_lng,
      ),
    );

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  void initState() {
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.pickup_lat, widget.pickup_lng),
              zoom: 14,
            ),
            markers: getMarkers(),
            polylines: Set<Polyline>.of(polylines),
            onMapCreated: (c) {
              mapController = c;

              /// 🔥 Map load hote hi route draw
              drawRoute();
            },
          ),

          /// ================= TOP LOCATION BAR =================
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: Dimensions.radiusSize,
            right: Dimensions.radiusSize,
            child: Container(
              padding: const EdgeInsets.all(Dimensions.hight13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.hight13),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: Dimensions.spacingSize10,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: Dimensions.spacingSize10,
                        color: ColorResources.blueeebutton,
                      ),
                      const SizedBox(width: Dimensions.spacingSize10),

                      /// 👇 IMPORTANT FIX
                      Expanded(
                        child: Text(
                          pickupAddress.isEmpty ? "Loading..." : pickupAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: Dimensions.spacingSize10,
                        color: Colors.red,
                      ),
                      SizedBox(width: Dimensions.spacingSize10),

                      /// 👇 IMPORTANT FIX
                      Expanded(
                        child: Text(
                          dropAddress.isEmpty ? "Loading..." : dropAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// ================= BOTTOM CARD =================
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * .45 +
                  MediaQuery.of(context).padding.bottom,
              padding: EdgeInsets.fromLTRB(
                Dimensions.spacingSize16,
                Dimensions.spacingSize16,
                Dimensions.spacingSize16,
                Dimensions.spacingSize16 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Dimensions.spacingSize25),
                ),
              ),
              child: Column(
                children: [
                  /// ===== RIDE LIST =====
                  Expanded(
                    child: GetBuilder<BookingController>(
                      builder: (bookingController) {
                        if (bookingController.vehicleList.isEmpty) {
                          return const Center(
                            child: Text(
                              "Car Not Available",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: bookingController.vehicleList.length,
                          itemBuilder: (context, index) {
                            final vehicle =
                                bookingController.vehicleList[index];
                            bool selected = selectedIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;

                                  estimated_price =
                                      vehicle.price?.toString() ?? "";
                                  vehicletypeid =
                                      vehicle.vehicleTypeId?.toString() ?? "";
                                  pickupaddress = pickupAddress;
                                  dropaddress = dropAddress;

                                  ///scheduledatetime = formattedDateTime;
                                });

                                print("Price: $estimated_price");
                                print("Vehicle ID: $vehicletypeid");
                                print("Pickup: $pickupaddress");
                                print("Drop: $dropaddress");
                                print("Is Schedule: $isschedule");
                                print("Schedule DateTime: $scheduledatetime");
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 7,
                                  bottom: 7,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.spacingSize11,
                                  ),
                                  border: Border.all(
                                    color: selected
                                        ? ColorResources.blueeebutton
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/cart.png',
                                      height: 30,
                                    ),

                                    // const Icon(
                                    //   Icons.directions_car,
                                    //   size: 35,
                                    // ),
                                    SizedBox(width: 10),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vehicle.name ?? "",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "${vehicle.estimatedTime ?? ""} • ${vehicle.distanceKm ?? ""} km",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Text(
                                      "₹ ${vehicle.price ?? 0}",
                                      style: PoppinsSemiBold.copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),

                      Row(
                        children: [
                          Checkbox(
                            value: isScheduled,
                            onChanged: (value) {
                              setState(() {
                                isScheduled = value!;
                                if (!isScheduled) {
                                  selectedDateTime = null;
                                }
                              });
                            },
                          ),
                          Text(
                            "Schedule Ride",
                            style: PoppinsSemiBold.copyWith(),
                          ),
                        ],
                      ),

                      /// DATE TIME PICKER (SHOW ONLY IF CHECKED)
                      if (isScheduled)
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                setState(() {
                                  selectedDateTime = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );

                                  formattedDateTime =
                                      "${selectedDateTime!.year}-"
                                      "${selectedDateTime!.month.toString().padLeft(2, '0')}-"
                                      "${selectedDateTime!.day.toString().padLeft(2, '0')} "
                                      "${selectedDateTime!.hour.toString().padLeft(2, '0')}:"
                                      "${selectedDateTime!.minute.toString().padLeft(2, '0')}:00";
                                });
                                // setState(() {
                                //   selectedDateTime = DateTime(
                                //     pickedDate.year,
                                //     pickedDate.month,
                                //     pickedDate.day,
                                //     pickedTime.hour,
                                //     pickedTime.minute,
                                //   );
                                // });
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDateTime.isEmpty
                                      ? "Select Date & Time"
                                      : formattedDateTime,
                                  style: PoppinsReguler.copyWith(),
                                ),
                                const Icon(Icons.calendar_today, size: 18),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.radiusSizeSmall),
                  CustomPrimaryDyanamicButton(
                    text: "Next",
                    onTap: () async {
                      // Validate vehicle selection
                      if (selectedIndex == -1 || vehicletypeid.isEmpty) {
                        AnimatedTopToast.show(
                          context: context,
                          message: "Please select a vehicle type",
                          backgroundColor: Colors.red,
                          icon: Icons.error_outline,
                        );
                        return;
                      }

                      // Validate schedule date if scheduled
                      if (isScheduled && formattedDateTime.isEmpty) {
                        AnimatedTopToast.show(
                          context: context,
                          message: "Please select a schedule date & time",
                          backgroundColor: Colors.red,
                          icon: Icons.error_outline,
                        );
                        return;
                      }

                      try {
                        final String scheduleFlag = isScheduled ? "1" : "0";
                        final String scheduleDateTime = isScheduled
                            ? formattedDateTime
                            : "";

                        showDialog(
                          context: Get.context!,
                          barrierDismissible: false,
                          builder: (_) => PremiumBlurLoader(),
                        );

                        await Get.find<BookingController>().CreateBooking(
                          pickup_lat: widget.pickup_lat,
                          pickup_lng: widget.pickup_lng,
                          drop_lat: widget.drop_lat,
                          drop_lng: widget.drop_lng,
                          context: context,
                          estimated_price: estimated_price.toString(),
                          vehicle_type_id: vehicletypeid,
                          pickup_address: pickupaddress,
                          drop_address: dropaddress,
                          is_schedule: scheduleFlag,
                          schedule_date_time: scheduleDateTime,
                        );
                      } catch (e) {
                        debugPrint('CreateBooking Error: $e');
                      } finally {
                        if (Get.isDialogOpen ?? false) {
                          Get.back();
                        }
                      }
                    },
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
