import 'dart:async';

import 'package:myrideuser/app/modules/Deshboard/buttom_navigation.dart';
import 'package:myrideuser/config/route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myrideuser/config/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    Future.delayed(Duration(seconds: 5), () {
      _navigateAfterDelay();
    });
  }

  Future<void> _navigateAfterDelay() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? apitoken = prefs.getString("usertoken");

    ///usertoken
    String? userId = prefs.getString(ApiConstants.profileid);
    String bookingId = prefs.getString(ApiConstants.bookingid) ?? "";

    customerId = userId.toString();

    if (token != null && token.isNotEmpty) {
      if (bookingId.isNotEmpty) {
        try {
          await Get.find<BookingController>().TrackRideApi(
            context: context,
            bookingid: bookingId,
          );
        } catch (e) {
          print("TrackRideApi error from splash: $e");
          // Clear stale booking ID and navigate to main screen
          await prefs.remove(ApiConstants.bookingid);
          Get.offAll(
            MainNavigation(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        }
      } else {
        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      }
    } else {
      Get.toNamed(RouteHelper.getOnboardingRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2DA6C4),
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: Lottie.asset(
            'assets/images/Animation - 1774346600606.json',
            height: 250,
            width: 250,
            repeat: false,
            animate: true,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
