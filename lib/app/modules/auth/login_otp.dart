import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/auth/sign_up.dart';
import 'package:vivashri/app/modules/profilefrom/basic_details.dart';
import 'package:vivashri/config/utils/all_images.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorResources.primarycolor,

      body: Stack(
        children: [
          SizedBox(
            height: size.height * 0.45,
            width: double.infinity,
            child: Image.asset(Images.loginscren, fit: BoxFit.cover),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: size.height * 0.35,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset("assets/images/logo2.png", height: 35),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorResources.primarycolor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Login To Your Account",
                      style: opensansMedium.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Enter the one time password",
                        style: opensansRegular.copyWith(
                          fontSize: 16,
                          color: ColorResources.primarycolor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Divider(),

                      const SizedBox(height: 5),

                      Text(
                        "A code has been sent to nam*****@gmail.com",
                        style: opensansRegular.copyWith(
                          color: ColorResources.blackgrey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // OTP Boxes Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => Container(
                            height: 55,
                            width: 55,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Submit OTP Button
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            BasicDetailsScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFBE266B), Color(0xFFEB1D7B)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Submit OTP",
                              style: opensansRegular.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Sign Up
                      RichText(
                        text: TextSpan(
                          text: "New to Vivashri? ",
                          style: opensansMedium.copyWith(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: opensansMedium.copyWith(
                                color: ColorResources.primarycolor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(
                                    SignUpScreen(),
                                    duration: Duration(
                                      milliseconds:
                                          ApiConstants.screenTransitionTime,
                                    ),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                            ),
                            const TextSpan(text: " free."),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
