import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/dimensions.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Map<String, bool> notificationSettings = {
    "General Updates": true,
    "Safety and Security Alerts": true,
    "Account Notifications": false,
    "Ride Status Updates": true,
    "Promo Alerts": true,
    "Rating and Reviews": false,
    "Personalized Recommendations": true,
    "App Updates": true,
    "Service Updates": false,
    "Community Forum Activity": false,
    "Survey and Feedback Requests": false,
    "Important Announcements": true,
    "App Tips and Tutorials": false,
  };

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
      body: Padding(
        padding: EdgeInsets.all(Dimensions.spacingSize16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(Dimensions.spacingSize16),
          ),
          child: ListView.separated(
            itemCount: notificationSettings.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              String title = notificationSettings.keys.elementAt(index);

              return NotificationTile(
                title: title,
                value: notificationSettings[title]!,
                onChanged: (val) {
                  setState(() {
                    notificationSettings[title] = val;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
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
