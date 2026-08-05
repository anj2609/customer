import 'dart:io';

import 'package:myrideuser/app/modules/Deshboard/services_screen.dart';
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
  final bookingController = Get.find<BookingController>();
  Worker? _bottomNavIndexWorker;

  final List<Widget> _pages = [
    DashboardScreen(),
    const ServicesScreen(),
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
    bookingController.bottomNavIndex.value = _currentIndex;

    // Lets other screens (e.g. Services, tapping a vehicle) switch the tab
    // from outside this widget without a bigger navigation refactor.
    // Cancelled in dispose() so remounting MainNavigation (e.g. re-login)
    // doesn't pile up dead listeners on the persistent controller.
    _bottomNavIndexWorker = ever<int>(bookingController.bottomNavIndex, (
      value,
    ) {
      if (mounted && value != _currentIndex) {
        setState(() => _currentIndex = value);
      }
    });

    controller.fetchProfile();
    WidgetsBinding.instance.addObserver(this);
    // Re-check on every entry: handles returning from a completed/cancelled ride.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkActiveBooking());
  }

  @override
  void dispose() {
    _bottomNavIndexWorker?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkActiveBooking();
    }
  }

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
    bookingController.bottomNavIndex.value = index;
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
          _selectTab(0);
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
        extendBody: true,
        backgroundColor: ColorResources.whiteColor,
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
      _BottomItem(icon: Icons.directions_car_filled_rounded, label: "Services"),
      _BottomItem(img: "assets/images/Activity.png", label: "Activity"),
      _BottomItem(img: "assets/images/account_circle.png", label: "Account"),
    ];

    // Compact floating glossy pill — sized to its own content (not
    // stretched full-width) and centered, so it reads as a capsule rather
    // than a wide rectangle. Nothing is painted behind it beyond the
    // Scaffold's own whiteColor background (set in build() above), which
    // matches the bottom sheet's white — a light grey border on the pill
    // itself provides the separation instead. SafeArea(top: false) plus its
    // own bottom padding just keep it clear of the Android gesture bar /
    // nav buttons.
    //
    // The SizedBox(height: 60) is critical: without a bounded height here,
    // Center expands to fill whatever space Scaffold offers the
    // bottomNavigationBar slot, which both floats the pill mid-screen AND
    // starves body of height (this was exactly the "blank Activity/Account
    // screens" bug — the whole slot, not just the pill, was oversized).
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          height: 60,
          child: Center(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                // Solid white — matches the bottom sheet exactly. The gloss
                // now comes only from the highlight streak below, not from
                // shifting the base colour (that read as a mismatch against
                // the sheet's flat white).
                color: ColorResources.whiteColor,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: ColorResources.greycolorborder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glossy highlight: a bright reflection streak near the top
                    // edge, like light catching curved glass/plastic.
                    Positioned(
                      top: 4,
                      left: 12,
                      right: 12,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        final bool selected = _currentIndex == index;

                        return InkWell(
                          onTap: () => _selectTab(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 260),
                                  curve: Curves.easeInOutCubic,
                                  width: selected ? 34 : 26,
                                  height: selected ? 34 : 26,
                                  decoration: BoxDecoration(
                                    gradient: selected
                                        ? LinearGradient(
                                            colors:
                                                ColorResources.brandGradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: TweenAnimationBuilder<Color?>(
                                    tween: ColorTween(
                                      begin: ColorResources.TextColorForGrey,
                                      end: selected
                                          ? ColorResources.whiteColor
                                          : ColorResources.TextColorForGrey,
                                    ),
                                    duration: const Duration(milliseconds: 260),
                                    curve: Curves.easeInOutCubic,
                                    builder: (context, color, child) {
                                      return item.icon != null
                                          ? Icon(
                                              item.icon,
                                              size: 19,
                                              color: color,
                                            )
                                          : Image.asset(
                                              item.img!,
                                              height: 19,
                                              width: 19,
                                              color: color,
                                            );
                                    },
                                  ),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 260),
                                  curve: Curves.easeInOutCubic,
                                  child: selected
                                      ? const SizedBox(height: 0)
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2,
                                          ),
                                          child: Text(
                                            item.label,
                                            style: opensansSemiBold.copyWith(
                                              fontSize: 9.5,
                                              color: ColorResources
                                                  .TextColorForGrey,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomItem {
  final String? img;
  final IconData? icon;
  final String label;

  _BottomItem({this.img, this.icon, required this.label})
    : assert(img != null || icon != null, 'Provide either img or icon');
}
