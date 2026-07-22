import 'package:intl/intl.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/modal/activity_model.dart';
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

                    /// List
                    return ListView.builder(
                      itemCount: controller.bookingActivityList!.length,
                      itemBuilder: (context, index) {
                        final item = controller.bookingActivityList![index];

                        return _activityCard(item, width, height);
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

  Widget _activityCard(
    ActivityDataMainModel item,
    double width,
    double height,
  ) {
    return GestureDetector(
      onTap: () {},

      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.015),
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: ColorResources.whiteColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            /// Icon
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
                    backgroundColor: ColorResources.blueeebutton.withValues(alpha: 0.08),
                    child: Image.asset(
                      "assets/images/cars.png",
                      width: width * 0.08,
                      height: width * 0.08,
                      fit: BoxFit.cover,
                      color: ColorResources.blueeebutton,
                    ),
                  ),

            SizedBox(width: width * 0.04),

            /// Title & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.dropAddress ?? "", style: PoppinsSemiBold),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(item.createdAt!),
                    style: TextStyle(
                      fontSize: width * 0.03,
                      color: Colors.grey,
                    ),
                  ),
                  // Text(
                  //   item.createdAt ?? "",
                  //   style: TextStyle(
                  //     fontSize: width * 0.03,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  const SizedBox(height: 4),
                  Text(
                    item.status ?? "",
                    style: TextStyle(fontSize: width * 0.03, color: ColorResources.textColorRed),
                  ),
                ],
              ),
            ),

            /// Amount
            Text(
              item.totalFare.toString() ?? "",
              style: TextStyle(
                fontSize: width * 0.038,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
