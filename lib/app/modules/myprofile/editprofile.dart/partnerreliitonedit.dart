import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/castecontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/religion.dart';
import 'package:vivashri/data/controller/subcaste.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class EditPartnerReligionCasteScreen extends StatefulWidget {
  const EditPartnerReligionCasteScreen({super.key});

  @override
  State<EditPartnerReligionCasteScreen> createState() =>
      _EditPartnerReligionCasteScreenState();
}

class _EditPartnerReligionCasteScreenState
    extends State<EditPartnerReligionCasteScreen> {
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
    getdata();
  }

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;
    religionC.selectedId.value = u.partnerReligion!.id.toString();
    religionC.selectedName.value = u.partnerReligion!.name;
    casteC.fetchCaste(religionC.selectedId.value);
    casteC.selectedCasteId.value = u.partnerCaste!.id.toString();
    casteC.selectedCasteName.value = u.partnerCaste!.name;
    subCasteC.fetchSubCaste(casteC.selectedCasteId.value);
    subCasteC.selectedSubCasteId.value = u.partnerSubCaste!.id.toString();
    subCasteC.selectedSubCasteName.value = u.partnerSubCaste!.name;
    doshController.text = u.partnerDosh.toString();

    setState(() {});
  }

  final usercontroller = Get.put(UserDetailController());
  StaperfromController stapercontroller = Get.put(StaperfromController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Partner’s Religion & Caste',
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    _topLabel("Dosh:"),
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
              stapercontroller.updatepartnerreligion(
                formData: {
                  "partner_religion": religionC.selectedId.value,
                  "partner_caste": casteC.selectedCasteId.value,
                  "partner_sub_caste": subCasteC.selectedSubCasteId.value,
                  "partner_dosh": doshController.text.trim(),
                  "form_status": 'Completed',
                },
              );  Future.delayed(const Duration(microseconds: 1000), () {
                Get.back();
              });
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
                "Update",
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
