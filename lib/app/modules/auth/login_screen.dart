import 'package:evfual/app/modules/auth/otp_screen.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  final TextEditingController mobileController = TextEditingController();

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

                const SizedBox(height: 20),

                /// Title
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back 👋",
                        style: PoppinsSemiBold.copyWith(
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
                        height: 50, // 👈 Fixed height dena zaroori
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IntlPhoneField(
                          controller: mobileController,
                          initialCountryCode: 'IN',
                          // textAlign: TextAlign.center,
                          style: const TextStyle(
                            height:
                                1.2, // 👈 vertical alignment better karta hai
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: 'Phone Number',
                            border: InputBorder.none,
                            isCollapsed: true, // 👈 IMPORTANT
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 18, // 👈 Adjust this (16–20 best range)
                            ),
                          ),
                          dropdownIconPosition: IconPosition.trailing,
                          flagsButtonPadding: const EdgeInsets.only(left: 10),
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
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
                                text: "Remember me ",
                                style: PoppinsMedium.copyWith(
                                  color: ColorResources.blackcolor11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

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
                        text: "Continue with Google",
                        images: 'assets/images/google.png',
                        iconColor: Colors.red,

                        onTap: () {},
                      ),

                      CustomSocialButton(
                        text: "Continue with Apple",
                        images: 'assets/images/apple.png',
                        iconColor: Colors.black,
                        onTap: () {},
                      ),

                      CustomSocialButton(
                        text: "Continue with Facebook",
                        images: 'assets/images/facebook.png',
                        iconColor: Colors.blue,
                        onTap: () {},
                      ),

                      CustomSocialButton(
                        text: "Continue with X",
                        images:
                            'assets/images/twitter.png', // No official X icon in Material
                        iconColor: Colors.black,
                        onTap: () {},
                      ),

                      const SizedBox(height: 30),

                      /// Sign Up Button
                      CustomPrimaryButton(
                        text: "Sign in",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(type: "Sign in"),
                            ),
                          );
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
