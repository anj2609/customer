import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/more_details.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';

class FamilyDetailsScreen extends StatefulWidget {
  const FamilyDetailsScreen({super.key});

  @override
  State<FamilyDetailsScreen> createState() => _FamilyDetailsScreenState();
}

class _FamilyDetailsScreenState extends State<FamilyDetailsScreen> {
  String familyType = "";
  String familyValue = "";

  String? noOfSister;
  String? marriedSister;
  String? noOfBrother;
  String? marriedBrother;
  String? noOfSisterInLaw;
  String? noOfBrotherInLaw;
  String? totalFamilyMember;
  StaperfromController stapercontroller = Get.put(StaperfromController());

  List<String> getMarriedSisterList() {
    if (noOfSister == null) return ["0"];

    int count = int.tryParse(noOfSister!) ?? 0;

    return List.generate(count + 1, (i) => "$i");
  }

  List<String> getMarriedBrotherList() {
    if (noOfBrother == null) return ["0"];

    int count = int.tryParse(noOfBrother!) ?? 0;

    return List.generate(count + 1, (i) => "$i");
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
                        _label("Family Type:"),
                        _familyTypeButtons(),

                        _label("Family Value:"),
                        _familyValueButtons(),

                        _label("No. of Sister:"),
                        _dropdown(
                          value: noOfSister,
                          items: [
                            "0",
                            "1",
                            "2",
                            "3",
                            "4",
                            "5",
                            "6",
                            "7",
                            "8",
                            "9",
                          ],
                          onChanged: (v) {
                            setState(() {
                              noOfSister = v;
                              marriedSister = "0";
                            });
                          },
                        ),

                        _label("Married Sister:"),

                        _dropdown(
                          value: marriedSister,
                          items: getMarriedSisterList(),
                          onChanged: (v) {
                            setState(() => marriedSister = v);
                          },
                        ),

                        _label("No. of Brother:"),
                        _dropdown(
                          value: noOfBrother,
                          items: [
                            "0",
                            "1",
                            "2",
                            "3",
                            "4",
                            "5",
                            "6",
                            "7",
                            "8",
                            "9",
                          ],
                          onChanged: (v) {
                            setState(() {
                              noOfBrother = v;
                              marriedBrother = "0"; // Reset married brother
                            });
                          },
                        ),

                        _label("Married Brother:"),
                        _dropdown(
                          value: marriedBrother,
                          items: getMarriedBrotherList(), // 🔥 Dynamic items
                          onChanged: (v) {
                            setState(() => marriedBrother = v);
                          },
                        ),

                        _label("No. of Sister in Law:"),
                        _dropdown(
                          value: noOfSisterInLaw,
                          items: [
                            "0",
                            "1",
                            "2",
                            "3",
                            "4",
                            "5",
                            "6",
                            "7",
                            "8",
                            "9",
                          ],
                          onChanged: (v) => setState(() => noOfSisterInLaw = v),
                        ),

                        _label("No. of Brother in Law:"),
                        _dropdown(
                          value: noOfBrotherInLaw,
                          items: [
                            "0",
                            "1",
                            "2",
                            "3",
                            "4",
                            "5",
                            "6",
                            "7",
                            "8",
                            "9",
                          ],
                          onChanged: (v) =>
                              setState(() => noOfBrotherInLaw = v),
                        ),

                        _label("Total Family Member:"),
                        _dropdown(
                          value: totalFamilyMember,
                          items: [
                            "0",
                            "1",
                            "2",
                            "3",
                            "4",
                            "5",
                            "6",
                            "7",
                            "8",
                            "9",
                          ],
                          onChanged: (v) =>
                              setState(() => totalFamilyMember = v),
                        ),

                        const SizedBox(height: 30),
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
                  "Location Details",
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
                        value: 0.33,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "8 of 18",
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
                  "Family Details",
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

  // ------------------- FAMILY TYPE -------------------
  Widget _familyTypeButtons() {
    return Row(
      children: [
        _typeButton("Joint", familyType == "Joint", () {
          setState(() => familyType = "Joint");
        }),
        const SizedBox(width: 12),
        _typeButton("Nuclear", familyType == "Nuclear", () {
          setState(() => familyType = "Nuclear");
        }),
      ],
    );
  }

  Widget _typeButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? ColorResources.primarycolor3
                  : Colors.grey.shade400,
              width: 1.4,
            ),
            color: selected ? Colors.pink.shade50 : Colors.white,
          ),
          child: Text(
            label,
            style: opensansMedium.copyWith(
              fontSize: 14,
              //fontWeight: FontWeight.w600,
              color: selected ? ColorResources.primarycolor3 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------- FAMILY VALUE BUTTONS -------------------
  Widget _familyValueButtons() {
    final values = ["Orthodox", "Traditional", "Moderate", "Liberal"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values.map((v) {
        bool selected = familyValue == v;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 5),
            child: InkWell(
              onTap: () => setState(() => familyValue = v),
              child: Container(
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selected ? Colors.pink.shade50 : Colors.white,
                  border: Border.all(
                    color: selected
                        ? ColorResources.primarycolor3
                        : Colors.grey.shade400,
                    width: 1.3,
                  ),
                ),
                child: Text(
                  v,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? ColorResources.primarycolor3
                        : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ------------------- DROPDOWN -------------------
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
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
          icon: Icon(Icons.keyboard_arrow_down),
          value: value,
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
              stapercontroller.familydeatilsProfile(
                formData: {
                  "family_type": familyType,
                  "family_value": familyValue,
                  "no_of_sister": noOfSister,
                  "married_sister": marriedSister,
                  "no_of_brother": noOfBrother,
                  "married_brother": marriedBrother,
                  "no_of_sister_in_law": noOfSisterInLaw,
                  "no_of_brother_in_law": noOfBrotherInLaw,
                  "total_family": totalFamilyMember,
                  "app_step": '8',
                  "step": '8',
                },
              );
              // Get.to(
              //   MoreDetailsScreen(),
              //   duration: Duration(
              //     milliseconds: ApiConstants.screenTransitionTime,
              //   ),
              //   transition: Transition.rightToLeft,
              // );
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
