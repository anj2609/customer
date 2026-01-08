import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/employee/deshboard/buttom_desh.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                    image: "assets/images/Vector.png",
                    title: "Dashboard",
                    onTap: () {
                      Get.offAll(
                        EmployeButtomScreen(initialIndex: 0),
                        duration: const Duration(milliseconds: 0),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/user-alt-1_svgrepo.com.png",
                    title: "My Leads",
                    onTap: () {
                      Get.offAll(
                        EmployeButtomScreen(initialIndex: 1),
                        duration: const Duration(milliseconds: 0),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/couple_svgrepo.com.png",
                    title: "Add Lead",
                    onTap: () {
                      Get.offAll(
                        EmployeButtomScreen(initialIndex: 1),
                        duration: const Duration(milliseconds: 0),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/user-search-alt-1_svgrepo.com.png",
                    title: "View Member",
                    onTap: () {
                      Get.offAll(
                        EmployeButtomScreen(initialIndex: 3),
                        duration: const Duration(milliseconds: 0),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/envelope_svgrepo.com 2.png",
                    title: "My Commission",
                    showDivider: false,
                    onTap: () {
                      Get.offAll(
                        () => const EmployeButtomScreen(initialIndex: 2),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 0),
                      );
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDECEF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Logout",
                        style: opensansSemiBold.copyWith(
                          fontSize: 15,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "© 2025 Vivashri.com. All rights reserved.",
                    style: opensansRegular.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                Image.asset(
                  image,
                  height: 22,
                  width: 22,
                  color: ColorResources.primarycolor3,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    style: opensansSemiBold.copyWith(
                      fontSize: 15,
                      color: ColorResources.blackhalka,
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
