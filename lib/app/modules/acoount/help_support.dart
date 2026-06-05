import 'package:myrideuser/app/modules/acoount/faq_screen.dart';
import 'package:myrideuser/config/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final List<String> helpOptions = [
      "FAQ",
      "Contact Support",
      "Privacy Policy",
      "Terms of Services",
      "About us",
      "Rate us",
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xffF2F2F2),
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.02,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            itemCount: helpOptions.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, thickness: 0.5),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  helpOptions[index],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.black,
                ),
                onTap: () {
                  if (index == 0) {
                    Get.toNamed(RouteHelper.getfaqScreen());
                  } else if (index == 1) {
                    Get.toNamed(RouteHelper.getcontactSupportScreen());
                  } else if (index == 2) {
                    Get.toNamed(RouteHelper.getprivacyPolicyScreen());
                  } else if (index == 3) {
                    Get.toNamed(RouteHelper.gettermsOfServiceScreen());
                  } else if (index == 4) {
                    Get.toNamed(RouteHelper.getaboutusScreen());
                  } else if (index == 5) {
                    print('rating |||||||||||');

                    /// Get.toNamed(RouteHelper.getaboutusScreen());
                    //
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
