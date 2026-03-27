import 'package:evfual/data/controller/auth_controller.dart';
import 'package:evfual/data/controller/profile_controller.dart';
import 'package:evfual/data/controller/subscription_list.dart';
import 'package:flutter/material.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/drawer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscirptinPlan extends StatefulWidget {
  const SubscirptinPlan({super.key});

  @override
  State<SubscirptinPlan> createState() => _SubscirptinPlanState();
}

class _SubscirptinPlanState extends State<SubscirptinPlan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // int currentIndex = 0;
  // final controller = Get.put(SubscriptionController());
  // final profileecontroller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
     // drawer: CustomAppDrawer(),
      body: Center(child: Text('Comming Soon'),)
      // Stack(
      //   children: [
      //     Positioned.fill(
      //       child: Image.asset("assets/images/iPhone2.png", fit: BoxFit.cover),
      //     ),

      //     Column(
      //       children: [
      //         SizedBox(
      //           height: 160,
      //           width: double.infinity,
      //           child: SafeArea(
      //             bottom: false,
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(
      //                 horizontal: 10,
      //                 vertical: 6,
      //               ),
      //               child:
      //                Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       IconButton(
      //                         icon: const Icon(
      //                           Icons.menu,
      //                           color: Colors.white,
      //                           size: 30,
      //                         ),
      //                         onPressed: () {
      //                           _scaffoldKey.currentState!.openDrawer();
      //                         },
      //                       ),
      //                       Image.asset(
      //                         'assets/images/logo.png',
      //                         height: 60,
      //                         width: 100,
      //                       ),

      //                       CircleAvatar(
      //                         radius: 18,
      //                         backgroundImage:
      //                             profileecontroller.profileimagee == null
      //                             ? AssetImage("assets/images/user 1.png")
      //                             : NetworkImage(
      //                                 'https://evfuel.akslearning.in/${profileecontroller.profileimagee}',
      //                               ),
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(height: 10),
      //                   Padding(
      //                     padding: const EdgeInsets.only(left: 15),
      //                     child: Center(
      //                       child: Text(
      //                         "Subscription Plan",
      //                         style: opensansSemiBold.copyWith(
      //                           color: Colors.white,
      //                           fontSize: 22,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),

      //         /// 🔹 LIST SECTION
      //         Expanded(
      //           child: Obx(() {
      //             if (controller.isLoading.value) {
      //               return Center(child: CircularProgressIndicator());
      //             }

      //             return ListView.builder(
      //               padding: EdgeInsets.zero,
      //               itemCount: controller.subscriptionList.length,
      //               itemBuilder: (context, index) {
      //                 final plan = controller.subscriptionList[index];
      //                 return PlanCard(
      //                   plan: plan,
      //                   onSubscribe: () {
      //                     print('Plan IDdd:::${plan.subscriptionId}');
      //                     // debugPrint("Subscribed ${plans[index].title}");
      //                   },
      //                 );
      //               },
      //             );
      //           }),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
   
   
   
    );
  }
}

class PlanCard extends StatelessWidget {
  final SubscriptionModel plan;
  final VoidCallback onSubscribe;

  const PlanCard({super.key, required this.plan, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? token = prefs.getString("token");
              Get.find<AuthController>().subscribeadd(
                userid: token!,
                subscrptionid: plan.subscriptionId.toString(),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 45),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TOP
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: plan.bgColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          plan.planName,
                          style: opensansSemiBold.copyWith(fontSize: 17),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          plan.description,
                          style: opensansSemiBold.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 1, color: Colors.white),
                  // Divider(),
                  // PRICE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: plan.bgColor..withOpacity(.10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹${plan.planPrice}",
                          style: opensansSemiBold.copyWith(fontSize: 38),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "/ For ${plan.validityDays} Days",
                          style: opensansSemiBold.copyWith(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 1, color: Colors.white),

                  // RATE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: plan.bgColor.withOpacity(.5),
                    child: Center(
                      child: Text(
                        "RATE PER SWAP : ₹${plan.ratePerSwap}",
                        style: opensansSemiBold.copyWith(fontSize: 16),
                      ),
                    ),
                  ),

                  // FREE SWAPS
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Free Swaps: ${plan.freeSwap}",
                          style: opensansSemiBold.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.list_alt),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------------- BUTTON (OUTSIDE) ----------------
          Positioned(
            bottom: -15,
            child: GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? token = prefs.getString("token");
                Get.find<AuthController>().subscribeadd(
                  userid: token!,
                  subscrptionid: plan.subscriptionId.toString(),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 42,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: plan.bgColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.25),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  "Subscribe Now",
                  style: opensansSemiBold.copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
