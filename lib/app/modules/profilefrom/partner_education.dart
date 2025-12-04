import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/partner_relition.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/occupation.dart';
import 'package:vivashri/data/controller/professional.dart';
import 'package:vivashri/data/controller/qualification.dart';
import 'package:vivashri/data/controller/workingas.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class PartnerEducationCareerScreen extends StatefulWidget {
  const PartnerEducationCareerScreen({super.key});

  @override
  State<PartnerEducationCareerScreen> createState() =>
      _PartnerEducationCareerScreenState();
}

class _PartnerEducationCareerScreenState
    extends State<PartnerEducationCareerScreen> {
  String? highestQualification;
  String? professionalQualification;
  String? occupation;
  String? workingAs;
  String? incomeFrom;
  StaperfromController stapercontroller = Get.put(StaperfromController());

  String? incomeTo;
  final eduC = Get.put(EducationController());
  final profEduC = Get.put(ProfessionalEduController());
  final occC = Get.put(OccupationController());
  final workingC = Get.put(WorkingWithController());
  List<DropdownMenuItem<String>> buildIncomeItems(List<String> keys) {
    return keys
        .map(
          (key) => DropdownMenuItem(
            value: key, // "100000-200000"
            child: Text(
              incomeRange[key]!,
              style: opensansMedium.copyWith(
                color: ColorResources.blackhalka,
                fontSize: 14,
              ),
            ), // "1 Lakh - 2 Lakh"
          ),
        )
        .toList();
  }

  List<String> get fromIncomeKeys => incomeRange.keys.toList();
  List<String> filteredToIncome(String? fromIncome) {
    if (fromIncome == null) return incomeRange.keys.toList();

    // extract first number from "100000-200000"
    int selectedMin =
        int.tryParse(fromIncome.split("-").first.replaceAll("Above ", "")) ?? 0;

    return incomeRange.keys.where((key) {
      String minPart = key.split("-").first.replaceAll("Above ", "");
      int minValue = int.tryParse(minPart) ?? 0;
      return minValue >= selectedMin;
    }).toList();
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
                            Expanded(
                              child: Text(
                                "Provide Partner’s education & career details:",
                                style: opensansMedium.copyWith(
                                  fontSize: 16,

                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        _label("Highest Qualification"),
                        Obx(() {
                          return _dropdown22(
                            value: eduC.selectedEduId.value.isEmpty
                                ? null
                                : eduC.selectedEduId.value,

                            onChanged: (v) {
                              eduC.onSelect(v!);
                            },

                            items: eduC.educationList
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

                        _label("Professional Education"),
                        Obx(() {
                          return _dropdown22(
                            value: profEduC.selectedProfEduId.value.isEmpty
                                ? null
                                : profEduC.selectedProfEduId.value,

                            onChanged: (v) {
                              profEduC.onSelect(v!);
                            },

                            items: profEduC.profEduList
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

                        _label("Occupation"),
                        Obx(() {
                          return _dropdown22(
                            value: occC.selectedOccId2.value.isEmpty
                                ? null
                                : occC.selectedOccId2.value,

                            onChanged: (v) {
                              occC.onSelect2(v!);
                            },

                            items: occC.occupationList
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

                        _label("Working With"),
                        Obx(() {
                          return _dropdown22(
                            value: workingC.selectedWorkingId2.value.isEmpty
                                ? null
                                : workingC.selectedWorkingId2.value,

                            onChanged: (v) {
                              workingC.onSelect2(v!);
                            },

                            items: workingC.workingList
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

                        // ---------------- ANNUAL INCOME ----------------
                        _label("Annual Income Range:"),
                        Row(
                          children: [
                            Expanded(
                              child: _dropdown22(
                                value: incomeFrom,
                                items: buildIncomeItems(fromIncomeKeys),
                                onChanged: (v) {
                                  setState(() {
                                    incomeFrom = v;
                                    incomeTo = null; // reset next dropdown
                                    print('$incomeFrom');
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text("To"),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _dropdown22(
                                value: incomeTo,
                                items: buildIncomeItems(
                                  filteredToIncome(incomeFrom),
                                ),
                                onChanged: (v) {
                                  setState(() => incomeTo = v);
                                  print('$incomeTo');
                                },
                              ),
                            ),
                          ],
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
                        value: 0.90,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "16 of 18",
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

  // ---------------- DROPDOWN ----------------

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
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
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (eduC.selectedEduId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Highest Qualification',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (profEduC.selectedProfEduId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Professional Education',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (occC.selectedOccId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Occupation',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (workingC.selectedWorkingId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Working With',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (incomeFrom == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Annual Income',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (incomeTo == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Annual Income',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.partnereductiondetauls(
                  formData: {
                    "partner_education": eduC.selectedEduId.value,
                    "partner_professional_qualification":
                        profEduC.selectedProfEduId.value,
                    "partner_occupation": occC.selectedOccId2.value,
                    "partner_working_as": workingC.selectedWorkingId2.value,
                    "partner_income_from": incomeFrom,
                    "partner_income_to": incomeTo,
                    "app_step": '16',
                    "step": '16',
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
