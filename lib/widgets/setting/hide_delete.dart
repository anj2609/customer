import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/profile_delete.dart';
import 'package:vivashri/data/controller/settingcontroller.dart';

class HideDeelteProfile extends StatefulWidget {
  const HideDeelteProfile({super.key});

  @override
  State<HideDeelteProfile> createState() => _HideDeelteProfileState();
}

class _HideDeelteProfileState extends State<HideDeelteProfile> {
  NotificationController nc = Get.find();
  final controller = Get.put(ProfileHideController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.fetchProfileHide().then((_) {
      setState(() {
        controller.showStatus.value =
            controller.data.value.profileShow!; // 1 or 2
      });
    });
  }

  int? valueeee;
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              children: [
                _buildTopBar(),

                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hide Profile",
                              style: opensansSemiBold.copyWith(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.showStatus.value =
                                    controller.showStatus.value == 1 ? 2 : 1;
                              },
                              child: Text(
                                controller.showStatus.value == 1
                                    ? "Hide"
                                    : "Visible",
                                style: opensansSemiBold.copyWith(
                                  color: ColorResources.primarycolor2,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Your profile is currently visible",
                          style: opensansSemiBold.copyWith(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/info_svgrepo.com 2.png',
                              height: 16,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "When you hide your profile, you will not be visible on Vivashri.com, you will neither be able to contact anyone.",
                                style: opensansMedium.copyWith(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Divider(color: Colors.grey.shade300, thickness: 1),

                        const SizedBox(height: 20),

                        // ------------------ DELETE PROFILE ------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delete Profile",
                              style: opensansSemiBold.copyWith(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: Text("Are you sure?"),
                                      content: Text(
                                        "Delete your Profile from Vivashri.com",
                                      ),
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
                                              color:
                                                  ColorResources.primarycolor3,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Delete",
                                style: opensansSemiBold.copyWith(
                                  color: ColorResources.primarycolor2,

                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Delete your Profile from Vivashri.com",
                          style: opensansSemiBold.copyWith(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/info_svgrepo.com 2.png',
                              height: 16,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "You will permanently lose all profile information, match interactions and paid membership.",
                                style: opensansMedium.copyWith(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 200),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              nc.hidedeelteprofile(
                                profileshow: controller.showStatus.value,
                                // profiledelete: 0,
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
                              "Update",
                              style: opensansSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "Profile Show: ${controller.data.value.profileShow}",
                  //         style: TextStyle(fontSize: 17),
                  //       ),
                  //       SizedBox(height: 10),

                  //       Text(
                  //         "Profile Delete: ${controller.data.value.profileDelete}",
                  //         style: TextStyle(fontSize: 17),
                  //       ),
                  //     ],
                  //   ),
                  // );
                }),
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
                  // _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorResources.blackcolor11,
                  size: 22,
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
              "Hide / Delete Profile",
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
