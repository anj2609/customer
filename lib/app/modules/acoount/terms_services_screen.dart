import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Get.find<ProfileController>()
          .termandCondition(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: GetBuilder<ProfileController>(
          builder: (controller) {
            return Text(
              controller.cmsModel?.data?.name ?? "Loading...",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),

      body: GetBuilder<ProfileController>(
        builder: (controller) {

          if (controller.isCmsLoading) {
            return  Center(
              child: PremiumBlurLoader(),
            );
          }




          String details =
              controller.cmsModel?.data?.details ?? "";

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: 20,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Html(
                  data: details.isNotEmpty
                      ? "<p>$details</p>"
                      : "<p>No content available</p>",
                  style: {
                    "body": Style(
                      fontSize: FontSize(14),
                      lineHeight: LineHeight(1.6),
                      color: Colors.black87,
                    ),
                    "h3": Style(
                      fontSize: FontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                    "h4": Style(
                      fontSize: FontSize(15),
                      fontWeight: FontWeight.w600,
                    ),
                    "li": Style(
                      margin: Margins.only(bottom: 8),
                    ),
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}