import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/Deshboard/buttom_navigation.dart';
import 'package:vivashri/app/modules/auth/login_screen.dart';
import 'package:vivashri/app/modules/profilefrom/basic_details.dart';
import 'package:vivashri/app/modules/profilefrom/contact_details.dart';
import 'package:vivashri/app/modules/profilefrom/religition_details.dart';
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
    Future.delayed(const Duration(milliseconds: 2000), () async {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      String? profileid = prefs.getString("profileid");
      print('Token:::::::::${token}');
      print('profileid:::::::::${profileid}');

      if (token != null && token.isNotEmpty) {
        //  Get.to(ReferenceDetailsScreen());
        checkUser(profileid);
      } else {
        Get.to(
          LoginScreen(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      }
    });
  }

  Future<void> checkUser(userid) async {
    await userC.fetchUserDetail(userid);

    final step = userC.userData.value?.appStep;

    if (userC.userData.value?.formStatus == "Completed") {
      Get.offAll(
        MainNavigation(),
        duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
        transition: Transition.rightToLeft,
      );
    } else {
      if (step is String) {
        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
        return;
      }

      if (step is int) {
        if (step == 2 || step == 3) {
          Get.offAll(
            ReligionDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
          return;
        }

        switch (step) {
          case 0:
            Get.offAll(
              BasicDetailsScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
            break;

          case 1:
            Get.offAll(
              ContactDetailsScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
            break;

          case 4:
            Get.offAll(
              ReligionDetailsScreen(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
            break;

          default:
            Get.offAll(
              MainNavigation(),
              duration: Duration(
                milliseconds: ApiConstants.screenTransitionTime,
              ),
              transition: Transition.rightToLeft,
            );
        }
      }
    }
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
          onTap: () {
            
          },
          child: Image.asset(Images.splashimage, fit: BoxFit.cover)),
      ),
    );
  }
}
