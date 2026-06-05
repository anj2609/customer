import 'package:get/get.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Get.find<ProfileController>().getCustomerNotificationsSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.appgroundcolor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: ColorResources.blackcolor),
        centerTitle: true,
        title: Text(
          "Notifications",
          style: PoppinsSemiBold.copyWith(
            color: ColorResources.blackcolor,
            fontSize: Dimensions.spacingSize16,
          ),
          // style: TextStyle(
          //   color: Colors.black,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.spacingSize16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            ////color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(Dimensions.spacingSize16),
          ),
          child: GetBuilder<ProfileController>(
            builder: (controller) {
              if (controller.isCustomerNotifications) {
                return const Center(child: PremiumBlurLoader());
              }

              final data = controller.notificationModel;

              if (data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/notdatafound.png",
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "No Data Found",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  buildNotificationTile(
                    title: "General Updates",
                    value: controller.notificationModel?.generalUpdates == 1,
                    type: "general_updates",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Safety & Security Alerts",
                    value:
                        controller.notificationModel?.safetySecurityAlerts == 1,
                    type: "safety_security_alerts",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Account Notifications",
                    value:
                        controller.notificationModel?.accountNotifications == 1,
                    type: "account_notifications",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Ride Status Updates",
                    value: controller.notificationModel?.rideStatusUpdates == 1,
                    type: "ride_status_updates",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Promo Alerts",
                    value: controller.notificationModel?.promoAlerts == 1,
                    type: "promo_alerts",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Rating Reviews",
                    value: controller.notificationModel?.ratingReviews == 1,
                    type: "rating_reviews",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Personalized Recommendations",
                    value:
                        controller
                            .notificationModel
                            ?.personalizedRecommendations ==
                        1,
                    type: "personalized_recommendations",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "App Updates",
                    value: controller.notificationModel?.appUpdates == 1,
                    type: "app_updates",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Service Updates",
                    value: controller.notificationModel?.serviceUpdates == 1,
                    type: "service_updates",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Community Forum Activity",
                    value:
                        controller.notificationModel?.communityForumActivity ==
                        1,
                    type: "community_forum_activity",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Survey Feedback Requests",
                    value:
                        controller.notificationModel?.surveyFeedbackRequests ==
                        1,
                    type: "survey_feedback_requests",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "Important Announcements",
                    value:
                        controller.notificationModel?.importantAnnouncements ==
                        1,
                    type: "important_announcements",
                    controller: controller,
                  ),

                  buildNotificationTile(
                    title: "App Tips Tutorials",
                    value: controller.notificationModel?.appTipsTutorials == 1,
                    type: "app_tips_tutorials",
                    controller: controller,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget buildNotificationTile({
  required String title,
  required bool value,
  required String type,
  required ProfileController controller,
}) {
  return ListTile(
    title: Text(title),
    trailing: Switch(
      value: value,
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

      trackOutlineColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return ColorResources.blueeebutton;
        }
        return ColorResources.greycolorborder;
      }),

      onChanged: (bool newValue) async {
        // await controller.updatenotificationsetting(
        //   context: Get.context!,
        //   type: type,
        //   status: newValue ? "1" : "0",
        // );

        // await controller.getCustomerNotificationsSetting();
        try {
           showDialog(
                      context:Get.context!,
                      barrierDismissible: false,
                      builder: (_) => PremiumBlurLoader(),
                    );
          await controller.updatenotificationsetting(
            context: Get.context!,
            type: type,
            status: newValue ? "1" : "0",
          );

          await controller.getCustomerNotificationsSetting();
        } catch (e) {
          debugPrint('address update Error: $e');
        } finally {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        }
      },
    ),
  );
}

class NotificationTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.spacingSize16,
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: PoppinsSemiBold.copyWith(color: ColorResources.blackcolor),
            ),
          ),

          Switch(
            value: value,

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
}
