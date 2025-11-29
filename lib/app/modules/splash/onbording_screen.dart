import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/auth/login_screen.dart';
import 'package:vivashri/config/utils/all_images.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/dimensions.dart';
import 'package:vivashri/config/utils/style.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> data = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Create Profile",
      "desc":
          "Create profile is the best way for\nfinding your life partner will be\nthrough Vivashri",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Search for Matches",
      "desc":
          "You can find upto lakhs of profile\nlist and choose your soulmate by\nthe same",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Send Interest & Connect",
      "desc":
          "You can find and send your\nperposal to the list provided by\nVivashri",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.background, fit: BoxFit.cover),
          ),

          SafeArea(
            child: Column(
              children: [
                SizedBox(height: Dimensions.iconSize),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: data.length,
                    onPageChanged: (value) {
                      setState(() => currentPage = value);
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          const SizedBox(height: 50),

                          Image.asset(data[index]["image"]!, height: 310),

                          const SizedBox(height: 40),

                          Text(
                            data[index]["title"]!,
                            style: opensansBold.copyWith(
                              fontSize: 25,
                              color: ColorResources.primarycolor,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 15),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              data[index]["desc"]!,
                              style: opensansRegular.copyWith(
                                fontSize: 18,
                                color: ColorResources.blackcolor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    data.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: currentPage == index ? 20 : 8,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? ColorResources.primarycolor
                            : Colors.pink.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(
                            LoginScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Text(
                          "Skip",
                          style: opensansSemiBold.copyWith(
                            color: ColorResources.primarycolor,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          if (currentPage == data.length - 1) {
                            Get.to(
                              LoginScreen(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                            // Get.toNamed(RouteHelper.login, arguments: true);
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: ColorResources.primarycolor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
