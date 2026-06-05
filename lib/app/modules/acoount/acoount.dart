import 'package:myrideuser/app/modules/acoount/help_support.dart';
import 'package:myrideuser/app/modules/acoount/linkedaccount_screen.dart';
import 'package:myrideuser/app/modules/acoount/notification_screen.dart';
import 'package:myrideuser/app/modules/acoount/topup_screen.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingModel {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SettingModel({required this.icon, required this.title, required this.onTap});
}

////////////////////////////////////////////////////////////
/// MAIN SCREEN
////////////////////////////////////////////////////////////

class AccountSettingScreens extends StatefulWidget {
  const AccountSettingScreens({super.key});

  @override
  State<AccountSettingScreens> createState() => _AccountSettingScreensState();
}

class _AccountSettingScreensState extends State<AccountSettingScreens> {
  final profilecontroller = Get.find<ProfileController>();
 @override
  void initState() {
    super.initState();
    Get.find<ProfileController>().customerWalletAmount();
    
  }  
 
  
  @override
  Widget build(BuildContext context) {
    /// 🔥 DYNAMIC SETTINGS LIST
    final List<SettingModel> settings = [
      SettingModel(
        icon: Icons.location_on_outlined,
        title: "Saved Addresses",
        onTap: () => _open(context, "Saved Addresses"),
      ),
      SettingModel(
        icon: Icons.notifications_none,
        title: "Notifications",
        onTap: () => _open(context, "Notifications"),
      ),
      // SettingModel(
      //   icon: Icons.credit_card,
      //   title: "Payment n Methods",
      //   onTap: () => _open(context, "Payment Methods"),
      // ),
      // SettingModel(
      //   icon: Icons.shield_outlined,
      //   title: "Account & Security",
      //   onTap: () => _open(context, "Account & Security"),
      // ),
      SettingModel(
        icon: Icons.sync_alt,
        title: "Linked Accounts",
        onTap: () => _open(context, "Linked Accounts"),
      ),
      // SettingModel(
      //   icon: Icons.remove_red_eye_outlined,
      //   title: "App Appearance",
      //   onTap: () => _open(context, "App Appearance"),
      // ),
      // SettingModel(
      //   icon: Icons.bar_chart,
      //   title: "Data & Analytics",
      //   onTap: () => _open(context, "Data & Analytics"),
      // ),
      // SettingModel(
      //   icon: Icons.help_outline,
      //   title: "Help & Support",
      //   onTap: () => _open(context, "Help & Support"),
      // ),
      // SettingModel(
      //   icon: Icons.star_border,
      //   title: "Rate us",
      //   onTap: () {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text("Open Play Store Rating")),
      //     );
      //   },
      // ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              ////////////////////////////////////////////////////////////
              /// 🔹 TOP BAR
              ////////////////////////////////////////////////////////////
              Row(
                children: [
                  CircleAvatar(
                    radius: Dimensions.spacingSize25,
                    backgroundColor: ColorResources.blueeebutton,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/splashscreen.png'),
                      ),
                    ),
                  ),

                  //  // Spacer(),
                  SizedBox(width: Dimensions.spacingSize60),
                  Text(
                    "Account",
                    style: PoppinsExtrabold.copyWith(
                      color: ColorResources.blackcolor11,
                      fontSize: Dimensions.spacingSize16,
                    ),
                  ),
                  // Spacer(),
                  // Icon(Icons.more_vert),
                ],
              ),

              SizedBox(height: Dimensions.smallSize),

              ////////////////////////////////////////////////////////////
              /// 🔹 PROFILE + WALLET CARD
              ////////////////////////////////////////////////////////////
              Container(
                padding: EdgeInsets.all(Dimensions.smallSize),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.spacingSize14),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.geteditProfileScreen());
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: Dimensions.spacingSize25,
                            backgroundColor: Colors.grey.shade200,
                            child: ClipOval(
                              child:
                                  profilecontroller.profileImage.value != null
                                  ? Image.file(
                                      profilecontroller.profileImage.value!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : (profilecontroller.profileimagee != null &&
                                        profilecontroller
                                            .profileimagee!
                                            .isNotEmpty)
                                  ? Image.network(
                                      '${ApiConstants.imageurl}${profilecontroller.profileimagee}',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/images/profile.png",
                                              fit: BoxFit.cover,
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      "assets/images/profile.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(width: Dimensions.spacingSize12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${profilecontroller.nameController.text}",
                                  style: PoppinsBold.copyWith(
                                    color: ColorResources.blackcolor11,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "+91 ${profilecontroller.phoneController.text}",
                                  style: PoppinsReguler.copyWith(
                                    color: ColorResources.TextColorForGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(RouteHelper.geteditProfileScreen());
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: Dimensions.spacingSize16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.spacingSize10),
                    Divider(color: ColorResources.TextColorForGrey),
                    SizedBox(height: Dimensions.spacingSize10),

                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(Dimensions.spacingSize10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorResources.blueeebutton,
                            ),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: ColorResources.blueeebutton,
                          ),
                        ),
                        SizedBox(width: Dimensions.spacingSize12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹ ${profilecontroller.walletbalance ?? 0}',
                                // profilecontroller.walletbalance!.isNotEmpty
                                //     ? "₹ ${profilecontroller.walletbalance}"
                                //     : "₹ 0",

                                ///  profilecontroller.
                                // "₹ 3582.67",
                                style: PoppinsMedium.copyWith(
                                  color: ColorResources.blackcolor11,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Available balance",
                                style: PoppinsReguler.copyWith(
                                  color: ColorResources.blackcolor11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              Get.to(TopupScreen()),
                              transition: Transition.rightToLeft,
                              duration: Duration(milliseconds: 0),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.spacingSize18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.spacingSize25,
                              ),
                              border: Border.all(
                                color: ColorResources.TextColorForGrey,
                              ),
                            ),
                            child: const Text("Top Up"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.spacingSize14),

              ////////////////////////////////////////////////////////////
              /// 🔹 SETTINGS LIST (DYNAMIC)
              ////////////////////////////////////////////////////////////
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.spacingSize14),
                ),
                child: Column(
                  children: [
                    ...settings.map((e) => SettingTile(model: e)).toList(),
                    const LogoutTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// NAVIGATION HELPER
  ////////////////////////////////////////////////////////////

  void _open(BuildContext context, String title) {
    if (title == "Saved Addresses") {
      Get.toNamed(RouteHelper.getsavedAddressScreen());
      // Get.to(
      //   () => SavedAddressScreen(),
      //   transition: Transition.leftToRight,
      //   binding: AddressBinding(),
      //   duration: const Duration(milliseconds: 300),
      // );
    } else if (title == "Notifications") {
      Get.to(
        () => NotificationsScreen(),
        transition: Transition.leftToRight,

        duration: const Duration(milliseconds: 00),
      );
    } else if (title == "Payment Methods") {
      Get.to(
        () => NotificationsScreen(),
        transition: Transition.leftToRight,

        duration: const Duration(milliseconds: 00),
      );
    }
    //  else if (title == "Account & Security") {
    //   Get.to(
    //     () => AccountSecurityScreen(),
    //     transition: Transition.leftToRight,
    //     duration: const Duration(milliseconds: 00),
    //   );
    // }
    else if (title == "Linked Accounts") {
      Get.to(
        () => LinkedAccountScreen(),
        transition: Transition.leftToRight,

        duration: const Duration(milliseconds: 00),
      );
    } else if (title == "Help & Support") {
      Get.to(
        () => HelpSupportScreen(),
        transition: Transition.leftToRight,

        duration: const Duration(milliseconds: 00),
      );
    }
    // else if (title == "Data & Analytics") {
    //   Get.to(
    //     () => DataAnalyticsScreen(),
    //     transition: Transition.leftToRight,

    //     duration: const Duration(milliseconds: 00),
    //   );
    // }
    // else if (title == "Rate us") {
    //   //  Get.to(
    //   //   () => DataAnalyticsScreen(),
    //   //   transition: Transition.leftToRight,

    //   //   duration: const Duration(milliseconds: 300),
    //   // );
    // } else {}
    ////App Appearance
  }
}

////////////////////////////////////////////////////////////
/// 🔹 SETTING TILE
////////////////////////////////////////////////////////////

class SettingTile extends StatelessWidget {
  final SettingModel model;

  const SettingTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(model.icon),
      title: Text(
        model.title,
        style: PoppinsMedium.copyWith(color: ColorResources.TextColorForGrey),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: Dimensions.spacingSize16),
      onTap: model.onTap,
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 LOGOUT TILE
////////////////////////////////////////////////////////////

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "Logout",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        _showLogoutBottomSheet(context);

        // showDialog(
        //   context: context,
        //   builder: (_) => AlertDialog(
        //     title: const Text("Logout"),
        //     content: const Text("Are you sure you want to logout?"),
        //     actions: [
        //       TextButton(
        //         onPressed: () => Navigator.pop(context),
        //         child: const Text("Cancel"),
        //       ),
        //       TextButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //           ScaffoldMessenger.of(
        //             context,
        //           ).showSnackBar(const SnackBar(content: Text("Logged out")));
        //         },
        //         child: const Text(
        //           "Logout",
        //           style: TextStyle(color: Colors.red),
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(Dimensions.spacingSize20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.spacingSize20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Drag Handle
                Container(
                  width: Dimensions.spacingSize40,
                  height: 5,
                  margin: const EdgeInsets.only(
                    bottom: Dimensions.spacingSize20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(
                      Dimensions.spacingSize20,
                    ),
                  ),
                ),

                /// Title
                Text(
                  "Logout",
                  style: PoppinsExtrabold.copyWith(
                    color: ColorResources.textColorRed,
                    fontSize: Dimensions.hight17,
                  ),
                ),

                SizedBox(height: Dimensions.spacingSize10),
                Divider(color: ColorResources.TextColorForGrey),
                SizedBox(height: Dimensions.spacingSize10),

                /// Message
                Text(
                  "Sure you want to log out?",
                  style: PoppinsReguler.copyWith(
                    color: ColorResources.blackcolor,
                    fontSize: Dimensions.spacingSize16,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: Dimensions.spacingSize10),
                Divider(color: ColorResources.TextColorForGrey),
                SizedBox(height: Dimensions.spacingSize10),

                /// Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomSecondaryButton(
                        // CustomPrimaryButton(
                        text: "Cancle",
                        onTap: () {
                          Get.back();
                          //  Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(width: Dimensions.spacingSize14),
                    Expanded(
                      child: CustomPrimaryButton(
                        text: "Yes, Logout",
                        onTap: () {
                          Get.find<AuthController>().userLogOut(
                            context: context,
                          );

                          // Get.back();

                          /// Logout logic here
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
