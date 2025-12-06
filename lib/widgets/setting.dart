import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,

      // ----------------- BODY -----------------
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              children: [
                _buildTopBar(),

                // const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Notification Settings"),
                      settingsTile("Push Notifications"),

                      divider(),

                      sectionTitle("Privacy Settings"),
                      settingsTile(
                        "+91-9875892548",
                        subtitle: "Only Premium Members",
                      ),

                      divider(),

                      sectionTitle("Profile Information Settings"),
                      settingsTile("View Settings"),

                      divider(),

                      settingsTile("Hide / Delete Profile"),

                      divider(),

                      settingsTile("Logout", showArrow: false),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  // _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorResources.blackcolor11,
                  size: 20,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: opensansSemiBold.copyWith(fontSize: 16)),
    );
  }

  Widget settingsTile(String title, {String? subtitle, bool showArrow = true}) {
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
      onTap: () {},
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
