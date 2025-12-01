import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/auth/login_screen.dart';
import 'package:vivashri/app/modules/profilefrom/basic_details.dart';
import 'package:vivashri/app/modules/profilefrom/more_details.dart';
import 'package:vivashri/config/route.dart';
import 'package:vivashri/config/utils/all_images.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/data/controller/userprofile.dart';

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
  final userC = Get.put(UserDetailController());

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
    Future.delayed(const Duration(milliseconds: 2300), () async {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      String? profileid = prefs.getString("profileid");
      print('Token:::::::::${token}');
      print('profileid:::::::::${profileid}');

      if (token != null && token.isNotEmpty) {
        // checkUser(profileid);
        Get.off(
          BasicDetailsScreen(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      } else {
        Get.to(
          LoginScreen(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
        //  Get.offAllNamed(RouteHelper.loginScreen);
      }
    });
  }

  // Future<void> checkUser(userid) async {
  //   await userC.fetchUserDetail(userid);

  //   final step = userC.userData.value?.appStep;

  //   if (step == null) {
  //     Get.offAllNamed(Routes.dashboard);
  //     return;
  //   }

  //   // if text → dashboard
  //   if (step is String) {
  //     Get.offAllNamed(Routes.dashboard);
  //     return;
  //   }

  //   // 0 to 18 but skip 4
  //   if (step is int) {
  //     if (step == 4) {
  //       Get.offAllNamed(Routes.dashboard);
  //       return;
  //     }

  //     switch (step) {
  //       case 0:
  //         Get.offAllNamed(Routes.profilePage);
  //         break;
  //       case 1:
  //         Get.offAllNamed(Routes.mobileDetailsPage);
  //         break;
  //       case 2:
  //         Get.offAllNamed(Routes.addressPage);
  //         break;
  //       case 3:
  //         Get.offAllNamed(Routes.educationPage);
  //         break;

  //       // 4 skip

  //       case 5:
  //         Get.offAllNamed(Routes.familyDetailsPage);
  //         break;
  //       case 6:
  //         Get.offAllNamed(Routes.hobbiesPage);
  //         break;

  //       case 18:
  //         Get.offAllNamed(Routes.finalSubmitPage);
  //         break;

  //       default:
  //         Get.offAllNamed(Routes.dashboard);
  //     }
  //   }
  // }

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
      body: Column(
        children: [
          const SizedBox(height: 70),

          AnimatedBuilder(
            animation: logoController,
            builder: (_, __) {
              return Transform.translate(
                offset: Offset(0, logoSlide.value),
                child: Transform.scale(
                  scale: logoScale.value,
                  child: Image.asset(
                    Images.splashimage,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          // =================== COUPLE IMAGE ======================
          AnimatedBuilder(
            animation: contentController,
            builder: (_, __) {
              return Opacity(
                opacity: contentOpacity.value,
                child: Transform.translate(
                  offset: Offset(0, contentSlide.value),
                  child: Image.asset(Images.introscreen, height: 200),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // ================= TAGLINE =================
          AnimatedBuilder(
            animation: contentController,
            builder: (_, __) {
              return Opacity(
                opacity: contentOpacity.value,
                child: Transform.translate(
                  offset: Offset(0, contentSlide.value),
                  child: Column(
                    children: [
                      Text(
                        "Best Way To Find",
                        style: TextStyle(
                          color: Colors.pink.shade600,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Perfect Life Partner",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // ================= BUTTON ==================
          AnimatedBuilder(
            animation: contentController,
            builder: (_, __) {
              return Opacity(
                opacity: contentOpacity.value,
                child: Transform.translate(
                  offset: Offset(0, contentSlide.value),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.onbordingscreen, arguments: true);
                    },
                    child: Container(
                      height: 55,
                      width: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE91E63), Color(0xFFF06292)],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
