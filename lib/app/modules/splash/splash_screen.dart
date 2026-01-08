import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evfual/app/modules/splash/onbording_screen.dart';

import 'package:evfual/config/utils/all_images.dart';
import 'package:evfual/config/utils/constants.dart';

class VivashriIntro extends StatefulWidget {
  const VivashriIntro({super.key});

  @override
  State<VivashriIntro> createState() => _VivashriIntroState();
}

class _VivashriIntroState extends State<VivashriIntro>
    with TickerProviderStateMixin {
  late AnimationController logoController;
  late Animation<double> logoScale;
  late Animation<double> logoSlide;

  late AnimationController contentController;
  late Animation<double> contentOpacity;
  late Animation<double> contentSlide;

  @override
  void initState() {
    super.initState();

    // ================= LOGO ZOOM OUT ======================
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    logoScale = Tween<double>(begin: 2.8, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutCubic),
    );

    logoSlide = Tween<double>(begin: 80, end: 0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutCubic),
    );

    // ============== CONTENT FADE IN ======================
    contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    contentOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: contentController, curve: Curves.easeOut),
    );

    contentSlide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: contentController, curve: Curves.easeOut),
    );

    // Start animations
    logoController.forward();

    // After logo animation → show content
    Future.delayed(const Duration(milliseconds: 1400), () {
      contentController.forward();
    });
    Future.delayed(const Duration(milliseconds: 2000), () async {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      String? profileid = prefs.getString("profileid");
      print('Token:::::::::${token}');
      print('profileid:::::::::${profileid}');

      if (token != null && token.isNotEmpty) {
      } else {
        Get.to(
          Splash1(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      }
    });
  }

  @override
  void dispose() {
    logoController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      body: SizedBox.expand(
        child: GestureDetector(
          onTap: () {},
          child: Image.asset(Images.introscreen, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
