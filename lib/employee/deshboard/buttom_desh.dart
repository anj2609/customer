import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/check_percentage.dart';
import 'package:vivashri/data/controller/matchdeshboard.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/employee/deshboard/employ_desh.dart';
import 'package:vivashri/employee/leads/leads.dart';
import 'package:vivashri/employee/members/member.dart';
import 'package:vivashri/employee/transaction/transction.dart';

class EmployeButtomScreen extends StatefulWidget {
  final int initialIndex;

  const EmployeButtomScreen({super.key, this.initialIndex = 0});

  @override
  State<EmployeButtomScreen> createState() => _EmployeButtomScreenState();
}

class _EmployeButtomScreenState extends State<EmployeButtomScreen> {
  int _currentIndex = 0;
  final usercontroller = Get.put(UserDetailController());

  final List<Widget> _pages = [
    EmployeeDeshboardScreen(),
    MyLeadsScreen(),
    TransactionsScreen(),
    MembersListScreen(),
  ];
  final matchC = Get.put(MatchController());
  final checkcontroller = Get.put(CheckProfileController());

  @override
  void initState() {
    super.initState();

    if (Get.arguments is int &&
        Get.arguments >= 0 &&
        Get.arguments < _pages.length) {
      _currentIndex = Get.arguments;
    } else {
      _currentIndex = widget.initialIndex;
    }
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
      _BottomItem(img: "assets/images/Vector 3.png", label: "My Leads"),
      _BottomItem(
        img: "assets/images/money_svgrepo.com.png",
        label: "Transactions",
      ),
      _BottomItem(
        img: "assets/images/team_svgrepo.com 2.png",
        label: "Members",
      ),
      //   _BottomItem(img: "assets/images/Frame 15.png", label: ""),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final bool selected = _currentIndex == index;

            return Expanded(
              child: InkWell(
                onTap: () => {setState(() => _currentIndex = index)},
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
