import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool biometric = true;
  bool faceId = true;
  bool smsAuth = false;
  bool googleAuth = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = width * 0.05;

    return Scaffold(
      backgroundColor: ColorResources.appgroundcolor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: padding),

              /// Header
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: Dimensions.spacingSize20,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        " & Security",
                        style: PoppinsExtrabold.copyWith(
                          color: ColorResources.blackcolor,
                          fontSize: Dimensions.spacingSize16
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.spacingSize20),
                ],
              ),

              SizedBox(height: padding),

              /// Card Container
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: ColorResources.whiteColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.spacingSize20,
                    ),
                  ),
                  child: ListView(
                    children: [
                      /// Switch Tiles
                      buildSwitchTile("Biometric ID", biometric, (val) {
                        setState(() => biometric = val);
                      }),

                      buildSwitchTile("Face ID", faceId, (val) {
                        setState(() => faceId = val);
                      }),

                      buildSwitchTile("SMS Authenticator", smsAuth, (val) {
                        setState(() => smsAuth = val);
                      }),

                      buildSwitchTile("Google Authenticator", googleAuth, (
                        val,
                      ) {
                        setState(() => googleAuth = val);
                      }),

                      SizedBox(height: Dimensions.spacingSize10),

                      /// Simple Navigation Tiles
                      buildNavTile("Change Password"),

                      buildNavTile(
                        "Device Management",
                        subtitle:
                            "Manage your  on the various device you own.",
                      ),

                      buildNavTile(
                        "Deactivate ",
                        subtitle:
                            "Temporarily deactivate your . Easily reactivate when you're ready.",
                      ),

                      buildNavTile(
                        "Delete ",
                        subtitle:
                            "permanently remove your  and data. Proceed with caution.",
                        isDanger: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: PoppinsSemiBold.copyWith(color: ColorResources.blackcolor),
            ),
          ),
          Switch(
            value: value,
            // activeColor: Colors.white,
            // activeTrackColor: Colors.teal,
            thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return Colors.white;
            }),

            trackColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return ColorResources.blueeebutton;
              }
              return ColorResources.greycolorborder;
            }),

            trackOutlineColor: MaterialStateProperty.resolveWith<Color>((
              states,
            ) {
              if (states.contains(MaterialState.selected)) {
                return ColorResources.blueeebutton;
              }
              return ColorResources.greycolorborder;
            }),

            trackOutlineWidth: MaterialStateProperty.all(1.5),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget buildNavTile(String title, {String? subtitle, bool isDanger = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.spacingSize10),
      child: Row(
        crossAxisAlignment: subtitle != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PoppinsSemiBold.copyWith(
                    color: isDanger
                        ? ColorResources.textColorRed
                        : ColorResources.blackcolor,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: PoppinsReguler.copyWith(
                      color: ColorResources.TextColorForGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: Dimensions.spacingSize18),
        ],
      ),
    );
  }
}
