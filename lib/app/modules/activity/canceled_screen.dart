import 'package:myrideuser/app/modules/activity/activity_card.dart';
import 'package:myrideuser/app/modules/activity/ridedetail_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class CanceledScreen extends StatefulWidget {
  const CanceledScreen({super.key});

  @override
  State<CanceledScreen> createState() => _CanceledScreenState();
}

class _CanceledScreenState extends State<CanceledScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),

              /// LIST USING GETBUILDER
              Expanded(
                child: GetBuilder<ProfileController>(
                  builder: (controller) {
                    /// Loading
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
                              "No Canceled Rides",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    /// List — every canceled booking, same card format
                    /// shared across all Activity filters.
                    return ListView.builder(
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
            ],
          ),
        ),
      ),
    );
  }
}
