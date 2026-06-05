

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';

class OnBoardingSCreen extends StatefulWidget {
  const OnBoardingSCreen({super.key});

  @override
  State<OnBoardingSCreen> createState() => _OnBoardingSCreenState();
}

class _OnBoardingSCreenState extends State<OnBoardingSCreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/driver-pana.json",
      "title": "Quick & Easy Ride Booking",
      "subtitle": "Book a ride in seconds. Just enter your destination and get matched with a nearby driver instantly.",
    },
    {
      "image": "assets/images/frame.json",
      "title": "Verified Drivers for Your Safety",
      "subtitle":"Ride with confidence. All drivers are background-checked and trained for a safe journey.",
    },
    {
      "image": "assets/images/mobile-landing.json",
      "title": "Live Ride Tracking",
      "subtitle":
          "Track your ride in real time. Share your trip details with friends and family for added safety.",
    },
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < onboardingData.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
  final height = size.height;
  final width = size.width;

  return Scaffold(
    backgroundColor: ColorResources.appgroundcolor,
    body: SafeArea(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.02,
            ),
            child: Column(
              children: [
                SizedBox(height: height * 0.04),

                /// PAGE VIEW
                SizedBox(
                  height: height * 0.65,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          key: ValueKey(index),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// IMAGE
                            SizedBox(
                              height: height * 0.28,
                              child: Lottie.asset(
                                onboardingData[index]["image"]!,
                                fit: BoxFit.contain,
                              ),
                            ),

                            SizedBox(height: height * 0.04),

                            /// TITLE
                            Text(
                              onboardingData[index]["title"]!,
                              textAlign: TextAlign.center,
                              style: PoppinsBold.copyWith(
                                fontSize: width * 0.06,
                                color: ColorResources.blackcolor,
                              ),
                            ),

                            SizedBox(height: height * 0.02),

                            /// SUBTITLE
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                              ),
                              child: Text(
                                onboardingData[index]["subtitle"]!,
                                textAlign: TextAlign.center,
                                style: PoppinsReguler.copyWith(
                                  fontSize: width * 0.038,
                                  color:
                                      ColorResources.TextColorForGrey,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// DOT INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin:
                          EdgeInsets.symmetric(horizontal: width * 0.01),
                      height: width * 0.02,
                      width: _currentIndex == index
                          ? width * 0.06
                          : width * 0.02,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? ColorResources.appColor
                            : ColorResources.greycolorborder,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.04),

                /// BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: width * 0.35,
                    child: CustomPrimaryDyanamicButton(
                      text: _currentIndex == onboardingData.length - 1
                          ? "Start"
                          : "Next",
                      onTap: () {
                        _timer?.cancel();

                        if (_currentIndex <
                            onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration:
                                const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Get.toNamed(
                            RouteHelper
                                .getLestMyRideStartedScreenRoute(),
                          );
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}
