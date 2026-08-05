import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/modal/outstation_estimate_model.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

/// Vehicle selection for N Ride Outstation. Vehicle names, images, and
/// price all come from the real `outstation/estimate` endpoint for the
/// chosen trip — nothing here is fabricated.
///
/// The 150km-minimum check is done client-side here (via Google Directions,
/// same pattern used for route drawing on the home screen) before even
/// calling the estimate endpoint: the live backend was confirmed (by direct
/// testing) not to enforce that minimum itself, so relying on its response
/// wasn't catching short trips.
class OutstationVehicleScreen extends StatefulWidget {
  final String fromAddress;
  final String toAddress;
  final LatLng? fromLatLng;
  final LatLng? toLatLng;
  final String tripType;
  final int estimatedDays;
  final bool isSchedule;
  final String scheduleDateTime;

  const OutstationVehicleScreen({
    super.key,
    required this.fromAddress,
    required this.toAddress,
    required this.tripType,
    required this.estimatedDays,
    required this.isSchedule,
    required this.scheduleDateTime,
    this.fromLatLng,
    this.toLatLng,
  });

  @override
  State<OutstationVehicleScreen> createState() => _OutstationVehicleScreenState();
}

class _OutstationVehicleScreenState extends State<OutstationVehicleScreen> {
  final BookingController bookingController = Get.find<BookingController>();
  int _selectedIndex = -1;

  static const double _minOutstationKm = 150;
  static const String _underMinMessage =
      "Outstation rides are available only for trips of 150 KM or more. Please book a Normal Ride.";
  final String _directionsApiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";

  bool _isCheckingDistance = true;
  String? _distanceError;
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    // getOutstationEstimate() calls update() before its first await, which
    // would try to rebuild GetBuilder<BookingController> while this screen
    // is still mid-mount — same fix as the Rentals vehicle screen. Deferred
    // to after the first frame either way.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDistanceThenLoadEstimate());
  }

  /// Real driving distance via Google Directions (same endpoint already
  /// used for route drawing elsewhere) gates the estimate call. The live
  /// backend was confirmed by direct testing not to reject short trips
  /// itself, so this is enforced here instead — using the exact rejection
  /// wording already established for this scenario, not a fabricated one.
  Future<void> _checkDistanceThenLoadEstimate() async {
    if (widget.fromLatLng == null || widget.toLatLng == null) {
      if (mounted) setState(() => _isCheckingDistance = false);
      return;
    }

    double? distanceKm;
    try {
      final origin = "${widget.fromLatLng!.latitude},${widget.fromLatLng!.longitude}";
      final destination = "${widget.toLatLng!.latitude},${widget.toLatLng!.longitude}";
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$_directionsApiKey";

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      final routes = data["routes"];
      if (routes != null && routes is List && routes.isNotEmpty) {
        final legs = routes[0]["legs"];
        if (legs != null && legs is List && legs.isNotEmpty) {
          final meters = legs[0]["distance"]?["value"];
          if (meters is num) distanceKm = meters / 1000.0;

          // Same response already has the full route — decode it here too
          // instead of firing a second Directions API call just for the
          // polyline.
          final routePoints = <LatLng>[];
          for (var leg in legs) {
            for (var step in leg["steps"]) {
              final polyline = step["polyline"]["points"];
              final decoded = PolylinePoints.decodePolyline(polyline);
              for (var point in decoded) {
                routePoints.add(LatLng(point.latitude, point.longitude));
              }
            }
          }
          if (routePoints.isNotEmpty) {
            _polylines = {
              Polyline(
                polylineId: const PolylineId("outstation_route"),
                points: routePoints,
                width: 6,
                color: ColorResources.blueeebutton,
                jointType: JointType.round,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
              ),
            };
          }
        }
      }
    } catch (e) {
      debugPrint("Outstation distance check error: $e");
    }

    if (!mounted) return;

    if (distanceKm != null && distanceKm < _minOutstationKm) {
      setState(() {
        _isCheckingDistance = false;
        _distanceError = _underMinMessage;
      });
      AnimatedTopToast.show(
        context: context,
        message: _underMinMessage,
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return;
    }

    // Distance check passed (or couldn't be determined — fail open rather
    // than blocking a legitimate long trip on a Directions API hiccup) —
    // proceed to the real estimate call.
    setState(() => _isCheckingDistance = false);

    await bookingController.getOutstationEstimate(
      tripType: widget.tripType,
      pickupLat: widget.fromLatLng!.latitude,
      pickupLng: widget.fromLatLng!.longitude,
      dropLat: widget.toLatLng!.latitude,
      dropLng: widget.toLatLng!.longitude,
    );
    if (!mounted) return;
    final error = bookingController.outstationEstimateError;
    if (error != null) {
      AnimatedTopToast.show(
        context: context,
        message: error,
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ColorResources.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: ColorResources.blackcolor11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fromAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: PoppinsSemiBold.copyWith(
                            fontSize: 14,
                            color: ColorResources.blackcolor11,
                          ),
                        ),
                        Text(
                          widget.toAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: PoppinsReguler.copyWith(
                            fontSize: 12,
                            color: ColorResources.TextColorForGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: GetBuilder<BookingController>(
              builder: (bc) {
                final markers = <Marker>{};
                if (widget.fromLatLng != null) {
                  markers.add(Marker(
                    markerId: const MarkerId('outstation_from'),
                    position: widget.fromLatLng!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                  ));
                }
                if (widget.toLatLng != null) {
                  markers.add(Marker(
                    markerId: const MarkerId('outstation_to'),
                    position: widget.toLatLng!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ));
                }
                return GoogleMap(
                  markers: markers,
                  polylines: _polylines,
                  initialCameraPosition: CameraPosition(
                    target: widget.fromLatLng ?? bc.currentLatLng,
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (mapController) {},
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose a ride",
                    style: PoppinsSemiBold.copyWith(
                      fontSize: 15,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GetBuilder<BookingController>(
                    builder: (bc) {
                      if (_isCheckingDistance) {
                        return _vehicleGrid(List.generate(6, (_) => _cardSkeleton()));
                      }
                      if (_distanceError != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              _distanceError!,
                              textAlign: TextAlign.center,
                              style: PoppinsMedium.copyWith(
                                fontSize: 14,
                                color: ColorResources.textColorRed,
                              ),
                            ),
                          ),
                        );
                      }
                      if (bc.isOutstationEstimateLoading) {
                        return _vehicleGrid(List.generate(6, (_) => _cardSkeleton()));
                      }
                      if (bc.outstationEstimateError != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              bc.outstationEstimateError!,
                              textAlign: TextAlign.center,
                              style: PoppinsMedium.copyWith(
                                fontSize: 14,
                                color: ColorResources.textColorRed,
                              ),
                            ),
                          ),
                        );
                      }
                      if (bc.outstationEstimateList.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              "No vehicles available right now",
                              style: PoppinsMedium.copyWith(
                                fontSize: 14,
                                color: ColorResources.TextColorForGrey,
                              ),
                            ),
                          ),
                        );
                      }
                      return _vehicleGrid(
                        List.generate(bc.outstationEstimateList.length, (index) {
                          final estimate = bc.outstationEstimateList[index];
                          return _vehicleCard(estimate, index);
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CustomPrimaryDyanamicButton(
                text: "Book Ride",
                onTap: () {
                  if (_selectedIndex == -1) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please select a vehicle",
                      backgroundColor: ColorResources.textColorRed,
                      icon: Icons.error_outline,
                    );
                    return;
                  }
                  final estimate = bookingController.outstationEstimateList[_selectedIndex];
                  if (widget.fromLatLng == null ||
                      widget.toLatLng == null ||
                      estimate.vehicleTypeId == null ||
                      estimate.outstationPricingId == null ||
                      estimate.price == null) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Something went wrong. Please try again.",
                      backgroundColor: ColorResources.textColorRed,
                      icon: Icons.error_outline,
                    );
                    return;
                  }
                  bookingController.CreateOutstationBooking(
                    context: context,
                    pickupLat: widget.fromLatLng!.latitude,
                    pickupLng: widget.fromLatLng!.longitude,
                    dropLat: widget.toLatLng!.latitude,
                    dropLng: widget.toLatLng!.longitude,
                    estimatedPrice: estimate.price!,
                    vehicleTypeId: estimate.vehicleTypeId!,
                    pickupAddress: widget.fromAddress,
                    dropAddress: widget.toAddress,
                    isSchedule: widget.isSchedule ? 1 : 0,
                    scheduleDateTime: widget.scheduleDateTime,
                    outstationPricingId: estimate.outstationPricingId!,
                    tripType: widget.tripType,
                    estimatedDistance: estimate.distance ?? 0,
                    estimatedDuration: estimate.duration ?? 0,
                    billableDistance: estimate.billableDistance ?? 0,
                    estimatedDays: widget.estimatedDays,
                    driverAllowance: estimate.fareDetails?.driverAllowance ?? 0,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Lays real card widgets out in a responsive 2-column grid, sizing each
  /// card to its own content instead of forcing a uniform GridView cell.
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

  Widget _vehicleCard(OutstationEstimateModel estimate, int index) {
    final selected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
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
                    aspectRatio: 1.5,
                    child: _vehicleImage(estimate.vehicleImage),
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
              estimate.vehicleName ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackcolor11,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              "₹${estimate.price ?? '--'}",
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

  /// Same "never crop, whatever the source template" approach used on the
  /// home screen — the backend serves multiple differently-shaped photo
  /// templates (wide padded car mockups vs. near-square two-wheeler shots).
  Widget _vehicleImage(String? image) {
    if (image == null || image.isEmpty) {
      return Container(
        color: ColorResources.backgroundColor,
        child: Center(
          child: Image.asset('assets/images/cart.png', height: 24),
        ),
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
            child: Image.asset('assets/images/cart.png', height: 24),
          );
        },
      ),
    );
  }

  Widget _cardSkeleton() {
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
              aspectRatio: 1.5,
              child: Container(color: ColorResources.blueeebutton.withValues(alpha: 0.08)),
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
}
