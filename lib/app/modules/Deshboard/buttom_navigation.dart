import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/Deshboard/deshboard.dart';
import 'package:vivashri/app/modules/chat/chatscreen.dart';
import 'package:vivashri/app/modules/connect/connectscreen.dart';
import 'package:vivashri/app/modules/match/matchscreen.dart';
import 'package:vivashri/app/modules/membership/membership.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/match_list.dart';
import 'package:vivashri/data/controller/matchdeshboard.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final usercontroller = Get.put(UserDetailController());

  final List<Widget> _pages = [
    DashboardScreen(),
    MatchesScreen(),
    ConnectScreen(),
    ChatScreen(),
    MembershipPlansPage(),
  ];
  final matchC = Get.put(MatchController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileapi();
  }

  final searchC = Get.put(SearchmatchController());

  void profileapi() async {
    final prefs = await SharedPreferences.getInstance();

    String? profileid = prefs.getString("profileid");
    usercontroller.fetchUserDetail(profileid.toString());
    matchC.fetchMatches();
    searchC.fetchSearchList();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }

        bool shouldExit =
            await showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("Do you want to exit the app?"),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text(
                        "Cancel",
                        style: opensansSemiBold.copyWith(
                          color: Colors.blueGrey,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        "Yes",
                        style: opensansSemiBold.copyWith(
                          color: ColorResources.primarycolor3,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            ) ??
            false;

        if (shouldExit) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
          return false;
        }

        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            _pages[_currentIndex],
            Container(
              height: statusBarHeight,
              width: double.infinity,
              color: ColorResources.primarycolor2,
            ),
          ],
        ),

        bottomNavigationBar: _buildCustomBottomBar(),
      ),
    );
  }

  Widget _buildCustomBottomBar() {
    final items = [
      _BottomItem(img: "assets/images/Vector.png", label: "Home"),
      _BottomItem(
        img: "assets/images/Engagement Rings - iconSvg.co.png",
        label: "Matches",
      ),
      _BottomItem(
        img: "assets/images/envelope_svgrepo.com.png",
        label: "Connect",
      ),
      _BottomItem(img: "assets/images/Vector (1).png", label: "Chat"),
      _BottomItem(
        img: "assets/images/Frame 15.png",
        label: "",
      ), // Premium Zone image only
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final bool selected = _currentIndex == index;

            if (index == 4) {
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: Container(
                  child: Image.asset(
                    item.img,
                    height: 70,
                    width: 75,
                    fit: BoxFit.contain,
                    color: ColorResources.primarycolor3,
                  ),
                ),
              );
            }

            // ---------------- OTHER BOTTOM ITEMS ----------------
            return Expanded(
              child: InkWell(
                onTap: () => setState(() => _currentIndex = index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        item.img,
                        height: 24,
                        width: 24,
                        color: selected
                            ? ColorResources.primarycolor3
                            : ColorResources.blkackvoor,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: opensansSemiBold.copyWith(
                          fontSize: 12,
                          color: selected
                              ? ColorResources.primarycolor3
                              : ColorResources.blkackvoor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BottomItem {
  final String img;
  final String label;

  _BottomItem({required this.img, required this.label});
}
