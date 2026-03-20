// import 'package:evfual/app/modules/auth/sign_up_screen.dart';
// import 'package:evfual/config/utils/colors.dart';
// import 'package:evfual/config/utils/style.dart';
// import 'package:evfual/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// class Splash1 extends StatefulWidget {
//   const Splash1({Key? key}) : super(key: key);

//   @override
//   State<Splash1> createState() => _Splash1State();
// }

// class _Splash1State extends State<Splash1> {
//   int currentIndex = 0;

//   final List<Map<String, String>> pages = [
//     {
//       "image": "assets/images/walk1.svg",
//       "title": "Welcome to My Ride – Your Journey, Your Way",
//       "desc":
//           "Get ready to experience hassle-free transportation. We've got everything you need to travel with ease. Let’s get started!",
//     },
//     {
//       "image": "assets/images/walk2.svg",
//       "title": "Choose Your Ride – Tailored to Your Needs",
//       "desc":
//           "Select your preferred mode of transportation – motorbike / scooter, or car – and order a ride with just a few taps.",
//     },
//     {
//       "image": "assets/images/walk3.svg",
//       "title": "Secure Payments & Seamless Transactions",
//       "desc":
//           "Pay for your rides securely using Wallet, PhonePe, Paytm, Google Pay, card or cash.",
//     },
//   ];

//   void nextPage() {
//     if (currentIndex < pages.length - 1) {
//       setState(() {
//         currentIndex++;
//       });
//     } else {
//       // Get.to(
//       //   //   UserSignInpScreen(),
//       //   //   transition: Transition.leftToRight,
//       //   //   duration: Duration(milliseconds: 0),
//       //   // );
//       Get.offAll(
//         MyRideLoginScreen(),
//         transition: Transition.leftToRight,
//         duration: Duration(milliseconds: 0),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final height = size.height;
//     final width = size.width;

//     return Scaffold(
//       backgroundColor: ColorResources.backgroundColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// 🔹 Top Content
//             Expanded(
//               flex: 6,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.07),
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Column(
//                       children: [
//                         SizedBox(height: height * 0.09),

//                         /// 🔹 Animated Content
//                         Expanded(
//                           child: AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 400),
//                             child: Column(
//                               key: ValueKey<int>(currentIndex),
//                               children: [
//                                 /// ✅ Responsive SVG
//                                 SizedBox(
//                                   height: height * 0.32,
//                                   child: SvgPicture.asset(
//                                     pages[currentIndex]["image"]!,
//                                     fit: BoxFit.contain,
//                                   ),
//                                 ),

//                                 SizedBox(height: height * 0.04),

//                                 /// 🔹 Title
//                                 Text(
//                                   pages[currentIndex]["title"]!,
//                                   textAlign: TextAlign.center,
//                                   style: PoppinsBold.copyWith(
//                                     fontSize: width * 0.055,
//                                     color: Colors.black87,
//                                   ),
//                                 ),

//                                 SizedBox(height: height * 0.02),

//                                 /// 🔹 Description
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: width * 0.03,
//                                   ),
//                                   child: Text(
//                                     pages[currentIndex]["desc"]!,
//                                     textAlign: TextAlign.center,
//                                     style: PoppinsMedium.copyWith(
//                                       fontSize: width * 0.035,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),

//                                 SizedBox(height: height * 0.03),

//                                 /// 🔹 Dots
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: List.generate(
//                                     pages.length,
//                                     (index) => AnimatedContainer(
//                                       duration: const Duration(
//                                         milliseconds: 300,
//                                       ),
//                                       margin: EdgeInsets.symmetric(
//                                         horizontal: width * 0.01,
//                                       ),
//                                       height: 6,
//                                       width: currentIndex == index
//                                           ? width * 0.08
//                                           : width * 0.02,
//                                       decoration: BoxDecoration(
//                                         color: currentIndex == index
//                                             ? ColorResources.blueeebutton
//                                             : Colors.grey.shade300,
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),

//             Divider(color: Colors.grey.shade300),

//             /// 🔹 Buttons Section
//             Expanded(
//               flex: 2,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.06),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         /// Skip
//                         Expanded(
//                           child: CustomSecondaryDynamicButton(
//                             text: "Skip",
//                             onTap: () {
//                               Get.to(
//                                 MyRideLoginScreen(),
//                                 transition: Transition.leftToRight,
//                                 duration: Duration(milliseconds: 0),
//                               );
//                             },
//                           ),
//                         ),

//                         // SizedBox(width: width * 0.04),

//                         // /// Continue
//                         // Expanded(
//                         //   child: CustomPrimaryDyanamicButton(
//                         //     text: currentIndex == pages.length - 1
//                         //         ? "Continue"
//                         //         : "Continue",

//                         //     onTap: nextPage,
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
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
  Timer? timer;

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

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      nextPage();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      timer?.cancel();

      // Get.offAll(
      //   MyRideLoginScreen(),
      //   transition: Transition.leftToRight,
      //   duration: const Duration(milliseconds: 0),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        SizedBox(height: height * 0.09),

                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Column(
                              key: ValueKey<int>(currentIndex),
                              children: [
                                SizedBox(
                                  height: height * 0.32,
                                  child: SvgPicture.asset(
                                    pages[currentIndex]["image"]!,
                                    fit: BoxFit.contain,
                                  ),
                                ),

                                SizedBox(height: height * 0.04),

                                Text(
                                  pages[currentIndex]["title"]!,
                                  textAlign: TextAlign.center,
                                  style: PoppinsBold.copyWith(
                                    fontSize: width * 0.055,
                                    color: Colors.black87,
                                  ),
                                ),

                                SizedBox(height: height * 0.02),

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

            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: width * 0.35,
                      child: CustomPrimaryDyanamicButton(
                        text: "Skip",
                        onTap: () {
                          timer?.cancel();

                          if (currentIndex < pages.length - 1) {
                            setState(() {
                              currentIndex++;
                            });

                            timer = Timer.periodic(
                              const Duration(seconds: 2),
                              (Timer t) => nextPage(),
                            );
                          } else {
                            Get.offAll(
                              MyRideLoginScreen(),
                              transition: Transition.leftToRight,
                              duration: const Duration(milliseconds: 0),
                            );
                          }
                        },
                      ),
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
}
