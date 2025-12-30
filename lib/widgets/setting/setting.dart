import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/auth_controller.dart';
import 'package:vivashri/data/controller/recived_interst.dart';
import 'package:vivashri/data/controller/settingcontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/setting/dob_request.dart';
import 'package:vivashri/widgets/setting/hide_delete.dart';
import 'package:vivashri/widgets/setting/phone_setitng.dart';
import 'package:vivashri/widgets/setting/photo_request_screen.dart';
import 'package:vivashri/widgets/setting/profile_info_setting.dart';
import 'package:vivashri/widgets/setting/push_notification.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  NotificationController nc = Get.find();
  final usercontroller = Get.put(UserDetailController());
  final inboxCtrl = Get.put(InboxReceivedController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final u = usercontroller.userData.value!;

    return Scaffold(
      backgroundColor: Colors.white,

      // ----------------- BODY -----------------
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              children: [
                _buildTopBar(),

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Notification Settings"),
                      settingsTile(
                        "Push Notifications",
                        onTap: () {
                          nc.fetchNotificationSettings();
                          Get.to(
                            PushNotificationScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),

                      divider(),

                      sectionTitle("Privacy Settings"),
                      settingsTile(
                        "+91-${u.mobile}",
                        subtitle: "Only Premium Members",
                        onTap: () {
                          Get.to(
                            PhoneSettingScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),

                      divider(),

                      sectionTitle("Profile Information Settings"),
                      settingsTile(
                        "View Settings",
                        onTap: () {
                          Get.to(
                            ProfileinfoSetting(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),

                      divider(),

                      settingsTile(
                        "Hide / Delete Profile",
                        onTap: () {
                          Get.to(
                            HideDeelteProfile(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),

                      divider(),
                      settingsTile(
                        "Photo Request",
                        onTap: () {
                          inboxCtrl.photorecived();

                          Get.to(
                            PhotoRequestScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),

                      divider(),
                      settingsTile(
                        "DOB Request",
                        onTap: () {
                          inboxCtrl.dobrequest();
                          Get.to(
                            DobRequestScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),

                      divider(),

                      settingsTile(
                        "Logout",
                        showArrow: false,
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
          Container(
            height: statusBarHeight,
            width: double.infinity,
            color: ColorResources.primarycolor2,
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      color: const Color.fromARGB(255, 244, 229, 214),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorResources.blackcolor11,
                  size: 23,
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
              "Settings",
              style: opensansSemiBold.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------- HELPERS -----------------
  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Text(text, style: opensansSemiBold.copyWith(fontSize: 16)),
    );
  }

  Widget settingsTile(
    String title, {
    String? subtitle,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: opensansMedium.copyWith(fontSize: 14)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: opensansMedium.copyWith(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            )
          : null,
      trailing: showArrow
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
      onTap: onTap,
    );
  }

  Widget divider() {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
