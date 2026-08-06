import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:myrideuser/app/modules/activity/activity_card.dart';
import 'package:myrideuser/app/modules/activity/ridedetail_screen.dart';
import 'package:myrideuser/app/modules/activity/track_route_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/modal/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';

class OngoingScreen extends StatelessWidget {
  const OngoingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GetBuilder<ProfileController>(
      builder: (controller) {
        if (controller.bookingActivityList == null ||
            controller.bookingActivityList!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/notdatafound.png",
                  height: 150,
                  color: ColorResources.blueeebutton,
                ),
                const SizedBox(height: 10),
                Text(
                  "No Ongoing Rides",
                  style: PoppinsSemiBold.copyWith(
                    color: ColorResources.blackcolor,
                  ),
                ),
              ],
            ),
          );
        }

        /// List — every ongoing booking, same card format shared across
        /// all Activity filters, plus a functional "Track Route" button.
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 12),
          itemCount: controller.bookingActivityList!.length,
          itemBuilder: (context, index) {
            final item = controller.bookingActivityList![index];

            return ActivityRideCard(
              item: item,
              onTap: () {
                Get.to(
                  () => RideDetailsScreen(item: item),
                  transition: Transition.leftToRight,
                  duration: const Duration(milliseconds: 0),
                );
              },
              footer: SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: ColorResources.blueeebutton),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () => _trackRoute(item),
                  child: Text(
                    "Track Route",
                    style: PoppinsSemiBold.copyWith(
                      color: ColorResources.blueeebutton,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Opens the real pickup → drop route for this ride inside the app
  /// (no external Maps app/browser), using the ride's actual coordinates
  /// from the API.
  void _trackRoute(ActivityDataMainModel item) {
    final pickupLat = item.pickupLat;
    final pickupLng = item.pickupLng;
    final dropLat = item.dropLat;
    final dropLng = item.dropLng;

    if (pickupLat == null ||
        pickupLng == null ||
        dropLat == null ||
        dropLng == null ||
        (pickupLat == 0.0 && pickupLng == 0.0) ||
        (dropLat == 0.0 && dropLng == 0.0)) {
      Get.snackbar(
        "Route unavailable",
        "This ride doesn't have location data to track.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.to(
      () => TrackRouteScreen(
        pickup: LatLng(pickupLat, pickupLng),
        drop: LatLng(dropLat, dropLng),
        pickupAddress: item.pickupAddress ?? "Pickup",
        dropAddress: item.dropAddress ?? "Drop",
      ),
      transition: Transition.rightToLeft,
    );
  }
}
