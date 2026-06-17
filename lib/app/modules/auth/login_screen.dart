import 'package:flutter/gestures.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:get/get.dart';
import 'package:myrideuser/app/modules/auth/terms_and_conditions_screen.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  bool _isSendingOtp = false;
  bool _isGoogleSignIn = false;
  final TextEditingController mobileController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().initDeviceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                  },
                ),

                const SizedBox(height: Dimensions.spacingSize20),

                /// Title
                Padding(
                  padding: const EdgeInsets.only(
                    left: Dimensions.spacingSize12,
                    right: Dimensions.spacingSize12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: PoppinsSemiBold.copyWith(
                          fontSize: Dimensions.spacingSize20,
                          color: ColorResources.blackcolor11,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Please enter your phone number  to sign in to your My Ride account.",

                        style: PoppinsMedium.copyWith(
                          color: ColorResources.TextColorForGrey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Phone Label
                      Text(
                        "Phone Number",
                        style: PoppinsMedium.copyWith(
                          color: ColorResources.blackcolor11,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Phone TextField
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            /// 🌍 Network Flag + Code
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    "https://flagcdn.com/w40/in.png",
                                    height: 20,
                                    width: 30,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "+91",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 25,
                              width: 1,
                              color: Colors.grey.shade300,
                            ),

                            Expanded(
                              child: TextField(
                                controller: mobileController,
                                keyboardType: TextInputType.phone,
                                onChanged: (value) {
                                  if (value.length == 10) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: const InputDecoration(
                                  hintText: "Enter phone number",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Checkbox(
                            checkColor: ColorResources.buttonColors,
                            activeColor: ColorResources.blueeebutton,

                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "I agree to My Ride ",
                                style: PoppinsMedium.copyWith(
                                  fontSize: Dimensions.spacingSize12,

                                  color: ColorResources.blackcolor11,
                                ),

                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions.",
                                    style: PoppinsMedium.copyWith(
                                      color: ColorResources.blueeebutton,
                                      decoration: TextDecoration.underline,
                                      decorationColor: ColorResources.blueeebutton,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(
                                          () => const TermsAndConditionsScreen(),
                                          transition: Transition.rightToLeft,
                                          duration: const Duration(milliseconds: 300),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       checkColor: ColorResources.buttonColors,
                      //       activeColor: ColorResources.blueeebutton,

                      //       value: isChecked,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           isChecked = value!;
                      //         });
                      //       },
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(4),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: RichText(
                      //         text: TextSpan(
                      //           text: "Remember me ",
                      //           style: PoppinsMedium.copyWith(
                      //             color: ColorResources.blackcolor11,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "or",

                              style: PoppinsSemiBold.copyWith(
                                color: ColorResources.blackcolor11,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Social Buttons login===================================///////////
                      CustomSocialButton(
                        text: _isGoogleSignIn
                            ? "Signing in..."
                            : "Continue with Google",
                        images: 'assets/images/google.png',
                        iconColor: Colors.red,
                        onTap: () async {
                          if (_isGoogleSignIn) return;
                          if (!isChecked) {
                            AnimatedTopToast.show(
                              context: context,
                              message: "Please accept the Terms & Conditions to continue.",
                              backgroundColor: ColorResources.textColorBaclColor,
                              icon: Icons.info_outline,
                            );
                            return;
                          }
                          setState(() => _isGoogleSignIn = true);
                          try {
                            await Get.find<AuthController>().signInWithGoogle(
                              provider: 'google',
                              context: context,
                            );
                          } catch (e) {
                            AnimatedTopToast.show(
                              context: context,
                              message: "Google sign-in failed. Please try again.",
                              backgroundColor: ColorResources.textColorBaclColor,
                              icon: Icons.error_outline,
                            );
                          } finally {
                            if (mounted) setState(() => _isGoogleSignIn = false);
                          }
                        },
                      ),

                      // CustomSocialButton(
                      //   text: "Continue with Apple",
                      //   images: 'assets/images/apple.png',
                      //   iconColor: Colors.black,
                      //   onTap: () {},
                      // ),
                      // CustomSocialButton(
                      //   text: "Continue with X",
                      //   images:
                      //       'assets/images/twitter.png', // No official X icon in Material
                      //   iconColor: Colors.black,
                      //   onTap: () {},
                      // ),
                      const SizedBox(height: 30),

                      /// Sign in Button
                      CustomPrimaryButton(
                        text: _isSendingOtp ? "Sending OTP..." : "Sign in",
                        onTap: () async {
                          if (_isSendingOtp) return;

                          final mobile = mobileController.text.trim();

                          if (mobile.isEmpty) {
                            AnimatedTopToast.show(
                              context: context,
                              message: "Please enter your mobile number.",
                              backgroundColor: ColorResources.textColorBaclColor,
                              icon: Icons.error_outline,
                            );
                            return;
                          }

                          if (mobile.length != 10) {
                            AnimatedTopToast.show(
                              context: context,
                              message: "Please enter a valid 10-digit mobile number.",
                              backgroundColor: ColorResources.textColorBaclColor,
                              icon: Icons.error_outline,
                            );
                            return;
                          }

                          if (!isChecked) {
                            AnimatedTopToast.show(
                              context: context,
                              message: "Please accept the Terms & Conditions to continue.",
                              backgroundColor: ColorResources.textColorBaclColor,
                              icon: Icons.info_outline,
                            );
                            return;
                          }

                          setState(() => _isSendingOtp = true);
                          try {
                            await Get.find<AuthController>().initDeviceData();
                            await Get.find<AuthController>().sendOtp(
                              mobileNumber: mobile,
                              type: ApiConstants.UserLogin,
                              deviceToken:
                                  Get.find<AuthController>().deviceToken ?? "",
                              context: context,
                            );
                          } catch (e) {
                            AnimatedTopToast.show(
                              context: context,
                              message: "Failed to send OTP. Please try again.",
                              backgroundColor: ColorResources.textColorBaclColor,
                              icon: Icons.error_outline,
                            );
                          } finally {
                            if (mounted) setState(() => _isSendingOtp = false);
                          }
                          // Get.find<AuthController>().sendOtp(
                          //   mobileNumber: mobileController.text.trim(),
                          //   type: ApiConstants.UserLogin,
                          //   deviceToken:
                          //       Get.find<AuthController>().deviceToken!,
                          //   context: context,
                          // );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
