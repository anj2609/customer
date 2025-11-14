import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/contact_details.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';

class BasicDetailsScreen extends StatefulWidget {
  const BasicDetailsScreen({super.key});

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  String? selectedProfileFor;
  String? selectedMaritalStatus;
  String? selectedState;

  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  String gender = "";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.red,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(),
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Create profile for:"),
                    _dropDown(
                      hint: "Select",
                      value: selectedProfileFor,
                      onChanged: (v) => setState(() => selectedProfileFor = v),
                      items: [
                        "Self",
                        "Son",
                        "Daughter",
                        "Brother",
                        "Sister",
                        "Relative/Friend",
                      ],
                    ),
                    _label("Gender:"),
                    _genderButtons(),
                    _label("Name:"),
                    _textField(),

                    _label("Marital Status:"),
                    _dropDown(
                      hint: "Select",
                      value: selectedMaritalStatus,
                      onChanged: (v) =>
                          setState(() => selectedMaritalStatus = v),
                      items: ["Single", "Married", "Divorced"],
                    ),

                    _label("State:"),
                    _dropDown(
                      hint: "Select",
                      value: selectedState,
                      onChanged: (v) => setState(() => selectedState = v),
                      items: ["Gujarat", "Maharashtra", "Punjab"],
                    ),

                    _label("Date of Birth:"),
                    Row(
                      children: [
                        Expanded(
                          child: _dropDown(
                            hint: "Date",
                            value: selectedDay,
                            onChanged: (v) => setState(() => selectedDay = v),
                            items: List.generate(31, (i) => "${i + 1}"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropDown(
                            hint: "Months",
                            value: selectedMonth,
                            onChanged: (v) => setState(() => selectedMonth = v),
                            items: [
                              "Jan",
                              "Feb",
                              "Mar",
                              "Apr",
                              "May",
                              "Jun",
                              "Jul",
                              "Aug",
                              "Sep",
                              "Oct",
                              "Nov",
                              "Dec",
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropDown(
                            hint: "Year",
                            value: selectedYear,
                            onChanged: (v) => setState(() => selectedYear = v),
                            items: List.generate(60, (i) => "${1980 + i}"),
                          ),
                        ),
                      ],
                    ),

                    _label("About:"),
                    _textField(maxLines: 4),

                    const SizedBox(height: 25),
                    _continueButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TOP HEADER ----------------

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          // LEFT BACK BUTTON
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: ColorResources.blackcolor,
                  size: 28,
                ),
              ),
            ),
          ),

          // CENTER — Circle + Center Text (No Auto Resize)
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
                        value: 0.25,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "1 of 4",
                      style: TextStyle(
                        color: ColorResources.blackgrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // 👉 Center text remains BIG and fixed-size
                Text(
                  "Basic Details",
                  style: opensansMedium.copyWith(
                    color: ColorResources.blackcolor,
                    fontSize: 18, // fixed big size
                  ),
                ),
              ],
            ),
          ),

          // RIGHT SIDE AUTO RESIZE TEXTS
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
                  "Contact Details",
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
                fontSize: 15,
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

  // ---------------- TEXTFIELD ----------------

  Widget _textField({int maxLines = 1}) {
    return TextField(maxLines: maxLines, decoration: _borderDecoration());
  }

  // ---------------- DROPDOWN ----------------

  Widget _dropDown({
    required String hint,
    required String? value,
    required Function(String?) onChanged,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _boxDecoration(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: opensansMedium.copyWith(color: ColorResources.blackhalka),
          ),
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: opensansMedium.copyWith(
                      color: ColorResources.blackhalka,
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

  // ---------------- GENDER BUTTONS ----------------

  Widget _genderButtons() {
    return Row(
      children: [
        Expanded(
          child: _genderButton(
            "Male",
            gender == "Male",
            () => setState(() => gender = "Male"),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _genderButton(
            "Female",
            gender == "Female",
            () => setState(() => gender = "Female"),
          ),
        ),
      ],
    );
  }

  Widget _genderButton(String text, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected ? Colors.pink.shade50 : Colors.white,
          border: Border.all(
            color: selected
                ? ColorResources.primarycolor3
                : Colors.grey.shade400,
            width: 1.4,
          ),
        ),
        child: Text(
          text,
          style: opensansMedium.copyWith(
            fontSize: 15,
            color: selected ? ColorResources.primarycolor3 : Colors.black87,
            // fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------- CONTINUE BUTTON ----------------

  Widget _continueButton() {
    return GestureDetector(
      onTap: () {
        Get.to(
          ContactDetailsScreen(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [Color(0xFFFBE266B), Color(0xFFEB1D7B)],
          ),
        ),
        child: Center(
          child: Text(
            "Continue",
            style: opensansMedium.copyWith(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  // ---------------- STYLES ----------------

  InputDecoration _borderDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.pink),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade400),
    );
  }
}
