import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/partner_basic_details2.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';

class PartnerBasicDetailsScreen extends StatefulWidget {
  const PartnerBasicDetailsScreen({super.key});

  @override
  State<PartnerBasicDetailsScreen> createState() =>
      _PartnerBasicDetailsScreenState();
}

class _PartnerBasicDetailsScreenState extends State<PartnerBasicDetailsScreen> {
  // AGE RANGE
  String? fromAge = "18 Years";
  String? toAge = "30 Years";

  // WEIGHT
  String? fromWeight = "50 Kg";
  String? toWeight = "70 Kg";

  // HEIGHT
  String? fromHeight = "4 fit";
  String? toHeight = "6.2 fit";

  // DROPDOWNS
  String? complexion;
  String? language;
  String? children;
  String? motherTongue;

  // MARITAL STATUS BUTTON
  String maritalStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
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
                          "Provide partner’s basic details:",
                          style: opensansMedium.copyWith(
                            fontSize: 16,

                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ---------------- AGE RANGE ----------------
                    _label("Age Range:"),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown(
                            value: fromAge,
                            items: [
                              "18 Years",
                              "20 Years",
                              "22 Years",
                              "25 Years",
                            ],
                            onChanged: (v) => setState(() => fromAge = v),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("To"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropdown(
                            value: toAge,
                            items: [
                              "25 Years",
                              "28 Years",
                              "30 Years",
                              "35 Years",
                            ],
                            onChanged: (v) => setState(() => toAge = v),
                          ),
                        ),
                      ],
                    ),

                    _label("Body Weight:"),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown(
                            value: fromWeight,
                            items: ["40 Kg", "45 Kg", "50 Kg", "55 Kg"],
                            onChanged: (v) => setState(() => fromWeight = v),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("To"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropdown(
                            value: toWeight,
                            items: ["60 Kg", "65 Kg", "70 Kg", "80 Kg"],
                            onChanged: (v) => setState(() => toWeight = v),
                          ),
                        ),
                      ],
                    ),

                    _label("Height Range:"),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown(
                            value: fromHeight,
                            items: ["4 fit", "4.5 fit", "5 fit"],
                            onChanged: (v) => setState(() => fromHeight = v),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("To"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropdown(
                            value: toHeight,
                            items: ["5.5 fit", "6 fit", "6.2 fit"],
                            onChanged: (v) => setState(() => toHeight = v),
                          ),
                        ),
                      ],
                    ),

                    _label("Complexion:"),
                    _dropdown(
                      value: complexion,
                      items: ["Fair", "Medium", "Dark"],
                      onChanged: (v) => setState(() => complexion = v),
                    ),

                    // ---------------- LANGUAGE ----------------
                    _label("Languages Known:"),
                    _dropdown(
                      value: language,
                      items: ["English", "Hindi", "Gujarati", "Punjabi"],
                      onChanged: (v) => setState(() => language = v),
                    ),

                    // ---------------- MARITAL STATUS ----------------
                    _label("Marital Status:"),
                    Row(
                      children: [
                        _selectButton(
                          "Married",
                          maritalStatus == "Married",
                          () {
                            setState(() => maritalStatus = "Married");
                          },
                        ),
                        const SizedBox(width: 12),
                        _selectButton(
                          "Unmarried",
                          maritalStatus == "Unmarried",
                          () {
                            setState(() => maritalStatus = "Unmarried");
                          },
                        ),
                      ],
                    ),

                    // ---------------- CHILDREN ----------------
                    _label("Have Children:"),
                    _dropdown(
                      value: children,
                      items: ["No", "Yes (1)", "Yes (2)"],
                      onChanged: (v) => setState(() => children = v),
                    ),

                    // ---------------- MOTHER TONGUE ----------------
                    _label("Mother Tongue:"),
                    _dropdown(
                      value: motherTongue,
                      items: ["Hindi", "Gujarati", "Marathi", "Punjabi"],
                      onChanged: (v) => setState(() => motherTongue = v),
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
                  "Partner’s Qualities",
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
                        value: 0.72,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "13 of 18",
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
                  "Partner’s Basic Details",
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
                  "Partner’s Family Det.",
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
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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

  // ---------------- SELECT BUTTON ----------------
  Widget _selectButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected ? Colors.pink.shade50 : Colors.white,
            border: Border.all(
              color: selected ? Colors.pink : Colors.grey.shade400,
              width: 1.3,
            ),
          ),
          child: Text(
            label,
            style: opensansMedium.copyWith(
              color: selected ? Colors.pink : Colors.black87,

              fontSize: 14,
            ),
          ),
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
              Get.to(
                PartnerFamilyDetailsScreen(),
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
