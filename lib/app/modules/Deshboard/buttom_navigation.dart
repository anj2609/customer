import 'dart:io';

import 'package:myrideuser/app/modules/Promos/promos_screen.dart';
import 'package:myrideuser/app/modules/acoount/acoount.dart';
import 'package:myrideuser/app/modules/activity/activity.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myrideuser/app/modules/Deshboard/deshboard.dart';

import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isCheckingActiveBooking = false;

  final controller = Get.find<ProfileController>();

  final List<Widget> _pages = [
    DashboardScreen(),
    PromoScreen(),
    ActivityScreen(),
    AccountSettingScreens(),
  ];

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
    controller.fetchProfile();
    WidgetsBinding.instance.addObserver(this);
    // Re-check on every entry: handles returning from a completed/cancelled ride.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkActiveBooking());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkActiveBooking();
    }
  }

  Future<void> _checkActiveBooking() async {
    if (_isCheckingActiveBooking) return;
    _isCheckingActiveBooking = true;

    try {
      final bookingCtrl = Get.find<BookingController>();
      await bookingCtrl.checkActiveBookingApi();

      if (!mounted) return;

      final active = bookingCtrl.activeBookingState.value;

      switch (active.status) {
        case BookingStatus.pending:
        case BookingStatus.accepted:
        case BookingStatus.arrived:
        case BookingStatus.ongoing:
          if (active.bookingId != null && active.bookingId!.isNotEmpty) {
            Get.offAllNamed(
              RouteHelper.getfindingDriverUI(),
              arguments: {'booking_id': active.bookingId},
            );
          }
          break;
        default:
          break; // No active booking — stay on home screen.
      }
    } finally {
      _isCheckingActiveBooking = false;
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
              color: ColorResources.primarycolor3,
            ),
          ],
        ),

        bottomNavigationBar: _buildCustomBottomBar(),
      ),
    );
  }

  Widget _buildCustomBottomBar() {
    final items = [
      _BottomItem(img: "assets/images/home.png", label: "Home"),
      _BottomItem(img: "assets/images/discountfill.png", label: "Promos"),
      _BottomItem(img: "assets/images/Activity.png", label: "Activity"),
      _BottomItem(img: "assets/images/account_circle.png", label: "Account"),
      //   _BottomItem(img: "assets/images/Frame 15.png", label: ""),
    ];

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
        decoration: BoxDecoration(
          color: ColorResources.backgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final bool selected = _currentIndex == index;

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
                            ? ColorResources.blueeebutton
                            : ColorResources.blkackvoor,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: opensansSemiBold.copyWith(
                          fontSize: 12,
                          color: selected
                              ? ColorResources.blueeebutton
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
