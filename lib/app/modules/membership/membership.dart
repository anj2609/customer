import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/notification/notification.dart';
import 'package:vivashri/app/modules/search/search.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/widgets/drawer.dart';

class MembershipPlansPage extends StatefulWidget {
  const MembershipPlansPage({super.key});

  @override
  _MembershipPlansPageState createState() => _MembershipPlansPageState();
}

class _MembershipPlansPageState extends State<MembershipPlansPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

                        _buildPlanScroller(w),
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

  Widget _buildTopBar(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color.fromARGB(255, 244, 229, 214),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
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
              style: opensansMedium.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    BasicSearchPage(),
                    duration: Duration(
                      milliseconds: ApiConstants.screenTransitionTime,
                    ),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Image.asset(
                  'assets/images/search-alt_svgrepo.com.png',
                  height: 25,
                  color: ColorResources.blackcolor11,
                ),
              ),
              const SizedBox(width: 16),
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

  Widget _buildPlanScroller(double w) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 400,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Image.asset('assets/images/Group 301.png'),
            Image.asset('assets/images/plan.png'),
            SizedBox(width: 12),
            Image.asset('assets/images/Frame 58.png'),
            SizedBox(width: 12),
            Image.asset('assets/images/Frame 59.png'),
          ],
        ),
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
