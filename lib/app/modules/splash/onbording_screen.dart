import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evfual/app/modules/auth/login_screen.dart';
import 'package:evfual/app/modules/auth/sign_up.dart';
import 'package:evfual/config/utils/all_images.dart';
import 'package:evfual/config/utils/constants.dart';
import 'package:evfual/config/utils/style.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background Image
          Positioned.fill(
            child: Image.asset(Images.background, fit: BoxFit.cover),
          ),

          /// 🔹 Content over image
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 6),
                SizedBox(height: 30),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "USER LOGIN",
                    textAlign: TextAlign.center,
                    style: opensansSemiBold.copyWith(
                      fontSize: 22,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Material(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Get.to(
                            LoginScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF00D672), Color(0xFF198D5A)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "LOG IN NOW",
                              style: opensansSemiBold.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "OR",
                    textAlign: TextAlign.center,
                    style: opensansSemiBold.copyWith(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Material(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Get.to(
                            RegisterScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF07424F), Color(0xFF000000)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: Center(
                            child: Text(
                              "CREATE A ACCOUNT",
                              style: opensansSemiBold.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
