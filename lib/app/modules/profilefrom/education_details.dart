import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/upload_image.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/eductiondrop.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/occupation.dart';
import 'package:vivashri/data/controller/workingas.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class EducationDetailsScreen extends StatefulWidget {
  const EducationDetailsScreen({super.key});

  @override
  State<EducationDetailsScreen> createState() => _EducationDetailsScreenState();
}

class _EducationDetailsScreenState extends State<EducationDetailsScreen> {
  String? highestDegree;
  String? bachelorDegree;
  String? workingWith;
  final masterCollege = TextEditingController();
  final bachelorCollege = TextEditingController();
  final otherEducationDetails = TextEditingController();
  final annualIncome = TextEditingController();
  final occupation = TextEditingController();
  final organizationName = TextEditingController();
  final previousWork = TextEditingController();
  final controller = Get.put(EducationController22222());
  StaperfromController stapercontroller = Get.put(StaperfromController());
  final workingC = Get.put(WorkingWithController());
  final occC = Get.put(OccupationController());

  @override
  void dispose() {
    masterCollege.dispose();
    bachelorCollege.dispose();
    otherEducationDetails.dispose();
    annualIncome.dispose();
    occupation.dispose();
    organizationName.dispose();
    previousWork.dispose();
    super.dispose();
  }

  dynamic idddd;
  dynamic bcaaaa;
  dynamic secoudddddd;
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
                        _label("Highest Degree:"),
                        Obx(() {
                          // if (controller.isLoading.value) {
                          //   return CircularProgressIndicator();
                          // }

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<EducationModel>(
                              isExpanded: true,
                              underline: SizedBox(),
                              hint: Text(
                                "Select",
                                style: opensansMedium.copyWith(
                                  color: ColorResources.blackhalka,
                                  fontSize: 14,
                                ),
                              ),
                              value: controller.selectedMain.value,
                              icon: Icon(Icons.keyboard_arrow_down),

                              items: controller.educationList.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item.name,
                                    style: opensansMedium.copyWith(
                                      color: ColorResources.blackhalka,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),

                              onChanged: (value) {
                                controller.selectedMain.value = value;
                                controller.selectedSub.value = null;
                                controller.selectedThird.value = null;
                                print("Main Selected ID: ${value!.id}");
                                print(
                                  "Main Selected Type: ${value.educationType}",
                                );
                                bcaaaa = value.id;
                                idddd = value.educationType;
                                controller.updateFilteredList();
                                setState(() {});
                              },
                            ),
                          );
                        }),
                        controller.selectedMain.value == null
                            ? SizedBox()
                            : idddd == 2
                            ? _label1("Bachelor Degree::")
                            : _label1("PG Degree::"),

                        SizedBox(height: 5),
                        Obx(() {
                          if (controller.selectedMain.value == null)
                            return SizedBox();

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<EducationModel>(
                              isExpanded: true,
                              underline: SizedBox(),
                              hint: Text(
                                "Select",
                                style: opensansMedium.copyWith(
                                  color: ColorResources.blackhalka,
                                  fontSize: 14,
                                ),
                              ),
                              value: controller.selectedSub.value,
                              icon: Icon(Icons.keyboard_arrow_down),

                              items: controller.filteredList.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item.name,
                                    style: opensansMedium.copyWith(
                                      color: ColorResources.blackhalka,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),

                              onChanged: (value) {
                                controller.selectedSub.value = value;
                                secoudddddd = value!.id;
                                print(
                                  "Second Dropdown Selected ID: ${value!.id}",
                                );
                              },
                            ),
                          );
                        }),
                        SizedBox(height: 0),
                        _topLabel("Master College Name"),
                        _textField(controller: masterCollege),
                        controller.selectedMain.value == null
                            ? SizedBox()
                            : bcaaaa == "68cd44430402fd89b727bde0"
                            ? SizedBox()
                            : _label1("Bachelor Degree:"),
                        bcaaaa == "68cd44430402fd89b727bde0"
                            ? SizedBox()
                            : Obx(() {
                                if (controller.selectedMain.value == null)
                                  return SizedBox();

                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton<EducationModel>(
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    hint: Text(
                                      "Select",
                                      style: opensansMedium.copyWith(
                                        color: ColorResources.blackhalka,
                                        fontSize: 14,
                                      ),
                                    ),
                                    value: controller.selectedThird.value,
                                    icon: Icon(Icons.keyboard_arrow_down),

                                    items: controller.thirdList.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: opensansMedium.copyWith(
                                            color: ColorResources.blackhalka,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }).toList(),

                                    onChanged: (value) {
                                      controller.selectedThird.value = value;

                                      print(
                                        "Third Dropdown Selected ID: ${value!.id}",
                                      );
                                    },
                                  ),
                                );
                              }),
                        // Highest Degree
                        // _dropdown(
                        //   value: highestDegree,
                        //   items: ["M.Com", "MBA", "MCA", "MA", "MSc"],
                        //   onChanged: (v) => setState(() => highestDegree = v),
                        // ),

                        // Master College Name

                        // _dropdown(
                        //   value: bachelorDegree,
                        //   items: ["B.Com", "BBA", "BCA", "BA", "BSc"],
                        //   onChanged: (v) => setState(() => bachelorDegree = v),
                        // ),

                        // Bachelor College Name
                        _topLabel("Bachelor College Name"),
                        _textField(controller: bachelorCollege),

                        // Other Education Details
                        _topLabel("Add Other Education Details If Any"),
                        _multilineField(controller: otherEducationDetails),

                        const SizedBox(height: 15),
                        Text(
                          "Profession Details:",
                          style: opensansMedium.copyWith(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Annual Income
                        _label("Annual Income:"),
                        _dropdown2(
                          value: incomeFrom,
                          items: buildIncomeItems(fromIncomeKeys),
                          onChanged: (v) {
                            setState(() {
                              incomeFrom = v;
                              print('$incomeFrom');
                            });
                          },
                        ),
                        // _textField(controller: annualIncome),

                        // Working With
                        _label("Working With:"),
                        Obx(() {
                          return _dropdown2(
                            value: workingC.selectedWorkingId.value.isEmpty
                                ? null
                                : workingC.selectedWorkingId.value,

                            onChanged: (v) {
                              workingC.onSelect(v!);
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

                        // Occupation
                        _label("Occupation:"),
                        Obx(() {
                          return _dropdown2(
                            value: occC.selectedOccId.value.isEmpty
                                ? null
                                : occC.selectedOccId.value,

                            onChanged: (v) {
                              occC.onSelect(v!);
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
                        // _textField(controller: occupation),

                        // Organization Name
                        _label("Organization Name:"),
                        _textField(controller: organizationName),

                        // Previous Working Detail
                        _topLabel("Add Previous Working Detail:"),
                        _multilineField(controller: previousWork),

                        const SizedBox(height: 25),
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

  String? incomeFrom;
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
                    "More Details",
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
                        value: 0.48,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "10 of 18",
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
                  "Education Details",
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
                if (bcaaaa == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Highest Degree',
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
                } else if (workingC.selectedWorkingId.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Select Working',
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
                } else if (organizationName.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Enter Organization Name',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  stapercontroller.edcuationdetailss(
                    formData: {
                      "highest_degree": bcaaaa,
                      "pg_degree": bcaaaa,
                      "pg_college_name": masterCollege.text.trim(),
                      "ug_degree": secoudddddd,
                      "ug_college_name": bachelorCollege.text.trim(),
                      "school_name": bachelorCollege.text,
                      "other_education": otherEducationDetails.text,
                      "annual_income": incomeFrom,
                      "working_with": workingC.selectedWorkingId.value,
                      "occupation": occC.selectedOccId.value,
                      "organization_name": organizationName.text,
                      "prev_working_detail": previousWork.text.trim(),
                      "app_step": '10',
                      "step": '10',
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
                    "Upload Details",
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
      child: Text(
        text,
        style: opensansMedium.copyWith(
          fontSize: 14,
          color: ColorResources.blackgrey,
        ),
      ),
    );
  }

  Widget _dropdown2({
    required String? value,
    required Function(String?) onChanged,
    required List<DropdownMenuItem<String>> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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

  // -------------------- DROPDOWN --------------------
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String hint = "Select",
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: value,
          icon: Icon(Icons.keyboard_arrow_down),
          hint: Text(
            hint,
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

  // -------------------- TEXT FIELD --------------------
  Widget _textField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.pink),
        ),
      ),
    );
  }

  // -------------------- MULTILINE FIELD --------------------
  Widget _multilineField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      maxLines: 4,
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
          borderSide: const BorderSide(color: Colors.pink),
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
                UploadPhotoScreen(),
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
              if (bcaaaa == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Highest Degree',
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
              } else if (workingC.selectedWorkingId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Working',
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
              } else if (organizationName.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Enter Organization Name',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.edcuationdetailss(
                  formData: {
                    "highest_degree": bcaaaa,
                    "pg_degree": bcaaaa,
                    "pg_college_name": masterCollege.text.trim(),
                    "ug_degree": secoudddddd,
                    "ug_college_name": bachelorCollege.text.trim(),
                    "school_name": bachelorCollege.text,
                    "other_education": otherEducationDetails.text,
                    "annual_income": incomeFrom,
                    "working_with": workingC.selectedWorkingId.value,
                    "occupation": occC.selectedOccId.value,
                    "organization_name": organizationName.text,
                    "prev_working_detail": previousWork.text.trim(),
                    "app_step": '10',
                    "step": '10',
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
