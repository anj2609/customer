import 'package:myrideuser/app/modules/activity/activity_card.dart';
import 'package:myrideuser/app/modules/activity/ridedetail_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: SafeArea(
        child: GetBuilder<ProfileController>(
          builder: (controller) {
            if (controller.isPromoLoading) {
              return  Center(child: PremiumBlurLoader());
            }

            if (controller.bookingActivityList!.isEmpty) {
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
                    const Text(
                      "No Completed Rides",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            /// List — every completed booking, same card format shared
            /// across all Activity filters.
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: 20,
              ),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
