import 'dart:async';

import 'package:myrideuser/config/route.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
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
    final String? token = prefs.getString(ApiConstants.token);
    final String? userId = prefs.getString(ApiConstants.profileid);

    customerId = userId?.toString();

    if (token != null && token.isNotEmpty) {
      // Always ask the server — never trust a stale local bookingid.
      Get.offAllNamed(RouteHelper.getAppEntryRouter());
    } else {
      final bool hasSeenOnboarding =
          prefs.getBool('has_seen_onboarding') ?? false;
      if (hasSeenOnboarding) {
        Get.toNamed(RouteHelper.getLestMyRideStartedScreenRoute());
      } else {
        Get.toNamed(RouteHelper.getOnboardingRoute());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
