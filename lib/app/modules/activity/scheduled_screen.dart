import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/app/modules/activity/activity.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class ScheduledScreen extends StatelessWidget {
  const ScheduledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return GetBuilder<ProfileController>(
      builder: (_) {
        // 🔄 Loading State
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
                  "No Complete Rides",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: controller.bookingActivityList!.length,
          itemBuilder: (context, index) {
            final item = controller.bookingActivityList![index];

            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => RideDetailsScreen(
                //       bookingId: item.id.toString(),
                //     ),
                //   ),
                // );
              },
              child: RideItem(
                title: item.dropAddress ?? "N/A",
                imageUrl: item.image ?? "",
                // time: item!.runtimeType ?? "N/A",
                subTitle: item.createdAt ?? "",
                
                //rightDate: item.createdAt ?? "",
              ),
            );
          },
        );
      },
    );
  }
}
