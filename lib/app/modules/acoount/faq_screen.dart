import 'dart:developer';

import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int selectedIndex = 0;

  final List<String> categories = ["general", "account", "services", "ride"];

  @override
  void initState() {
    super.initState();

    /// First time load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProfileController>().getFaqList(
        context: context,
        type: categories[selectedIndex],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: ColorResources.blackcolor),
        ),
        centerTitle: true,
        title: const Text(
          "FAQ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),

            /// 🔍 Search Field (UI same)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });

                      String selectedCategory = categories[index];

                      log('Selected category: $selectedCategory');

                      Get.find<ProfileController>().getFaqList(
                        context: context,
                        type: selectedCategory.toLowerCase(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? ColorResources.blueeebutton
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        categories[index].capitalizeFirst!,
                        style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: size.height * 0.02),

            Expanded(
              child: GetBuilder<ProfileController>(
                builder: (controller) {
                  if (controller.isfqlLoading) {
                    return  Center(child: PremiumBlurLoader());
                  }


                

                  if (controller.faqList.isEmpty) {
                    return const Center(child: Text("No FAQ Available"));
                  }

                  return ListView.builder(
                    itemCount: controller.faqList.length,
                    itemBuilder: (context, index) {
                      final faq = controller.faqList[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          childrenPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            faq.question ?? "",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          iconColor: Colors.black,
                          collapsedIconColor: Colors.black,
                          children: (faq.answer ?? "").isNotEmpty
                              ? [
                                  Text(
                                    faq.answer ?? "",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ]
                              : [],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
