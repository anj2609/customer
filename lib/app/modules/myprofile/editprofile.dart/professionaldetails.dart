import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/eductiondrop.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/occupation.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/data/controller/workingas.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class EditProfessionalDetails extends StatefulWidget {
  const EditProfessionalDetails({super.key});

  @override
  State<EditProfessionalDetails> createState() =>
      _EditProfessionalDetailsState();
}

class _EditProfessionalDetailsState extends State<EditProfessionalDetails> {
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

  @override
  void initState() {
    super.initState();
    getdata();
  }

  final usercontroller = Get.put(UserDetailController());
  final controller222 = Get.put(EducationController22222());

  void getdata() async {
    await controller222.fetchEducation();
    final u = usercontroller.userData.value;
    if (u == null) return;
    incomeFrom = u.annualIncome;
    workingC.selectedWorkingId.value = u.workingWith!.id.toString();
    workingC.selectedWorkingName.value = u.workingWith!.name;
    occC.selectedOccId.value = u.occupation!.id.toString();
    occC.selectedOccName.value = u.occupation!.name;
    organizationName.text = u.organizationName.toString();
    setState(() {});
  }

  dynamic idddd;
  dynamic bcaaaa;
  dynamic secoudddddd;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Professional Details',
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
                    const SizedBox(height: 15),

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

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              stapercontroller.updateedcuationdetailss(
                formData: {
                  // "highest_degree": bcaaaa,
                  // "pg_degree": bcaaaa,
                  // "pg_college_name": masterCollege.text.trim(),
                  // "ug_degree": secoudddddd,
                  // "ug_college_name": bachelorCollege.text.trim(),
                  // "school_name": bachelorCollege.text,
                  // "other_education": otherEducationDetails.text,
                  "annual_income": incomeFrom,
                  "working_with": workingC.selectedWorkingId.value,
                  "occupation": occC.selectedOccId.value,
                  "organization_name": organizationName.text,
                },
              );
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
