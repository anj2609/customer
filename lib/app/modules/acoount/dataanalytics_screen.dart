import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataAnalyticsScreen extends StatelessWidget {
  const DataAnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.02),

              /// Top Bar
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                      
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: width * 0.05,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Data & Analytics",
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.05), // balance spacing
                ],
              ),

              SizedBox(height: height * 0.04),

              /// Card Container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.015,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildOptionTile(
                      context,
                      title: "Data Usage",
                      subtitle:
                          "Control how your data is used for analytics. Customize your preferences.",
                    ),
                    _divider(),
                    _buildOptionTile(
                      context,
                      title: "Ad Preferences",
                      subtitle:
                          "Manage ad personalization settings. Tailor your ad experience.",
                    ),
                    _divider(),
                    _buildOptionTile(
                      context,
                      title: "Download My Data",
                      subtitle:
                          "Request a copy of your data. Your information, your control.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context,
      {required String title, required String subtitle}) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: width * 0.04,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: width * 0.02),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: width * 0.06,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
    );
  }
}