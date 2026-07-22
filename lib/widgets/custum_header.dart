import 'package:flutter/material.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';

Widget customHeader(GlobalKey<ScaffoldState> scaffoldKey) {
  return Container(
    height: 180,
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: ColorResources.primaryGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState?.openDrawer();
              },
              child: Icon(Icons.menu, color: Colors.white, size: 26),
            ),
          ),

          /// 🔹 Welcome Text
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome !",
                    style: opensansSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Suraj Kumar Yadav",
                    style: opensansSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 Decorative Butterfly (Optional Image)
          Positioned(
            right: 10,
            bottom: 10,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset('assets/images/butterfly 1.png', height: 80),
            ),
          ),
        ],
      ),
    ),
  );
}
