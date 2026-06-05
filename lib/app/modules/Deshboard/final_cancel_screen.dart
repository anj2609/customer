import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideCancelledScreen extends StatelessWidget {
  const RideCancelledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Top Close Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ),

            /// Center Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Blue Circle with Check
                  Container(
                    height: screen.width * 0.22,
                    width: screen.width * 0.22,
                    decoration: BoxDecoration(
                      color: ColorResources.blueeebutton,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: ColorResources.whiteColor,
                      size: 40,
                    ),
                  ),

                  SizedBox(height: screen.height * 0.04),

                  /// Title
                  Text(
                    "Ride has been cancelled!",
                    style: PoppinsExtrabold.copyWith(
                      color: ColorResources.blackcolor,
                      fontSize: Dimensions.spacingSize25
                    ),
                    textAlign: TextAlign.center,
                  ),

                   SizedBox(height: Dimensions.hight13),

                  /// Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Funds have been returned to your account."
                      "\nYou can see the cancelled history in the"
                      "\nactivity menu.",
                      style: PoppinsBold.copyWith(
                        color: ColorResources.TextColorForGrey,
                      ),
                     // textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            /// Bottom Button
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: CustomPrimaryDyanamicButton(
                text: "Confirm",
                onTap: () {
                
                  // Get.to(
                  //   Get.to(RideCancelledScreen()),
                  //   transition: Transition.leftToRight,
                  //   duration: Duration(milliseconds: 0),
                  // );
                },
              ),
           ),
            
          ],
        ),
      ),
    );
  }
}
