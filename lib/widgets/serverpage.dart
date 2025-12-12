import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:lottie/lottie.dart';

class ServerMaintenancePage extends StatelessWidget {
  final UserDetailController controller = Get.find<UserDetailController>();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Lottie.asset(
                    "assets/images/Under Construction 1.json",
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Server Under Maintenance",
                    style: opensansSemiBold.copyWith(fontSize: 20),
                  ),
                  SizedBox(height: 0),
                  Text(
                    "Please wait or refresh again.",
                    style: opensansSemiBold.copyWith(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: () {
                      controller.fetchUserDetail(
                        controller.userData.value?.id.toString() ?? "",
                        fromRetry: true,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.primarycolor2,
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Refresh",
                      style: opensansMedium.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
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
}
