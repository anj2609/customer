import 'package:intl/intl.dart';
import 'package:myrideuser/app/modules/activity/ridedetail_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/modal/activity_model.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
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
                    Image.asset("assets/images/notdatafound.png", height: 150),
                    const SizedBox(height: 10),
                    const Text(
                      "No Scheduled Rides",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: 20,
              ),
              itemCount: controller.bookingActivityList!.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade200, thickness: 1),
              itemBuilder: (context, index) {
                final item = controller.bookingActivityList![index];

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      RideDetailsScreen(),
                      arguments: item,
                      transition: Transition.leftToRight,
                      duration: const Duration(milliseconds: 0),
                    );
                  },
                  child: CompleteCard(item: item),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CompleteCard extends StatelessWidget {
  final ActivityDataMainModel item;

  const CompleteCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(
      'testing login  image getting ${ApiConstants.imageurl}${item.vehicleType!.image}',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          /// Left Circular Icon
          (item.image != null && item.image!.isNotEmpty)
              ? CircleAvatar(
                  radius: width * 0.09,
                  backgroundColor: ColorResources.whiteColor,
                  child: ClipOval(
                    child: Image.network(
                      '${ApiConstants.imageurl}${item.image.toString()}',
                      width: width * 0.16,
                      height: width * 0.16,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/cars.png",
                          width: width * 0.14,
                          height: width * 0.14,
                          fit: BoxFit.cover,
                          color: ColorResources.blueeebutton,
                        );
                      },
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: width * 0.06,
                  backgroundColor: Colors.blue.shade50,
                  child: Image.asset(
                    "assets/images/cars.png",
                    width: width * 0.08,
                    height: width * 0.08,
                    fit: BoxFit.cover,
                    color: ColorResources.blueeebutton,
                  ),
                ),

          // Container(
          //   width: width * 0.13,
          //   height: width * 0.13,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     border: Border.all(
          //       color: ColorResources.TextColorForGrey,
          //       width: 1,
          //     ),
          //   ),
          //   child: Center(
          //     child:
          //         // Text('data')
          //         Image.asset(
          //           "assets/images/notdatafound.png",
          //           height: 15,
          //           //size: 22,
          //           //  color: const Color(0xFF4A90E2), // soft blue
          //         ),
          //   ),
          // ),
          const SizedBox(width: 14),

          /// Title + Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.dropAddress!,
                  style: PoppinsSemiBold.copyWith(
                    color: ColorResources.blackcolor11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(item.createdAt!),

                  style: PoppinsReguler.copyWith(
                    color: ColorResources.TextColorForGrey,
                  ),
                  // TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          /// Amount + Payment Method
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.totalFare!.toString(),
                style: PoppinsSemiBold.copyWith(
                  color: ColorResources.blackcolor11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.paymentType ?? 'Cash',
                //item.,
                style: PoppinsReguler.copyWith(
                  color: ColorResources.TextColorForGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    // 2026-04-27
    String fullDate = DateFormat('yyyy-MM-dd').format(dateTime);

    // 27 April
    String dayMonth = DateFormat('dd MMMM').format(dateTime);

    return "$fullDate  $dayMonth";
  }
}
