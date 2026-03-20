import 'package:evfual/app/modules/Deshboard/final_cancel_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/data/controller/cancleride_controller.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancelRideScreen extends StatelessWidget {
  CancelRideScreen({super.key});

  final CancelRideController controller = Get.put(CancelRideController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorResources.blackcolor),
          onPressed: () => Get.back(),
        ),
        title: Text("Cancel Ride", style: PoppinsBold.copyWith()),
        centerTitle: false,
      ),

      body: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: height * 0.02),

            /// Question Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Why are you cancelling?",
                  style: PoppinsReguler.copyWith(),
                ),
              ),
            ),

            SizedBox(height: height * 0.02),

            /// Reasons List
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Obx(() {
                  int selected = controller.selectedReason.value;

                  return ListView.builder(
                    itemCount: controller.reasons.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => controller.selectReason(index),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: selected,
                              onChanged: (value) {
                                controller.selectReason(index);
                              },
                              activeColor: const Color(0xFF1FA2C3),
                            ),
                            Expanded(
                              child: Text(
                                controller.reasons[index],
                                style: PoppinsReguler.copyWith(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ),

            /// Confirm Button
            CustomPrimaryDyanamicButton(
              text: "Confirm",
              onTap: () {
                print("Selected: ${controller.selectedReason.value}");
                Get.to(
                  Get.to(RideCancelledScreen()),
                  transition: Transition.leftToRight,
                  duration: Duration(milliseconds: 0),
                );
              },
            ),

            // Padding(
            //   padding: EdgeInsets.all(width * 0.05),
            //   child: SizedBox(
            //     width: width,
            //     height: height * 0.065,
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFF1FA2C3),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(30),
            //         ),
            //         elevation: 0,
            //       ),
            //       onPressed: () {
            //         print("Selected: ${controller.selectedReason.value}");
            //       },
            //       child: Text(
            //         "Confirm",
            //         style: TextStyle(
            //           fontSize: width * 0.045,
            //           color: Colors.white,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
