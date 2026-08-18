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
import 'package:myrideuser/data/modal/rental_estimate_model.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

/// Final step of the N Ride Rentals flow. Vehicle names, images, included km
/// and price all come from the real `rental/estimate` endpoint for the
/// chosen duration — nothing here is fabricated. The CTA creates the booking
/// with ride_type "rental", carrying that estimate's fare breakdown through.
class RentalsVehicleScreen extends StatefulWidget {
  final int hours;
  final String fromAddress;
  final String toAddress;
  final LatLng? fromLatLng;
  final LatLng? toLatLng;

  const RentalsVehicleScreen({
    super.key,
    required this.hours,
    required this.fromAddress,
    required this.toAddress,
    this.fromLatLng,
    this.toLatLng,
  });

  @override
  State<RentalsVehicleScreen> createState() => _RentalsVehicleScreenState();
}

class _RentalsVehicleScreenState extends State<RentalsVehicleScreen> {
  final BookingController bookingController = Get.find<BookingController>();
  int _selectedIndex = -1;
  Set<Polyline> _polylines = {};

  /// Road distance of the pickup → drop-off route, in km, taken from the same
  /// Directions response that draws the polyline. Sent to create-booking as
  /// `final_distance`; /rental/estimate doesn't return it (its `included_km`
  /// is the package allowance, not this trip's distance). Stays null until
  /// that request comes back, in which case the field is left out of the
  /// booking body and the backend derives the distance itself.
  double? _routeDistanceKm;
  final String _directionsApiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";

  @override
  void initState() {
    super.initState();
    // getRentalEstimate() calls update() before its first await, which would
    // otherwise try to rebuild GetBuilder<BookingController> while this
    // screen's own widget tree is still mid-build (initState runs during
    // mount), throwing "setState() or markNeedsBuild() called during build."
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bookingController.getRentalEstimate(widget.hours);
      _drawRoute();
    });
  }

  /// Real driving route (same Directions API + polyline pattern used on the
  /// home screen) between the fixed pickup/drop-off chosen on the previous
  /// screen — the map should show the actual road path, not just the pins.
  Future<void> _drawRoute() async {
    if (widget.fromLatLng == null || widget.toLatLng == null) return;
    try {
      final origin = "${widget.fromLatLng!.latitude},${widget.fromLatLng!.longitude}";
      final destination = "${widget.toLatLng!.latitude},${widget.toLatLng!.longitude}";
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$_directionsApiKey";

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      final routePoints = <LatLng>[];
      // Google reports distance per leg in metres; a direct pickup → drop-off
      // route is a single leg, but sum them so the total stays right if a
      // waypoint is ever added.
      double distanceMetres = 0;
      final routes = data["routes"];
      if (routes != null && routes is List && routes.isNotEmpty) {
        final legs = routes[0]["legs"];
        if (legs != null && legs is List) {
          for (var leg in legs) {
            final legDistance = leg["distance"]?["value"];
            if (legDistance is num) distanceMetres += legDistance;
            for (var step in leg["steps"]) {
              final polyline = step["polyline"]["points"];
              final decoded = PolylinePoints.decodePolyline(polyline);
              for (var point in decoded) {
                routePoints.add(LatLng(point.latitude, point.longitude));
              }
            }
          }
        }
      }

      if (!mounted) return;
      setState(() {
        if (distanceMetres > 0) {
          _routeDistanceKm =
              double.parse((distanceMetres / 1000).toStringAsFixed(2));
        }
        if (routePoints.isNotEmpty) {
          _polylines = {
            Polyline(
              polylineId: const PolylineId("rentals_route"),
              points: routePoints,
              width: 6,
              color: ColorResources.blueeebutton,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
            ),
          };
        }
      });
    } catch (e) {
      debugPrint("Rentals vehicle screen route draw error: $e");
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
                          widget.hours == 1
                              ? "Rental · 1 hour"
                              : "Rental · ${widget.hours} hours",
                          style: PoppinsSemiBold.copyWith(
                            fontSize: 15,
                            color: ColorResources.blackcolor11,
                          ),
                        ),
                        Text(
                          "${widget.fromAddress} → ${widget.toAddress}",
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
                    markerId: const MarkerId('rentals_from'),
                    position: widget.fromLatLng!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure,
                    ),
                  ));
                }
                if (widget.toLatLng != null) {
                  markers.add(Marker(
                    markerId: const MarkerId('rentals_to'),
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
                      if (bc.isRentalEstimateLoading) {
                        return _vehicleGrid(List.generate(6, (_) => _cardSkeleton()));
                      }
                      if (bc.rentalEstimateList.isEmpty) {
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
                        List.generate(bc.rentalEstimateList.length, (index) {
                          final estimate = bc.rentalEstimateList[index];
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
                text: "Choose a ride",
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
                  final estimate = bookingController.rentalEstimateList[_selectedIndex];
                  if (widget.fromLatLng == null ||
                      widget.toLatLng == null ||
                      estimate.vehicleTypeId == null ||
                      estimate.packageId == null ||
                      estimate.price == null) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Something went wrong. Please try again.",
                      backgroundColor: ColorResources.textColorRed,
                      icon: Icons.error_outline,
                    );
                    return;
                  }
                  bookingController.CreateRentalBooking(
                    context: context,
                    pickupLat: widget.fromLatLng!.latitude,
                    pickupLng: widget.fromLatLng!.longitude,
                    dropLat: widget.toLatLng!.latitude,
                    dropLng: widget.toLatLng!.longitude,
                    estimatedPrice: estimate.price!,
                    vehicleTypeId: estimate.vehicleTypeId!,
                    pickupAddress: widget.fromAddress,
                    dropAddress: widget.toAddress,
                    packageId: estimate.packageId!,
                    finalHour: widget.hours,
                    finalDistance: _routeDistanceKm,
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

  Widget _vehicleCard(RentalEstimateModel estimate, int index) {
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
              "${estimate.includedKm ?? 0} km included",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsReguler.copyWith(
                fontSize: 11,
                color: ColorResources.TextColorForGrey,
              ),
            ),
            const SizedBox(height: 4),
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
