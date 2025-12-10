import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/partner_other.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/castecontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/religion.dart';
import 'package:vivashri/data/controller/subcaste.dart';

class PartnerReligionCasteScreen extends StatefulWidget {
  const PartnerReligionCasteScreen({super.key});

  @override
  State<PartnerReligionCasteScreen> createState() =>
      _PartnerReligionCasteScreenState();
}

class _PartnerReligionCasteScreenState
    extends State<PartnerReligionCasteScreen> {
  String? religion = "Hindu";
  String? caste;
  String? subcaste;
  final doshController = TextEditingController();
  final religionC = Get.put(ReligionController());
  final casteC = Get.put(CasteController());
  final subCasteC = Get.put(SubCasteController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    religionC.fetchReligion();
  }

  StaperfromController stapercontroller = Get.put(StaperfromController());

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
                              "Provide religion & caste details:",
                              style: opensansMedium.copyWith(
                                fontSize: 16,

                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ---------------- RELIGION ----------------
                        _label("Religion:"),
                        Obx(() {
                          return _dropdown(
                            value: religionC.selectedId.value.isEmpty
                                ? null
                                : religionC.selectedId.value,

                            onChanged: (v) {
                              religionC.onSelectById(v!);
                              casteC.fetchCaste(v);
                              subCasteC.subCasteList.clear();
                            },

                            items: religionC.religionList
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

                        // ---------------- CASTE ----------------
                        _label("Caste:"),
                        Obx(() {
                          return _dropdown(
                            value: casteC.selectedCasteId.value.isEmpty
                                ? null
                                : casteC.selectedCasteId.value,

                            onChanged: (v) {
                              casteC.onSelect(v!); // v = ID
                              subCasteC.fetchSubCaste(v);
                            },

                            items: casteC.casteList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.id, // ID
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

                        // ---------------- SUBCASTE ----------------
                        _topLabel("Subcaste:"),
                        Obx(() {
                          return _dropdown(
                            value: subCasteC.selectedSubCasteId.value.isEmpty
                                ? null
                                : subCasteC.selectedSubCasteId.value,

                            onChanged: (v) {
                              print('lllll${v}');
                              subCasteC.onSelect(v!);
                              // gotraC.fetchGotra(v);
                            },

                            items: subCasteC.subCasteList
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

                        // ---------------- DOSH ----------------
                        _label1("Dosh:"),
                        _textfield(doshController),

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
                    "Partner’s Location",
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
                        value: 0.95,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "17 of 18",
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
                  "Partner’s Education & Career",
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
                if (religionC.selectedName.value == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Religion',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (casteC.selectedCasteName.value == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Caste',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (subCasteC.selectedSubCasteName.value == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Subcaste',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  stapercontroller.partnercasteedetauls(
                    formData: {
                      "partner_religion": religionC.selectedId.value,
                      "partner_caste": casteC.selectedCasteId.value,
                      "partner_sub_caste": subCasteC.selectedSubCasteId.value,
                      "partner_dosh": doshController.text.trim(),
                      "app_step": '17',
                      "step": '17',
                      "form_status": 'Completed',
                    },
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
                    "Partner Religion & ",
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

  Widget _label1(String text) {
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
          ],
        ),
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

  Widget _topLabel(String text) {
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

  Widget _dropdown({
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

  // ---------------- TEXTFIELD ----------------
  Widget _textfield(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.pink, width: 1.3),
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
              Get.to(
                PartnerOtherDetailsScreen(),
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
              if (religionC.selectedName.value == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Religion',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (casteC.selectedCasteName.value == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Caste',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (subCasteC.selectedSubCasteName.value == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Subcaste',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.partnercasteedetauls(
                  formData: {
                    "partner_religion": religionC.selectedId.value,
                    "partner_caste": casteC.selectedCasteId.value,
                    "partner_sub_caste": subCasteC.selectedSubCasteId.value,
                    "partner_dosh": doshController.text.trim(),
                    "app_step": '17',
                    "step": '17',
                    "form_status": 'Completed',
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
