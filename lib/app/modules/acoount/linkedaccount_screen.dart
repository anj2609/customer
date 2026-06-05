import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinkedAccountScreen extends StatefulWidget {
  const LinkedAccountScreen({super.key});

  @override
  State<LinkedAccountScreen> createState() => _LinkedAccountScreenState();
}

class _LinkedAccountScreenState extends State<LinkedAccountScreen> {
  String? token;

  /// Dynamic connection status
  Map<String, bool> connectedStatus = {
    'google': false,
    'apple': false,
    'facebook': false,
    'instagram': false,
  };

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  /// Common function for all providers
  Future<void> handleSocialTap(String provider) async {
    final profileController = Get.find<ProfileController>();

    bool isConnected = connectedStatus[provider] ?? false;

    if (token == null || token!.isEmpty) {
      Get.snackbar("Error", "Token not found");
      return;
    }

    try {
      if (isConnected) {
        /// Disconnect API
        final response =
            await profileController.linkAccountDeconnectCallApi(
          context: context,
          provider: provider,
        );

        if (response != null) {
          setState(() {
            connectedStatus[provider] = false;
          });
        }
      } else {
        /// Connect API
        final response =
            await profileController.linkAccountConnectCallApi(
          context: context,
          provider: provider,
          accesstoken: token!,
        );

        if (response != null) {
          setState(() {
            connectedStatus[provider] = true;
          });
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

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
                    onTap: () => Get.back(),
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

              /// Google
              socialTile(
                provider: 'google',
                icon: "assets/images/googlelog.png",
                title: "Google",
              ),

              SizedBox(height: height * 0.02),

              /// Apple
              socialTile(
                provider: 'apple',
                icon: "assets/images/applelogo.png",
                title: "Apple",
              ),

              SizedBox(height: height * 0.02),

              /// Facebook
              socialTile(
                provider: 'facebook',
                icon: "assets/images/Facebooklogo.png",
                title: "Facebook",
              ),

              SizedBox(height: height * 0.02),

              /// Instagram
              socialTile(
                provider: 'instagram',
                icon: "assets/images/Instagram.png",
                title: "Instagram",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Tile
  Widget socialTile({
    required String provider,
    required String icon,
    required String title,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () => handleSocialTap(provider),
      child: Container(
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
              connectedStatus[provider] == true
                  ? "Connected"
                  : "Disconnected",
              style: TextStyle(
                fontSize: width * 0.04,
                color: connectedStatus[provider] == true
                    ? Colors.grey
                    : Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}