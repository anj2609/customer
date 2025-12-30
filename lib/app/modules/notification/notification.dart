import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String dropdownValue = "All Notification";

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      //  key: _scaffoldKey,
      backgroundColor: Colors.white,
      // drawer: CustomAppDrawer(),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 15),
                _buildTabs(),
                _buildHeaderRow(),
                Expanded(child: _notificationList()),
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

  // --------------------- TOP BAR --------------------------------------
  Widget _buildTopBar(BuildContext context) {
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
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorResources.blackcolor11,
                  size: 24,
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
              "Notification",
              style: opensansSemiBold.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Image.asset(
          //       'assets/images/search-alt_svgrepo.com.png',
          //       height: 25,
          //       color: ColorResources.blackcolor11,
          //     ),
          //     const SizedBox(width: 16),
          //   ],
          // ),
        ],
      ),
    );
  }

  // ---------------------- TABS ---------------------------------------
  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "All",
              style: opensansSemiBold.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xfff9eedd),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  style: opensansSemiBold.copyWith(
                    fontSize: 13,

                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "All Notification",
                      child: Text(
                        "All Notification",
                        style: opensansSemiBold.copyWith(
                          fontSize: 13,

                          color: Colors.black,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Accepted",
                      child: Text(
                        "Accepted",
                        style: opensansSemiBold.copyWith(
                          fontSize: 13,

                          color: Colors.black,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Viewed",
                      child: Text(
                        "Viewed",
                        style: opensansSemiBold.copyWith(
                          fontSize: 13,

                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => dropdownValue = value!);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------- DROPDOWN + TEXT -----------------------------
  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Alerts about Invitations & Requests you sent",
              style: opensansSemiBold.copyWith(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- NOTIFICATION LIST ---------------------------
  Widget _notificationList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _notificationCard("assets/images/Rectangle 77.png"),
        _notificationCard("assets/images/Rectangle 77.png"),
        _notificationCard("assets/images/Rectangle 77.png"),
        _notificationCard("assets/images/Rectangle 77.png"),
      ],
    );
  }

  // ---------------------- CARD UI ------------------------------------
  Widget _notificationCard(String img) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xfffdeef3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(img, height: 55, width: 55, fit: BoxFit.cover),
          ),

          const SizedBox(width: 12),

          // Text Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Kimmy K ",
                        style: opensansSemiBold.copyWith(
                          fontSize: 13,
                          color: ColorResources.primarycolor3,
                        ),
                      ),

                      TextSpan(
                        text:
                            "has Accepted your Interest\n2 Hour   viewed your Profile",
                        style: opensansSemiBold.copyWith(
                          fontSize: 12,
                          color: ColorResources.blackhalka,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 5),

                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                    SizedBox(width: 6),
                    Text(
                      "6 Oct 2025",
                      style: opensansSemiBold.copyWith(
                        fontSize: 11.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
