import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/connect/connectscreen.dart';
import 'package:vivashri/app/modules/match/matchscreen.dart';
import 'package:vivashri/app/modules/membership/membership.dart';
import 'package:vivashri/app/modules/myprofile/my_profile.dart';
import 'package:vivashri/app/modules/notification/notification.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/auth_controller.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/setting.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserDetailController());

    final u = controller.userData.value!;
    final w = MediaQuery.of(context).size.width;
    return Drawer(
      backgroundColor: Colors.white,
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
                children: [
                  Container(
                    width: w * 0.20,
                    height: w * 0.25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${ApiConstants.imageurl}${u.photo}',
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          String gender = u.gender.toString();

                          if (gender == "Male") {
                            return Image.asset(
                              "assets/images/9159790.png",
                              fit: BoxFit.contain,
                            );
                          } else if (gender == "Female") {
                            return Image.asset(
                              "assets/images/3232.png",
                              fit: BoxFit.contain,
                            );
                          } else {
                            return Image.asset(
                              "assets/images/profilee.png",
                              fit: BoxFit.contain,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(12),
                  //   child: Image.asset(
                  //     "assets/images/Ellipse2222.png",
                  //     height: 100,
                  //     width: 70,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  const SizedBox(width: 10),

                  // Name & Plan
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${u.name}",
                        style: opensansSemiBold.copyWith(fontSize: 16),
                      ),

                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: u.profileId ?? ""),
                          );
                        },
                        child: Text(
                          "${u.profileId}",
                          style: opensansSemiBold.copyWith(
                            color: ColorResources.blackgrey,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            MembershipPlansPage(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorResources.primarycolor3,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Upgrade Plan",
                                style: opensansSemiBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Image.asset(
                                    "assets/images/Crown.png",
                                    height: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // Divider(color: Colors.grey.shade300),

            // ---------- MENU ITEMS ----------
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(
                    image: "assets/images/Vector.png",
                    title: "My Vivashri",
                    onTap: () {
                      Get.back();
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/user-alt-1_svgrepo.com.png",
                    title: "My Profile",
                    onTap: () {
                      Get.to(
                        MyProfielScreen(),
                        duration: Duration(
                          milliseconds: ApiConstants.screenTransitionTime,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/couple_svgrepo.com.png",
                    title: "Matches",
                    onTap: () {
                      Get.to(
                        MatchesScreen(),
                        duration: Duration(
                          milliseconds: ApiConstants.screenTransitionTime,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/user-search-alt-1_svgrepo.com.png",
                    title: "Search",
                  ),

                  _drawerItem(
                    image: "assets/images/envelope_svgrepo.com 2.png",
                    title: "Connect",
                    onTap: () {
                      Get.to(
                        ConnectScreen(),
                        duration: Duration(
                          milliseconds: ApiConstants.screenTransitionTime,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/search-file_svgrepo.com.png",
                    title: "Partner Preferences",
                  ),
                  _drawerItem(
                    image: "assets/images/crown_svgrepo.com.png",
                    title: "Membership Plans",
                  ),
                  _drawerItem(
                    image: "assets/images/bell_svgrepo.com.png",
                    title: "Notifications",
                    onTap: () {
                      Get.to(
                        NotificationPage(),
                        duration: Duration(
                          milliseconds: ApiConstants.screenTransitionTime,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  _drawerItem(
                    image: "assets/images/faq-file_svgrepo.com.png",
                    title: "FAQ/Help",
                  ),
                  _drawerItem(
                    image: "assets/images/setting_svgrepo.com.png",
                    title: "Settings",
                    onTap: () {
                      Get.to(
                        SettingsScreen(),
                        duration: Duration(
                          milliseconds: ApiConstants.screenTransitionTime,
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),

                  // LOGOUT
                  _drawerItem(
                    image: "assets/images/logout_svgrepo.com.png",
                    title: "Logout",
                    isLogout: true,
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
                                  await prefs.setString('userID', '');
                                  await prefs.setString('userName', '');

                                  Restart.restartApp();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
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
    bool isLogout = false,
    bool showDivider = true,
    VoidCallback? onTap,
  }) {
    bool showArrow =
        (title == "Search" || title == "Matches" || title == "Connect");

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Image.asset(
                  image,
                  height: 22,
                  width: 22,
                  color: isLogout
                      ? ColorResources.primarycolor3
                      : ColorResources.primarycolor3,
                ),
                const SizedBox(width: 18),

                // TEXT
                Expanded(
                  child: Text(
                    title,
                    style: opensansSemiBold.copyWith(
                      fontSize: 15,
                      color: ColorResources.blackhalka,
                    ),
                  ),
                ),

                // if (showArrow)
                //   Icon(
                //     Icons.arrow_forward_ios,
                //     size: 16,
                //     color: ColorResources.primarycolor3,
                //   ),
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

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dotWidth = 4; // dot size
    const space = 4; // space size
    final paint = Paint()
      ..color = const Color(0xffb98b9c)
      ..strokeWidth = 1;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dotWidth, 0), paint);
      startX += dotWidth + space;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
