import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/check_percentage.dart';
import 'package:vivashri/data/controller/eductiondrop.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/occupation.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/data/controller/workingas.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class EditEducationDetailsScreen extends StatefulWidget {
  const EditEducationDetailsScreen({super.key});

  @override
  State<EditEducationDetailsScreen> createState() =>
      _EditEducationDetailsScreenState();
}

class _EditEducationDetailsScreenState
    extends State<EditEducationDetailsScreen> {
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

    if (u.highestDegree != null) {
      controller.setSelectedMainFromApi(u.highestDegree!);
    }
    // bachelorCollege.text = u.ugCollegeName.toString();
    // otherEducationDetails.text = u.otherEducation.toString();
    // masterCollege.text = u.pgCollegeName.toString();
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
          'Edit Education',
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Highest Qualification:"),
                    SizedBox(height: 5),
                    Obx(() {
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
                            print("Main Selected Type: ${value.educationType}");
                            bcaaaa = value.id;
                            idddd = value.educationType;
                            controller.updateFilteredList();
                            setState(() {});
                          },
                        ),
                      );
                    }),
                    // controller.selectedMain.value == null
                    //     ? SizedBox()
                    //     : idddd == 2
                    //     ? _label("Bachelor Degree::")
                    //     : _label("PG Degree::"),

                    // SizedBox(height: 5),
                    // Obx(() {
                    //   if (controller.selectedMain.value == null)
                    //     return SizedBox();

                    //   return Container(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 14,
                    //       vertical: 4,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey.shade400),
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: DropdownButton<EducationModel>(
                    //       isExpanded: true,
                    //       underline: SizedBox(),
                    //       hint: Text(
                    //         "Select",
                    //         style: opensansMedium.copyWith(
                    //           color: ColorResources.blackhalka,
                    //           fontSize: 14,
                    //         ),
                    //       ),
                    //       value: controller.selectedSub.value,
                    //       icon: Icon(Icons.keyboard_arrow_down),

                    //       items: controller.filteredList.map((item) {
                    //         return DropdownMenuItem(
                    //           value: item,
                    //           child: Text(
                    //             item.name,
                    //             style: opensansMedium.copyWith(
                    //               color: ColorResources.blackhalka,
                    //               fontSize: 14,
                    //             ),
                    //           ),
                    //         );
                    //       }).toList(),

                    //       onChanged: (value) {
                    //         controller.selectedSub.value = value;
                    //         secoudddddd = value!.id;
                    //         print("Second Dropdown Selected ID: ${value!.id}");
                    //       },
                    //     ),
                    //   );
                    // }),
                    // SizedBox(height: 0),
                    // _topLabel("College Name"),
                    // _textField(controller: masterCollege),
                    // controller.selectedMain.value == null
                    //     ? SizedBox()
                    //     : bcaaaa == "68cd44430402fd89b727bde0"
                    //     ? SizedBox()
                    //     : _label("Bachelor Degree:"),
                    // bcaaaa == "68cd44430402fd89b727bde0"
                    //     ? SizedBox()
                    //     : Obx(() {
                    //         if (controller.selectedMain.value == null)
                    //           return SizedBox();

                    //         return Container(
                    //           padding: EdgeInsets.symmetric(
                    //             horizontal: 14,
                    //             vertical: 4,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             border: Border.all(color: Colors.grey.shade400),
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           child: DropdownButton<EducationModel>(
                    //             isExpanded: true,
                    //             underline: SizedBox(),
                    //             hint: Text(
                    //               "Select",
                    //               style: opensansMedium.copyWith(
                    //                 color: ColorResources.blackhalka,
                    //                 fontSize: 14,
                    //               ),
                    //             ),
                    //             value: controller.selectedThird.value,
                    //             icon: Icon(Icons.keyboard_arrow_down),

                    //             items: controller.thirdList.map((item) {
                    //               return DropdownMenuItem(
                    //                 value: item,
                    //                 child: Text(
                    //                   item.name,
                    //                   style: opensansMedium.copyWith(
                    //                     color: ColorResources.blackhalka,
                    //                     fontSize: 14,
                    //                   ),
                    //                 ),
                    //               );
                    //             }).toList(),

                    //             onChanged: (value) {
                    //               controller.selectedThird.value = value;

                    //               print(
                    //                 "Third Dropdown Selected ID: ${value!.id}",
                    //               );
                    //             },
                    //           ),
                    //         );
                    //       }),
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
                    // _topLabel("Bachelor College Name"),
                    // _textField(controller: bachelorCollege),

                    // // Other Education Details
                    // _topLabel("Add Other Education Details If Any"),
                    // _multilineField(controller: otherEducationDetails),
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

  final checkpercentagecontroller = Get.put(CheckProfileController());

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              String? profileid = prefs.getString("profileid");
              print('data:::::$bcaaaa');
              stapercontroller.updateedcuationdetailss(
                formData: {
                  "highest_degree": bcaaaa,

                  // "pg_degree": bcaaaa,
                  // "pg_college_name": masterCollege.text.trim(),
                  // "ug_degree": secoudddddd,
                  // "ug_college_name": bachelorCollege.text.trim(),
                  // "school_name": bachelorCollege.text,
                  // "other_education": otherEducationDetails.text,
                },
              );
              await Future.delayed(const Duration(milliseconds: 500));
              await checkpercentagecontroller.checkProfileComplete(
                profileid.toString(),
              );

              Get.back();
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
