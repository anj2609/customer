import 'package:evfual/data/controller/auth_controller.dart';
import 'package:evfual/data/controller/swap_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/app/modules/swap_history.dart';
import 'package:evfual/app/modules/swap_station.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/constants.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final SwapController swaipcontroller = Get.put(SwapController());

    return Drawer(
      backgroundColor: ColorResources.blkackvoor,
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- TOP CLOSE BUTTON ----------
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 28),
                ),
              ),
            ),

            // ---------- PROFILE HEADER ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [Image.asset('assets/images/logo.png', height: 120)],
              ),
            ),

            const SizedBox(height: 20),

            // ---------- MENU ITEMS ----------
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                    image: "assets/images/Vector.png",
                    title: "Home",
                    onTap: () {
                      Get.offAll(
                        MainNavigation(),
                        duration: Duration(
                          milliseconds: ApiConstants.screenTransitionTime,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),

                  _drawerItem(
                    image: "assets/images/money_svgrepo.com.png",
                    title: "Subscription Plan",
                    onTap: () {
                      Get.offAll(
                        MainNavigation(initialIndex: 2),
                        duration: const Duration(milliseconds: 0),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),

                  _drawerItem(
                    image: "assets/images/money_svgrepo.com.png",
                    title: "Swap Station",
                    onTap: () {
                      swaipcontroller.getSwapHistory();
                      Get.to(
                        () => SwapStattions(),
                        duration: const Duration(milliseconds: 0),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),

                  _drawerItem(
                    image: "assets/images/money_svgrepo.com.png",
                    title: "My Plan",
                    onTap: () {
                      Get.offAll(
                        () => const MainNavigation(initialIndex: 1),
                        duration: const Duration(milliseconds: 0),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),

                  _drawerItem(
                    image: "assets/images/money_svgrepo.com.png",
                    title: "Swap History",
                    onTap: () {
                      Get.to(
                        SwapHistory(),
                        duration: const Duration(milliseconds: 0),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: GestureDetector(
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text("Are you sure?"),
                        content: Text(
                          "Do you really want to Logout Your Account",
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text("Yes"),
                            onPressed: () async {
                              Get.find<AuthController>().logOut();
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: ColorResources.blueeebutton),
                      const SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: opensansSemiBold.copyWith(
                          fontSize: 16,
                          color: ColorResources.blueeebutton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- SINGLE DRAWER ITEM ----------
  Widget _drawerItem({
    required String image,
    required String title,
    bool showDivider = true,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Image.asset(image, height: 22, width: 22, color: Colors.white),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    style: opensansSemiBold.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
      ],
    );
  }
}
