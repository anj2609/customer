import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/reference_details.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/castecontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/gotra.dart';
import 'package:vivashri/data/controller/religion.dart';
import 'package:vivashri/data/controller/subcaste.dart';

class ReligionDetailsScreen extends StatefulWidget {
  const ReligionDetailsScreen({super.key});

  @override
  State<ReligionDetailsScreen> createState() => _ReligionDetailsScreenState();
}

class _ReligionDetailsScreenState extends State<ReligionDetailsScreen> {
  String? religion = "Hindu";
  String? caste;
  String? subcaste;
  String? gotra;
  final religionC = Get.put(ReligionController());
  final casteC = Get.put(CasteController());
  final subCasteC = Get.put(SubCasteController());
  TextEditingController dostController = TextEditingController();
  final gotraC = Get.put(GotraController());
  TextEditingController othergotraController = TextEditingController();
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

                        _label("Subcaste:"),
                        Obx(() {
                          return _dropdown(
                            value: subCasteC.selectedSubCasteId.value.isEmpty
                                ? null
                                : subCasteC.selectedSubCasteId.value,

                            onChanged: (v) {
                              print('lllll${v}');
                              subCasteC.onSelect(v!);
                              gotraC.fetchGotra(v);
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

                        _label("Gotra:"),
                        Obx(() {
                          return _dropdown(
                            value: gotraC.selectedGotraId.value.isEmpty
                                ? null
                                : gotraC.selectedGotraId.value,

                            onChanged: (v) {
                              gotraC.onSelect(v!);
                              setState(() {});
                            },

                            items: gotraC.gotraList
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

                        const SizedBox(height: 10),

                        gotraC.selectedGotraName.value == "Other"
                            ? _textField22()
                            : _hintBox(
                                "This field will come when other selected",
                              ),

                        _label("Dosh:"),
                        _textField(),

                        const SizedBox(height: 30),
                        _buttons(),
                        const SizedBox(height: 40),
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
                  "Aadhaar Verification",
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
                        value: 0.08,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "5 of 18",
                      style: opensansMedium.copyWith(
                        color: ColorResources.blackgrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Text(
                  "Religion Details",
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
                  "Reference Details",
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
            const TextSpan(
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

  // ---------------------- Dropdown ------------------------

  // ---------------------- Hint Box ------------------------
  Widget _hintBox(String text) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        // color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: opensansMedium.copyWith(color: ColorResources.blackhalka),
        ),
      ),
    );
  }

  Widget _textField22() {
    return TextField(
      controller: othergotraController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColorResources.primarycolor),
        ),
      ),
    );
  }

  // ---------------------- TextField ------------------------
  Widget _textField() {
    return TextField(
      controller: dostController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColorResources.primarycolor),
        ),
      ),
    );
  }

  // ---------------------- Buttons ------------------------
  Widget _buttons() {
    return Row(
      children: [
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
              } else if (gotraC.selectedGotraName.value == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Gotra',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (dostController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Enter Your Dosh',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.religiondeytalsProfile(
                  formData: {
                    "religion": religionC.selectedId.value,
                    "caste": casteC.selectedCasteId.value,
                    "sub_caste": subCasteC.selectedSubCasteId.value,
                    "gotra": gotraC.selectedGotraId.value,
                    "gotra_other": othergotraController.text.trim(),
                    "dosh": dostController.text.trim(),
                    "app_step": '5',
                    "step": '5',
                  },
                  context: context
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
