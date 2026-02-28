import 'package:evfual/app/modules/auth/sign_up_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Splash1 extends StatefulWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/walk1.svg",
      "title": "Welcome to My Ride – Your Journey, Your Way",
      "desc":
          "Get ready to experience hassle-free transportation. We've got everything you need to travel with ease. Let’s get started!",
    },
    {
      "image": "assets/images/walk2.svg",
      "title": "Choose Your Ride – Tailored to Your Needs",
      "desc":
          "Select your preferred mode of transportation – motorbike / scooter, or car – and order a ride with just a few taps.",
    },
    {
      "image": "assets/images/walk3.svg",
      "title": "Secure Payments & Seamless Transactions",
      "desc":
          "Pay for your rides securely using Wallet, PhonePe, Paytm, Google Pay, card or cash.",
    },
  ];

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Get.to(
      //   //   UserSignInpScreen(),
      //   //   transition: Transition.leftToRight,
      //   //   duration: Duration(milliseconds: 0),
      //   // );
      Get.offAll(
        MyRideLoginScreen(),
        transition: Transition.leftToRight,
        duration: Duration(milliseconds: 0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
     backgroundColor:ColorResources.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Top Content
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        SizedBox(height: height * 0.09),

                        /// 🔹 Animated Content
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Column(
                              key: ValueKey<int>(currentIndex),
                              children: [
                                /// ✅ Responsive SVG
                                SizedBox(
                                  height: height * 0.32,
                                  child: SvgPicture.asset(
                                    pages[currentIndex]["image"]!,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                SizedBox(height: height * 0.04),

                                /// 🔹 Title
                                Text(
                                  pages[currentIndex]["title"]!,
                                  textAlign: TextAlign.center,
                                  style: PoppinsBold.copyWith(
                                    fontSize: width * 0.055,
                                    color: Colors.black87,
                                  ),
                                ),

                                SizedBox(height: height * 0.02),

                                /// 🔹 Description
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                  ),
                                  child: Text(
                                    pages[currentIndex]["desc"]!,
                                    textAlign: TextAlign.center,
                                    style: PoppinsMedium.copyWith(
                                      fontSize: width * 0.035,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),

                                SizedBox(height: height * 0.03),

                                /// 🔹 Dots
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    pages.length,
                                    (index) => AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.01,
                                      ),
                                      height: 6,
                                      width: currentIndex == index
                                          ? width * 0.08
                                          : width * 0.02,
                                      decoration: BoxDecoration(
                                        color: currentIndex == index
                                            ? ColorResources.blueeebutton
                                            : Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),

            Divider(color: Colors.grey.shade300),

            /// 🔹 Buttons Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        /// Skip
                        Expanded(
                          child: CustomSecondaryDynamicButton(
                            text: "Skip",
                            onTap: () {
                              Get.to(
                                MyRideLoginScreen(),
                                transition: Transition.leftToRight,
                                duration: Duration(milliseconds: 0),
                              );
                            },
                          ),

                          // OutlinedButton(
                          //   onPressed: () {
                          //     Get.offAll(MyRideLoginScreen());
                          //   },
                          //   style: OutlinedButton.styleFrom(
                          //     backgroundColor: ColorResources.buttonColors,
                          //     padding: EdgeInsets.symmetric(
                          //       vertical: height * 0.018,
                          //     ),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          //   child: Text(
                          //     "Skip",
                          //     style: PoppinsReguler.copyWith(
                          //       fontSize: width * 0.04,
                          //       color: ColorResources.blueeebutton,
                          //     ),
                          //   ),
                          // ),
                        ),

                        SizedBox(width: width * 0.04),

                        /// Continue
                        Expanded(
                          child: CustomPrimaryDyanamicButton(
                            text: currentIndex == pages.length - 1
                                ? "Continue"
                                //"Get Started"
                                : "Continue",

                            /// "Sign up",
                            onTap: nextPage,
                            //  () {
                            //   // Get.to(
                            //   //   UserSignInpScreen(),
                            //   //   transition: Transition.leftToRight,
                            //   //   duration: Duration(milliseconds: 0),
                            //   // );
                            // },
                          ),

                          // ElevatedButton(
                          //   onPressed: nextPage,
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: ColorResources.blueeebutton,
                          //     padding: EdgeInsets.symmetric(
                          //       vertical: height * 0.018,
                          //     ),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          //   child: Text(
                          //     currentIndex == pages.length - 1
                          //         ? "Get Started"
                          //         : "Continue",
                          //     style: PoppinsSemiBold.copyWith(
                          //       fontSize: width * 0.04,
                          //       color: ColorResources.buttonColors,
                          //     ),
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFF4F6F8),
  //     body: SafeArea(
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 25),
  //               child: Column(
  //                 children: [
  //                   const SizedBox(height: 40),

  //                   /// ✅ Animated Content
  //                   Expanded(
  //                     child: AnimatedSwitcher(
  //                       duration: const Duration(milliseconds: 500),
  //                       transitionBuilder: (child, animation) {
  //                         return FadeTransition(
  //                           opacity: animation,
  //                           child: child,
  //                         );
  //                       },
  //                       child: Column(
  //                         key: ValueKey<int>(currentIndex),
  //                         children: [
  //                           SvgPicture.asset(
  //                             pages[currentIndex]["image"]!,
  //                             height: 300,
  //                             fit: BoxFit.contain,
  //                           ),
  //                           const SizedBox(height: 40),
  //                           Text(
  //                             pages[currentIndex]["title"]!,
  //                             textAlign: TextAlign.center,
  //                             style: PoppinsBold.copyWith(
  //                               fontSize: 22,
  //                               color: Colors.black87,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 20),
  //                           Text(
  //                             pages[currentIndex]["desc"]!,
  //                             textAlign: TextAlign.center,
  //                             style: PoppinsMedium.copyWith(
  //                               fontSize: 13,
  //                               color: Colors.grey,
  //                             ),
  //                           ),
  //                           SizedBox(height: 25),
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: List.generate(
  //                               pages.length,
  //                               (index) => AnimatedContainer(
  //                                 duration: const Duration(milliseconds: 300),
  //                                 margin: const EdgeInsets.symmetric(
  //                                   horizontal: 4,
  //                                 ),
  //                                 height: 6,
  //                                 width: currentIndex == index ? 28 : 7,
  //                                 decoration: BoxDecoration(
  //                                   color: currentIndex == index
  //                                       ? ColorResources.blueeebutton
  //                                       : Colors.grey.shade300,
  //                                   borderRadius: BorderRadius.circular(10),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),

  //                   const SizedBox(height: 25),

  //                   /// 🔹 Dot Indicator
  //                 ],
  //               ),
  //             ),
  //           ),

  //           const SizedBox(height: 30),

  //           /// 🔹 Buttons
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 25),
  //             child: Row(
  //               children: [
  //                 /// Skip
  //                 Expanded(
  //                   child: OutlinedButton(
  //                     onPressed: () {
  //                       Get.offAll(MyRideLoginScreen());
  //                     },
  //                     style: OutlinedButton.styleFrom(
  //                       backgroundColor: ColorResources.buttonColors,
  //                       padding: const EdgeInsets.symmetric(vertical: 14),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(30),
  //                       ),
  //                       side: BorderSide(color: Colors.grey.shade100),
  //                     ),
  //                     child: Text(
  //                       "Skip",
  //                       style: PoppinsReguler.copyWith(
  //                         fontSize: 16,
  //                         color: ColorResources.blueeebutton,
  //                       ),
  //                     ),
  //                   ),
  //                 ),

  //                 const SizedBox(width: 15),

  //                 /// Continue
  //                 Expanded(
  //                   child: ElevatedButton(
  //                     onPressed: nextPage,
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: ColorResources.blueeebutton,
  //                       padding: const EdgeInsets.symmetric(vertical: 14),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(30),
  //                       ),
  //                     ),
  //                     child: Text(
  //                       currentIndex == pages.length - 1
  //                           ? "Get Started"
  //                           : "Continue",
  //                       style: PoppinsSemiBold.copyWith(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.bold,
  //                         color: ColorResources.buttonColors,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),

  //           const SizedBox(height: 30),
  //         ],
  //       ),
  //     ),
  //   );

  // }
}
