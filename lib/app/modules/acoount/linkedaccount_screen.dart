import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LinkedAccountScreen extends StatelessWidget {
  const LinkedAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),

              /// Header
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, size: width * 0.06),
                  ),
                  SizedBox(width: width * 0.05),
                  Text(
                    "Linked Account",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.04),

              /// Account Cards
              accountTile(
                context,
                icon: "assets/images/googlelog.png",
                title: "Google",
                connected: true,
              ),
              SizedBox(height: height * 0.02),

              accountTile(
                context,
                icon: "assets/images/applelogo.png",
                title: "Apple",
                connected: true,
              ),
              SizedBox(height: height * 0.02),

              accountTile(
                context,
                icon: "assets/images/Facebooklogo.png",
                title: "Facebook",
                connected: false,
              ),
              SizedBox(height: height * 0.02),

              accountTile(
                context,
                icon: "assets/images/Instagram.png",
                title: "Instagram",
                connected: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountTile(
    BuildContext context, {
    required String icon,
    required String title,
    required bool connected,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.018,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            icon,
            height: width * 0.08,
            width: width * 0.08,
            fit: BoxFit.contain,
          ),
          SizedBox(width: width * 0.05),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            connected ? "Connected" : "Connect",
            style: TextStyle(
              fontSize: width * 0.04,
              color: connected ? Colors.grey : Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
