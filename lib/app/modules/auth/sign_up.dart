import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/auth/login_screen.dart';
import 'package:vivashri/app/modules/auth/signup_otp.dart';
import 'package:vivashri/config/utils/all_images.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                      "Register for Free",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mobile No. / Email ID",
                        style: opensansMedium.copyWith(
                          fontSize: 15,
                          color: ColorResources.blackgrey,
                        ),
                      ),
                      const SizedBox(height: 5),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black38),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "We will send you OTP to Register",
                        style: opensansMedium.copyWith(
                          fontSize: 13,
                          color: ColorResources.blackgrey,
                        ),
                      ),

                      const SizedBox(height: 40),

                      GestureDetector(
                        onTap: () {
                          Get.to(
                            SignUpOtpScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFBE266B), Color(0xFFEB1D7B)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Send OTP",
                              style: opensansRegular.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: opensansMedium.copyWith(
                              color: ColorResources.blackgrey,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: "Login",
                                style: opensansMedium.copyWith(
                                  color: ColorResources.primarycolor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(
                                      LoginScreen(),
                                      duration: Duration(
                                        milliseconds:
                                            ApiConstants.screenTransitionTime,
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 120),
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
