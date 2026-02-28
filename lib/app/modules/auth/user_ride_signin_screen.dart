import 'package:evfual/app/modules/auth/login_screen.dart';
import 'package:evfual/app/modules/auth/otp_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class UserSignInpScreen extends StatefulWidget {
  const UserSignInpScreen({Key? key}) : super(key: key);

  @override
  State<UserSignInpScreen> createState() => _UserSignInpScreenState();
}

class _UserSignInpScreenState extends State<UserSignInpScreen> {
  bool isChecked = false;
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ColorResources.backgroundColor,
     appBar:AppBar(leading:  IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                  },
                ),
                elevation: 0,
                  backgroundColor:ColorResources.backgroundColor,
                
                )
     ,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                /// Back Button
               

                const SizedBox(height: 20),

                /// Title
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Join My Ride Today ✨",
                        style: PoppinsSemiBold.copyWith(
                          fontSize: 22,

                          color: ColorResources.blackcolor11,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Let’s get started! Enter your phone number to create your My Ride account.",
                        style: PoppinsMedium.copyWith(
                          fontSize: 13,

                          color: ColorResources.TextColorForGrey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Phone Label
                      Text(
                        "Phone Number",
                        style: PoppinsMedium.copyWith(
                          fontSize: 15,

                          color: ColorResources.blackcolor11,
                        ),
                      ),

                      const SizedBox(height: 10),

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

                      const SizedBox(height: 20),

                      /// Terms Checkbox
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
                                  fontSize: 13,

                                  color: ColorResources.blackcolor11,
                                ),

                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions.",
                                    style: PoppinsMedium.copyWith(
                                      fontSize: 13,

                                      color: ColorResources.blueeebutton,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// Sign In
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(
                              "Already have an account?",
                              style: PoppinsMedium.copyWith(
                                fontSize: 13,

                                color: ColorResources.blackcolor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign in",
                                style: PoppinsMedium.copyWith(
                                  fontSize: 13,

                                  color: ColorResources.blueeebutton,
                                ), //
                              ),
                            ),
                          ],
                        ),

                        //  RichText(
                        //   text: TextSpan(
                        //     text: "Already have an account? ",
                        //     style: PoppinsMedium.copyWith(
                        //       fontSize: 15,

                        //       color: ColorResources.blackcolor11,
                        //     ),
                        //     children: [
                        //       // TextSpan(
                        //       //   text: "Sign in",
                        //       //   style: PoppinsMedium.copyWith(
                        //       //     fontSize: 15,

                        //       //     color: ColorResources.blueeebutton,
                        //       //   ),
                        //       // ),
                        //     ],
                        //   ),
                        // ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "or",

                              style: PoppinsSemiBold.copyWith(
                                fontSize: 15,

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
                      images: 'assets/images/twitter.png',// No official X icon in Material
                        iconColor: Colors.black,
                        onTap: () {},
                      ),

                      const SizedBox(height: 30),

                      /// Sign Up Button
                      CustomPrimaryButton(
                        text: "Sign up",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(),
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
