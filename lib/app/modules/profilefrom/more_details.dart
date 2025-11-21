import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/education_details.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';

class MoreDetailsScreen extends StatefulWidget {
  const MoreDetailsScreen({super.key});

  @override
  State<MoreDetailsScreen> createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  // Hobbies Selection
  List<String> hobbies = [
    "Reading",
    "Cooking",
    "Painting",
    "Fitness",
    "Social Work",
    "Travelling",
    "Watching Movies",
    "Music",
    "Others",
  ];

  List<String> selectedHobbies = [];

  String? diet;
  String? cityOfBirth;
  String manglik = "";
  String? weight;
  String? height;
  String? complexion;
  String? healthInfo;
  String disability = "";
  String? bloodGroup;

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
                    // ---------------- HOBBIES ----------------
                    _label("Hobbies:"),
                    _hobbiesScrollableBox(),

                    // ---------------- DIET ----------------
                    _label("Diet:"),
                    _dropdown(
                      value: diet,
                      items: ["Veg", "Non-Veg", "Jain", "Vegan"],
                      onChanged: (v) => setState(() => diet = v),
                    ),

                    // ---------------- TIME OF BIRTH ----------------
                    _label("Time of Birth: *"),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown(
                            value: null,
                            hint: "Hour",
                            items: ["01", "02", "03", "04", "05", "06", "07"],
                            onChanged: (v) {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropdown(
                            value: null,
                            hint: "Min",
                            items: ["00", "10", "20", "30", "40", "50"],
                            onChanged: (v) {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropdown(
                            value: null,
                            hint: "Am",
                            items: ["AM", "PM"],
                            onChanged: (v) {},
                          ),
                        ),
                      ],
                    ),

                    // ---------------- City of Birth ----------------
                    _label("City of Birth: *"),
                    _dropdown(
                      value: cityOfBirth,
                      items: ["Delhi", "Mumbai", "Ahmedabad"],
                      onChanged: (v) => setState(() => cityOfBirth = v),
                    ),

                    // ---------------- Manglik ----------------
                    _label("Manglik Status: *"),
                    _manglikButtons(),

                    // ---------------- Weight ----------------
                    _label("Weight (in Kg): *"),
                    _dropdown(
                      value: weight,
                      items: ["40", "45", "50", "55", "60", "65", "70", "80"],
                      onChanged: (v) => setState(() => weight = v),
                    ),

                    // ---------------- Height ----------------
                    _label("Height: *"),
                    _dropdown(
                      value: height,
                      items: ["5.0", "5.2", "5.4", "5.6", "5.8", "6.0"],
                      onChanged: (v) => setState(() => height = v),
                    ),

                    // ---------------- Complexion ----------------
                    _label("Complexion: *"),
                    _dropdown(
                      value: complexion,
                      items: ["Fair", "Medium", "Dark"],
                      onChanged: (v) => setState(() => complexion = v),
                    ),

                    // ---------------- Health Info ----------------
                    _label("Health Information: *"),
                    _dropdown(
                      value: healthInfo,
                      items: ["Fit", "Average", "Weak"],
                      onChanged: (v) => setState(() => healthInfo = v),
                    ),

                    // ---------------- Disability ----------------
                    _label("Any Disability: *"),
                    _disabilityButtons(),

                    // ---------------- Blood Group ----------------
                    _label("Blood Group: *"),
                    _dropdown(
                      value: bloodGroup,
                      items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+"],
                      onChanged: (v) => setState(() => bloodGroup = v),
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
                  "Family Details",
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
                        value: 0.50,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "9 of 18",
                      style: opensansMedium.copyWith(
                        color: ColorResources.blackgrey,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Text(
                  "More Details",
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
                  "Education Details",
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

  // ---------------- HOBBIES SCROLLABLE BOX ----------------
  Widget _hobbiesScrollableBox() {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        thickness: 5,
        radius: const Radius.circular(8),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: hobbies.map((hobby) {
              bool selected = selectedHobbies.contains(hobby);
              return InkWell(
                onTap: () {
                  setState(() {
                    if (selected) {
                      selectedHobbies.remove(hobby);
                    } else {
                      selectedHobbies.add(hobby);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
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
                    hobby,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? ColorResources.primarycolor3
                          : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ---------------- DROPDOWN ----------------
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

  Widget _manglikButtons() {
    return Row(
      children: [
        // YES → SMALL
        Expanded(
          flex: 1,
          child: _manglikButton("Yes", manglik == "Yes", () {
            setState(() => manglik = "Yes");
          }),
        ),

        const SizedBox(width: 10),

        // NO → SMALL
        Expanded(
          flex: 1,
          child: _manglikButton("No", manglik == "No", () {
            setState(() => manglik = "No");
          }),
        ),

        const SizedBox(width: 10),

        // Angshik Manglik → LARGE
        Expanded(
          flex: 2,
          child: _manglikButton(
            "Angshik Manglik",
            manglik == "Angshik Manglik",
            () {
              setState(() => manglik = "Angshik Manglik");
            },
          ),
        ),
      ],
    );
  }

  Widget _manglikButton(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
          label,
          textAlign: TextAlign.center,
          style: opensansMedium.copyWith(
            fontSize: 14,
            // fontWeight: FontWeight.w600,
            color: selected ? ColorResources.primarycolor3 : Colors.black87,
          ),
        ),
      ),
    );
  }

  // ---------------- MANGLIK BUTTONS ----------------
  // Widget _manglikButtons() {
  //   return Row(
  //     children: [
  //       _selectButton("Yes", manglik == "Yes", () {
  //         setState(() => manglik = "Yes");
  //       }),
  //       const SizedBox(width: 10),
  //       _selectButton("No", manglik == "No", () {
  //         setState(() => manglik = "No");
  //       }),
  //       const SizedBox(width: 10),
  //       _selectButton("Angshik Manglik", manglik == "Angshik Manglik", () {
  //         setState(() => manglik = "Angshik Manglik");
  //       }),
  //     ],
  //   );
  // }

  // ---------------- DISABILITY BUTTONS ----------------
  Widget _disabilityButtons() {
    return Row(
      children: [
        _selectButton("None", disability == "None", () {
          setState(() => disability = "None");
        }),
        const SizedBox(width: 15),
        _selectButton("Physical disability", disability == "PD", () {
          setState(() => disability = "PD");
        }),
      ],
    );
  }

  // ---------------- SELECT BUTTON COMPONENT ----------------
  Widget _selectButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? ColorResources.primarycolor3
                  : Colors.grey.shade400,
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(10),
            color: selected ? Colors.pink.shade50 : Colors.white,
          ),
          child: Text(
            label,
            style: opensansMedium.copyWith(
              fontSize: 14,
              // fontWeight: FontWeight.w600,
              color: selected ? ColorResources.primarycolor3 : Colors.black87,
            ),
            textAlign: TextAlign.center,
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
                EducationDetailsScreen(),
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
