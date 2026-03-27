

import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/app/modules/splash/onbording_screen.dart';
import 'package:evfual/config/route.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:evfual/config/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 4)); // 2 seconds splash

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token != null && token.isNotEmpty) {
      Get.offAll(
        MainNavigation(),
        duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
        transition: Transition.rightToLeft,
      );
    } else {
      Get.toNamed(RouteHelper.getOnboardingRoute());
      // Get.offAll(
      //   LestStartedScreen(),
      //   duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
      //   transition: Transition.rightToLeft,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2DA6C4), // Blue background like image
      body: Center(child: Image.asset('assets/images/splashscreen.png',height: 100,width: 250,)),
    );
  }
}
