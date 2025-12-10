import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/Deshboard/buttom_navigation.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/dietcontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';

class PartnerOtherDetailsScreen extends StatefulWidget {
  const PartnerOtherDetailsScreen({super.key});

  @override
  State<PartnerOtherDetailsScreen> createState() =>
      _PartnerOtherDetailsScreenState();
}

class _PartnerOtherDetailsScreenState extends State<PartnerOtherDetailsScreen> {
  String? diet;
  String? drinking;
  StaperfromController stapercontroller = Get.put(StaperfromController());

  String? smoking;
  String? profileManaged;
  final dietC = Get.put(DietController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dietC.fetchDiet();
  }

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
                              "Provide other details:",
                              style: opensansMedium.copyWith(
                                fontSize: 16,

                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ---------------- Diet Preference ----------------
                        _label("Diet Preference:"),

                        Obx(() {
                          return _dropdown22(
                            value: dietC.selectedDietId2.value.isEmpty
                                ? null
                                : dietC.selectedDietId2.value,

                            onChanged: (v) {
                              dietC.onSelec22t(v!);
                            },

                            items: dietC.dietList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(
                                      e.name,
                                      style: opensansMedium.copyWith(
                                        color: ColorResources.blackhalka,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        }),

                        // ---------------- Drinking Habit ----------------
                        _label("Drinking Habit:"),
                        _dropdown(
                          value: drinking,
                          items: ["No", "Occasionally", "Yes"],
                          onChanged: (v) => setState(() => drinking = v),
                        ),

                        // ---------------- Smoking Habit ----------------
                        _label("Smoking Habit:"),
                        _dropdown(
                          value: smoking,
                          items: ["No", "Occasionally", "Yes"],
                          onChanged: (v) => setState(() => smoking = v),
                        ),

                        // ---------------- Profile Managed ----------------
                        _label("Profile Managed by:"),
                        _dropdown(
                          value: profileManaged,
                          items: [
                            "Self",
                            "Parent/Guardian",
                            "Sibling/Friend/Other",
                            "Open to All",
                          ],
                          onChanged: (v) => setState(() => profileManaged = v),
                        ),

                        const SizedBox(height: 40),
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
                    "Partner’s Religion",
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
                        value: 1,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "18 of 18",
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
                  "Partner’s Other Details",
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
                if (dietC.selectedDietId2.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Select Diet Preference',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (drinking == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Drinking Habit',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (smoking == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Smoking Habit',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (profileManaged == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Profile Managed by',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  stapercontroller.partnerotheredetauls(
                    formData: {
                      "partner_diet": dietC.selectedDietId2.value,
                      "partner_drinking": drinking,
                      "partner_smoking": smoking,
                      "partner_managed_by": profileManaged,
                      "form_status": 'Completed',
                      "app_step": '18',
                      "step": '18',
                    },
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    "",
                    maxLines: 1,
                    minFontSize: 8,
                    maxFontSize: 14,
                    style: opensansBold.copyWith(
                      color: ColorResources.primarycolor,
                    ),
                  ),
                  AutoSizeText(
                    " ",
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: opensansMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackgrey,
              ),
            ),
            TextSpan(
              text: " *",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red, // ⭐ RED COLOR
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown22({
    required String? value,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          hint: Text(
            "Select",
            style: opensansMedium.copyWith(
              color: ColorResources.blackhalka,
              fontSize: 14,
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ---------------- DROPDOWN ----------------
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          hint: Text(
            "Select",
            style: opensansMedium.copyWith(
              color: ColorResources.blackhalka,
              fontSize: 14,
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: opensansMedium.copyWith(
                      color: ColorResources.blackhalka,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.offAll(
                MainNavigation(),
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
              if (dietC.selectedDietId2.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Diet Preference',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (drinking == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Drinking Habit',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (smoking == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Smoking Habit',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (profileManaged == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Profile Managed by',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.partnerotheredetauls(
                  formData: {
                    "partner_diet": dietC.selectedDietId2.value,
                    "partner_drinking": drinking,
                    "partner_smoking": smoking,
                    "partner_managed_by": profileManaged,
                    "form_status": 'Completed',
                    "app_step": '18',
                    "step": '18',
                  },
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
