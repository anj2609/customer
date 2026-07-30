import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/modal/vehicle_type_model.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

/// Vehicle selection for N Ride Outstation. There's no outstation pricing
/// backend yet, so this reuses the real vehicle catalog (name + image, same
/// data already shown on the home screen) rather than inventing per-vehicle
/// fares/discounts, and the CTA surfaces a "coming soon" message instead of
/// pretending to create a real booking.
class OutstationVehicleScreen extends StatefulWidget {
  final String fromAddress;
  final String toAddress;
  final LatLng? fromLatLng;
  final LatLng? toLatLng;

  const OutstationVehicleScreen({
    super.key,
    required this.fromAddress,
    required this.toAddress,
    this.fromLatLng,
    this.toLatLng,
  });

  @override
  State<OutstationVehicleScreen> createState() => _OutstationVehicleScreenState();
}

class _OutstationVehicleScreenState extends State<OutstationVehicleScreen> {
  final BookingController bookingController = Get.find<BookingController>();
  int _selectedIndex = -1;

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
                      if (bc.isVehicleTypeLoading) {
                        return Column(
                          children: List.generate(3, (_) => _rowSkeleton()),
                        );
                      }
                      if (bc.vehicleTypeList.isEmpty) {
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
                      return Column(
                        children: List.generate(bc.vehicleTypeList.length, (index) {
                          final type = bc.vehicleTypeList[index];
                          return _vehicleRow(type, index);
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: ColorResources.backgroundColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.payments_outlined, size: 20, color: ColorResources.blackcolor11),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Cash",
                            style: PoppinsMedium.copyWith(
                              fontSize: 14,
                              color: ColorResources.blackcolor11,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: ColorResources.TextColorForGrey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: CustomPrimaryDyanamicButton(
              text: "Review Ride",
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
                AnimatedTopToast.show(
                  context: context,
                  message: "N Ride Outstation is coming soon!",
                  backgroundColor: ColorResources.blueeebutton,
                  icon: Icons.access_time_filled_rounded,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleRow(VehicleTypeModel type, int index) {
    final selected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 76,
                height: 76 / 1.5,
                child: _vehicleImage(type.image),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                type.name ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PoppinsMedium.copyWith(
                  fontSize: 14,
                  color: ColorResources.blackcolor11,
                ),
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected
                  ? ColorResources.blueeebutton
                  : ColorResources.TextColorForGrey,
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

  Widget _rowSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorResources.greycolorborder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 76,
              height: 76 / 1.5,
              color: ColorResources.blueeebutton.withValues(alpha: 0.08),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              width: 90,
              height: 12,
              decoration: BoxDecoration(
                color: ColorResources.blueeebutton.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
