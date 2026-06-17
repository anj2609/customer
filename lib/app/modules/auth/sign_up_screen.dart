
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:myrideuser/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LatestMyRideLoginScreen extends StatelessWidget {
  const LatestMyRideLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.spacingSize25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.06),

                        Image.asset(
                          'assets/images/splashscreen.png',
                          height: constraints.maxHeight * 0.15,
                          width: MediaQuery.of(context).size.width * 0.5,
                          color: ColorResources.blueeebutton,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: Dimensions.spacingSize16),

                        Text(
                          "Let's Get Started!",
                          style: PoppinsSemiBold.copyWith(
                            fontSize: 22,
                            color: ColorResources.blackcolor,
                          ),
                        ),

                        const SizedBox(height: Dimensions.spacingSize10),

                        Text(
                          "Let's dive in into your account",
                          style: PoppinsMedium.copyWith(
                            color: ColorResources.TextColorForGrey,
                          ),
                        ),

                        const SizedBox(height: Dimensions.spacingSize40),

                        /// Google sign-in
                        CustomSocialButton(
                          text: "Continue with Google",
                          images: 'assets/images/google.png',
                          iconColor: Colors.red,
                          onTap: () async {
                            showDialog(
                              context: Get.context!,
                              barrierDismissible: false,
                              builder: (_) => PremiumBlurLoader(),
                            );
                            try {
                              await Get.find<AuthController>().signInWithGoogle(
                                provider: 'google',
                                context: context,
                              );
                            } catch (e) {
                              debugPrint('Google sign-in Error: $e');
                            } finally {
                              if (Get.isDialogOpen ?? false) Get.back();
                            }
                          },
                        ),

                        const SizedBox(height: Dimensions.spacingSize16),

                        /// Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'or',
                                style: PoppinsMedium.copyWith(
                                  color: ColorResources.TextColorForGrey,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: Dimensions.spacingSize16),

                        /// Single phone entry button — auto-detects login vs register
                        CustomPrimaryButton(
                          text: "Continue with Phone Number",
                          onTap: () {
                            Get.toNamed(RouteHelper.getphoneCheckScreenRoute());
                          },
                        ),

                        const Spacer(),

                        /// Footer
                        Text(
                          "Privacy Policy  •  Term of Service",
                          style: PoppinsMedium.copyWith(
                            color: ColorResources.TextColorForGrey,
                          ),
                        ),

                        const SizedBox(height: Dimensions.spacingSize20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
