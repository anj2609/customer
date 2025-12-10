import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/partner_basic_details.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/hobbies.dart';

class PartnerQualitiesScreen extends StatefulWidget {
  const PartnerQualitiesScreen({super.key});

  @override
  State<PartnerQualitiesScreen> createState() => _PartnerQualitiesScreenState();
}

class _PartnerQualitiesScreenState extends State<PartnerQualitiesScreen> {
  List<String> qualities = ["Independent", "Affectionate", "Curious", "Calm"];

  List<String> hobbies = ["Dancing", "Painting", "Politics", "Cooking"];
  StaperfromController stapercontroller = Get.put(StaperfromController());

  List<String> selectedQualities = [];
  List<String> selectedPartnerHobbies = [];
  final hobbyC = Get.put(HobbyController());

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _header(),
                Divider(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // ----------- Top Row with Icon and Title ----------
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/images/femalee.png",
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Partner’s preference detail:",
                              style: opensansMedium.copyWith(
                                fontSize: 16,

                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Partners Desired Qualities",
                          style: opensansMedium.copyWith(
                            fontSize: 14,

                            color: ColorResources.blackgrey,
                          ),
                        ),

                        const SizedBox(height: 10),

                        _chips(qualities),

                        const SizedBox(height: 15),
                        Text(
                          "Please provide your partner Hobbies\nor likings details:",
                          style: opensansMedium.copyWith(
                            fontSize: 16,

                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 10),
                        Text(
                          "Hobbies:",
                          style: opensansMedium.copyWith(
                            fontSize: 14,

                            color: ColorResources.blackgrey,
                          ),
                        ),

                        const SizedBox(height: 8),
                        hobbiesScrollableBox(),

                        // _chips(hobbies, selectedPartnerHobbies),
                        const SizedBox(height: 50),
                        _buttons(),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
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

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          // LEFT
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Prev Step:",
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 14,
                    style: opensansBold.copyWith(
                      color: ColorResources.primarycolor,
                    ),
                  ),
                  AutoSizeText(
                    "Upload Photo",
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 14,
                    style: opensansBold.copyWith(
                      color: ColorResources.primarycolor2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CENTER
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: 0.64,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "12 of 18",
                      style: opensansMedium.copyWith(
                        color: ColorResources.blackgrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Text(
                  "Partner’s Qualities",
                  style: opensansMedium.copyWith(
                    color: ColorResources.blackcolor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // RIGHT
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (selectedChip == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Partners Qualities',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (hobbyC.selectedHobbyIds.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Partners Hobbies',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  stapercontroller.partnerqualities(
                    formData: {
                      "partner_qualities": selectedChip,

                      "app_step": '12',
                      "step": '12',
                    },
                    selected: hobbyC.selectedHobbyIds222,
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    "Next Step:",
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 14,
                    style: opensansBold.copyWith(
                      color: ColorResources.primarycolor,
                    ),
                  ),
                  AutoSizeText(
                    "Partner’s Basic Det",
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 14,
                    style: opensansBold.copyWith(
                      color: ColorResources.primarycolor2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? selectedChip;
  // ---------------- Chips / Selectable Tags ----------------
  Widget _chips(List<String> items) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: items.map((item) {
        bool selected = selectedChip == item;

        return InkWell(
          onTap: () {
            setState(() {
              selectedChip = item; // <-- sirf ek select hoga
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selected ? Colors.pink.shade50 : Colors.white,
              border: Border.all(
                color: selected ? Colors.pink : Colors.grey.shade400,
                width: 1.2,
              ),
            ),
            child: Text(
              item,
              style: opensansMedium.copyWith(
                fontSize: 13,
                color: selected ? Colors.pink : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget hobbiesScrollableBox() {
    return Obx(() {
      return Container(
        height: 170,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 5,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: hobbyC.hobbyList.map((h) {
                bool selected2 = hobbyC.selectedHobbyIds222.contains(h.id);

                return InkWell(
                  onTap: () {
                    hobbyC.toggleHobby22(h.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selected2 ? Colors.pink.shade50 : Colors.white,
                      border: Border.all(
                        color: selected2
                            ? ColorResources.primarycolor3
                            : Colors.grey.shade400,
                        width: 1.3,
                      ),
                    ),
                    child: Text(
                      h.name, // Name show
                      style: opensansSemiBold.copyWith(
                        fontSize: 13,
                        color: selected2
                            ? ColorResources.primarycolor3
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(
                PartnerBasicDetailsScreen(),
                duration: Duration(
                  milliseconds: ApiConstants.screenTransitionTime,
                ),
                transition: Transition.rightToLeft,
              );
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorResources.halkapink,
              ),
              child: Text(
                "SKIP",
                style: opensansMedium.copyWith(
                  color: ColorResources.primarycolor2,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (selectedChip == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Partners Qualities',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (hobbyC.selectedHobbyIds.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Partners Hobbies',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.partnerqualities(
                  formData: {
                    "partner_qualities": selectedChip,

                    "app_step": '12',
                    "step": '12',
                  },
                  selected: hobbyC.selectedHobbyIds222,
                );
              }
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFBE266B), Color(0xFFEB1D7B)],
                ),
              ),
              child: Text(
                "Continue",
                style: opensansMedium.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
