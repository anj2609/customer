import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';

class NotificationCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final NotificationController notificationController = Get.find();

    return Obx(() {
      return Center(
        child: Text(
          // "${notificationController.notificationCount}",
          "0",
          style: opensansRegular.copyWith(
            fontSize: 22,
            color: ColorResources.primarycolor2,
          ),
        ),
      );
    });
  }
}
