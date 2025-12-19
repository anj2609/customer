import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/settingcontroller.dart';

class PushNotificationScreen extends StatefulWidget {
  const PushNotificationScreen({super.key});

  @override
  State<PushNotificationScreen> createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  bool newInvitations = true;
  bool newAccepts = true;
  bool newMatches = true;
  bool newOffers = true;
  NotificationController nc = Get.find();
  @override
  void initState() {
    super.initState();
    nc.fetchNotificationSettings().then((_) {
      getdata();
      setState(() {});
    });
  }

  void getdata() {
    newInvitations = nc.settings.value.newInvitation == 1 ? true : false;
    newAccepts = nc.settings.value.newAccepts == 1 ? true : false;
    newMatches = nc.settings.value.newMatches == 1 ? true : false;
    newOffers = nc.settings.value.newOffers == 1 ? true : false;
  }

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

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<NotificationController>(
                        builder: (_) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionTitle("Notification Settings"),

                              _settingTile(
                                label: "New Invitations",
                                value: newInvitations,
                                onChanged: (v) =>
                                    setState(() => newInvitations = v),
                              ),
                              _divider(),

                              _settingTile(
                                label: "New Accepts",
                                value: newAccepts,
                                onChanged: (v) =>
                                    setState(() => newAccepts = v),
                              ),
                              _divider(),

                              _settingTile(
                                label: "New Matches",
                                value: newMatches,
                                onChanged: (v) =>
                                    setState(() => newMatches = v),
                              ),
                              _divider(),

                              _settingTile(
                                label: "New Offers",
                                value: newOffers,
                                onChanged: (v) => setState(() => newOffers = v),
                              ),
                              _divider(),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 200),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            nc.saveNotificationSettings(
                              newInvitation: newInvitations == true ? 1 : 0,
                              newAccepts: newAccepts == true ? 1 : 0,
                              newMatches: newMatches == true ? 1 : 0,
                              newOffers: newOffers == true ? 1 : 0,
                            );
                            Future.delayed(
                              const Duration(microseconds: 1000),
                              () {
                                Get.back();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.primarycolor2,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "SUBMIT",
                            style: opensansSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
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

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Text(text, style: opensansSemiBold.copyWith(fontSize: 16)),
    );
  }

  Widget _settingTile({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SizedBox(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: opensansSemiBold.copyWith(fontSize: 14)),
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: ColorResources.primarycolor2,
              activeTrackColor: Colors.pink.shade100,
              inactiveThumbColor: Colors.grey.shade400,
              inactiveTrackColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.only(bottom: 5),
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
              "Push Notifications",
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
}
