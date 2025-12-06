import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/occupation.dart';
import 'package:vivashri/data/controller/professional.dart';
import 'package:vivashri/data/controller/qualification.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/data/controller/workingas.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class Editpartnereduction extends StatefulWidget {
  const Editpartnereduction({super.key});

  @override
  State<Editpartnereduction> createState() => _EditpartnereductionState();
}

class _EditpartnereductionState extends State<Editpartnereduction> {
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
  void initState() {
    super.initState();
    getdata();
  }

  final usercontroller = Get.put(UserDetailController());

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;
    eduC.selectedEduId.value = u.partnerEducation!.id.toString();
    eduC.selectedEduName.value = u.partnerEducation!.name;
    profEduC.selectedProfEduId.value = u.partnerProfessionalQualification!.id
        .toString();
    profEduC.selectedProfEduName.value =
        u.partnerProfessionalQualification!.name;

    occC.selectedOccId2.value = u.partnerOccupation!.id.toString();
    occC.selectedOccName2.value = u.partnerOccupation!.name;

    workingC.selectedWorkingId2.value = u.partnerWorkingAs!.id.toString();
    workingC.selectedWorkingName2.value = u.partnerWorkingAs!.name;

    incomeFrom = u.partnerIncomeFrom.toString();
    incomeTo = u.partnerIncomeTo.toString();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Partner’s Education & Career',
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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

  // ---------------- DROPDOWN ----------------

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              stapercontroller.updatepartnerotherdetails(
                formData: {
                  "partner_education": eduC.selectedEduId.value,
                  "partner_professional_qualification":
                      profEduC.selectedProfEduId.value,
                  "partner_occupation": occC.selectedOccId2.value,
                  "partner_working_as": workingC.selectedWorkingId2.value,
                  "partner_income_from": incomeFrom,
                  "partner_income_to": incomeTo,
                  // "app_step": '16',
                  // "step": '16',
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
