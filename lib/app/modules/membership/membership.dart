import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/notification/notification.dart';
import 'package:vivashri/app/modules/search/search.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/membership.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/drawer.dart';

class MembershipPlansPage extends StatefulWidget {
  String? hidenav;
  MembershipPlansPage({super.key, this.hidenav});

  @override
  _MembershipPlansPageState createState() => _MembershipPlansPageState();
}

class _MembershipPlansPageState extends State<MembershipPlansPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.put(MembershipPlanController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      drawer: CustomAppDrawer(),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(w),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset('assets/images/Frame 66.png'),
                        Obx(() {
                          if (controller.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: ColorResources.primarycolor2,
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: controller.planList.map((p) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: _planCard(p.name, p.price, p.id),
                                );
                              }).toList(),
                            ),
                          );
                        }),
                        SizedBox(height: 10),
                        //   _buildPlanScroller(w),
                        Image.asset('assets/images/Frame 65.png'),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset('assets/images/Group 384.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Frequently Asked Questions',
                            style: opensansMedium.copyWith(fontSize: 18),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FaqTile(
                              title: "What is perfectmatch.com?",
                              description:
                                  "PerfectMatch is a premium matchmaking platform designed to help people find compatible partners.",
                            ),

                            FaqTile(
                              title: "How does it work?",
                              description:
                                  "You create a profile, set your preferences, and the system matches you based on compatibility scores.",
                            ),

                            FaqTile(
                              title: "Is the service free?",
                              description:
                                  "Basic features are free. Premium plans offer enhanced search, visibility, and chat features.",
                            ),

                            FaqTile(
                              title: "How do I contact support?",
                              description:
                                  "You can reach support via the Help section or email support@perfectmatch.com",
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
          Container(
            height: statusBarHeight,
            width: double.infinity,
            color: ColorResources.primarycolor2,
          ),
        ],
      ),
    );
  }

  final Map<String, List<Color>> planGradients = {
    "Basic": [Color(0xFFBE3272), Color(0xFFEB4E76)],
    "Gold": [Color(0xffEE8931), Color(0xffEEAC31)],
    "Premium": [Color(0xff96A737), Color(0xffA3B924)],
    "VIP": [Color(0xff2C3BE4), Color(0xff222FB8)],
  };

  final Map<String, List<Color>> buttonGradients = {
    "Basic": [Color(0xFFBE3272), Color(0xFFEB4E76)],
    "Gold": [Color(0xffEE8931), Color(0xffEEAC31)],
    "Premium": [Color(0xff96A737), Color(0xffA3B924)],
    "VIP": [Color(0xff2C3BE4), Color(0xff222FB8)],
  };
  final Map<String, String> planImages = {
    "Basic": "assets/images/Frame 80.png",
    "Gold": "assets/images/Frame 81.png",
    "Premium": "assets/images/Frame 82.png",
    "VIP": "assets/images/Frame 77.png",
  };
  final Map<String, String> planTitles = {
    "Basic": "Create profile and set Partner preferences",
    "Gold": "Full access of profile view",
    "Premium": "Full Access of profile view",
    "VIP": "Handpicked high-profile matches",
  };
  static const List<String> basicFeatures = [
    "Create profile and set Partner preferences",
    "Basic Search Access",
    "View limited number of profiles per day",
    "Chat only profile is interested",
    "Limited visibility in match suggestions",
  ];

  static const List<String> goldFeatures = [
    "Full access of profile view",
    "Voice and Video calling feature",
    "Send 50 messages",
    "View 100 contacts",
    "Profile highlight for 3 days",
  ];

  static const List<String> premiumFeatures = [
    "Full Access of profile view",
    "Voice and Video calling feature",
    "Unlimited messages",
    "View 300 contacts",
    "Profile highlight for 7 days",
    "Dedicated manager",
  ];

  static const List<String> vipFeatures = [
    "Handpicked high-profile matches",
    "Guaranteed introductions",
    "Confidential handling",
    "Dedicated manager",
    "Unlimited messages",
  ];

  static const Map<String, List<String>> planFeatures = {
    "Basic": basicFeatures,
    "Gold": goldFeatures,
    "Premium": premiumFeatures,
    "VIP": vipFeatures,
  };
  static const Map<String, Color> tickColors = {
    "Basic": Color(0xFFBE3272),
    "Gold": Color(0xffEE8931),
    "Premium": Color(0xff96A737),
    "VIP": Color(0xff2C3BE4),
  };

  String selectedPlan = "Basic";
  void selectPlan(String plan) {
    setState(() {
      selectedPlan = plan;
    });
  }

  final usercontroller = Get.put(UserDetailController());

  Widget _planCard(String name, int price, String planidd) {
    final u = usercontroller.userData.value!;

    final buttonColors =
        buttonGradients[name] ?? [Color(0xffBE3272), Color(0xffEB4E76)];

    final features = planFeatures[name] ?? const [];

    final tickColor = tickColors[name] ?? Colors.grey;
    print('Id::::::::planid:::${planidd}');
    return GestureDetector(
      onTap: () {
        selectPlan(name);
        print('Id::::::::planid:::${planidd}');
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 300,
            height: 430,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,

              // ⭐ SELECTED BORDER LOGIC
              border: Border.all(
                color: selectedPlan == name
                    ? ColorResources.primarycolor2
                    : Colors.transparent,
                width: selectedPlan == name ? 2 : 0,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              children: [
                // ⭐ FIXED HEADER
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: headerColors,
                    //   begin: Alignment.centerLeft,
                    //   end: Alignment.centerRight,
                    // ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: Image.asset(
                    planImages[name]!,
                    // height: 70,
                    fit: BoxFit.fill,
                  ),
                ),

                // ⭐ FEATURES
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...features.map(
                          (f) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: tickColor,
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    f,
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 13,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Center(
                          child: Text(
                            "₹ $price",
                            style: TextStyle(
                              fontSize: 34,
                              color: ColorResources.primarycolor2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ⭐ BUTTON SAME
          Positioned(
            bottom: -10,
            left: 0,
            right: 0,
            child: Center(
              child: name == "Basic"
                  ? GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          'Error',
                          'You Have already ${u.planDetail!.planId!.name} Plan',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      },

                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          name == "Basic" ? "BY DEFAULT" : "SELECT PLAN",
                          style: opensansBold.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        final currentPlanPrice = u.planDetail?.price ?? 0;
                        final newPlanPrice = price;

                        if (u.planDetail == null) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('Confirm Purchase'),
                                content: Text(
                                  'Are you sure you want to purchase this package for ₹$newPlanPrice?',
                                  style: opensansMedium.copyWith(),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('No'),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      MembershipPlanController controller =
                                          Get.find();
                                      controller.activatePlan(planidd);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          if (newPlanPrice > currentPlanPrice) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("Upgrade Plan"),
                                  content: Text(
                                    "You already have a plan. Do you want to upgrade to this higher plan for ₹$newPlanPrice?",
                                    style: opensansMedium.copyWith(),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      child: Text("Upgrade"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        MembershipPlanController controller =
                                            Get.find();
                                        controller.activatePlan(planidd);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (newPlanPrice < currentPlanPrice) {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("Already Premium"),
                                  content: Text(
                                    "You already have a higher premium plan.",
                                    style: opensansMedium.copyWith(),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text("OK"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text("Plan Already Active"),
                                  content: Text(
                                    "You already have this plan active.",
                                    style: opensansMedium.copyWith(),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text("OK"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },

                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: buttonColors),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: u.planDetail == null
                            ? Text(
                                'SELECT PLAN',
                                style: opensansBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              )
                            : Text(
                                u.planDetail!.planId!.id != planidd
                                    ? "SELECT PLAN"
                                    : "Active Plan",
                                style: opensansBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      color: const Color.fromARGB(255, 244, 229, 214),
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.hidenav == "Hide"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorResources.blackcolor11,
                        size: 24,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        color: ColorResources.blackcolor11,
                        size: 28,
                      ),
                    ),
                  ],
                ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 245, 242),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Membership Plans",
              style: opensansSemiBold.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // GestureDetector(
              //   onTap: () {
              //     Get.to(
              //       BasicSearchPage(),
              //       duration: Duration(
              //         milliseconds: ApiConstants.screenTransitionTime,
              //       ),
              //       transition: Transition.rightToLeft,
              //     );
              //   },
              //   child: Image.asset(
              //     'assets/images/search-alt_svgrepo.com.png',
              //     height: 25,
              //     color: ColorResources.blackcolor11,
              //   ),
              // ),
              // const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Get.to(
                    NotificationPage(),
                    duration: Duration(
                      milliseconds: ApiConstants.screenTransitionTime,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Image.asset('assets/images/bell.png', height: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FaqTile extends StatefulWidget {
  final String title;
  final String description;

  const FaqTile({super.key, required this.title, required this.description});

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isOpen = !isOpen;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: opensansMedium.copyWith(fontSize: 15),
                  ),

                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_right,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expand area
          if (isOpen)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.description,
                style: opensansMedium.copyWith(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),

          SizedBox(height: 12),
        ],
      ),
    );
  }
}
