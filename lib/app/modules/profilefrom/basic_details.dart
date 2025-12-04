import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/looking_for_controller.dart';
import 'package:vivashri/data/controller/marital_staus.contro.dart';
import 'package:vivashri/data/controller/statecontroller.dart';

class BasicDetailsScreen extends StatefulWidget {
  String? mobielemild;
  BasicDetailsScreen({super.key, this.mobielemild});

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
  final lookingC = Get.put(LookingForController());
  final maritalC = Get.put(MaritalStatusController());
  final stateC = Get.put(StateController());
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController abouttrl = TextEditingController();
  StaperfromController stapercontroller = Get.put(StaperfromController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    });
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
                _buildTopHeader(),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Create profile for:"),
                        Obx(() {
                          return _dropDown(
                            hint: "Select",
                            value: lookingC.selectedName.value,
                            onChanged: (v) => lookingC.onSelect(v!),
                            items: lookingC.lookingList
                                .map((e) => e.name)
                                .toList(),
                          );
                        }),

                        _label("Gender:"),
                        _genderButtons(),
                        _label("Name:"),
                        _textField(),

                        _label("Marital Status:"),
                        Obx(() {
                          return _dropDown(
                            hint: "Select",
                            value: maritalC.selectedName.value,
                            onChanged: (v) => maritalC.onSelect(v!),
                            items: maritalC.maritalList
                                .map((e) => e.name)
                                .toList(),
                          );
                        }),

                        _label("State:"),
                        Obx(() {
                          return _cityc(
                            value: stateC.selectedStateId.value.isEmpty
                                ? null
                                : stateC.selectedStateId.value,

                            onChanged: (v) {
                              stateC.onSelect(v!);
                            },

                            items: stateC.stateList
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

                        _label("Date of Birth:"),
                        Row(
                          children: [
                            Expanded(
                              child: _dropDown(
                                hint: "Date",
                                value: selectedDay,
                                onChanged: (v) =>
                                    setState(() => selectedDay = v),
                                items: List.generate(31, (i) => "${i + 1}"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _dropDown(
                                hint: "Months",
                                value: selectedMonth,
                                onChanged: (v) {
                                  setState(() {
                                    selectedMonth = v;
                                    selectedMonthNumber =
                                        monthNumber[v]; // <-- yaha number mil jayega
                                  });

                                  print("Month Name: $v");
                                  print("Month Number: $selectedMonthNumber");
                                },
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
                                onChanged: (v) =>
                                    setState(() => selectedYear = v),
                                items: List.generate(
                                  60,
                                  (i) => "${DateTime.now().year - 18 - i}",
                                ),
                              ),
                            ),
                          ],
                        ),

                        _label("About:"),
                        _textaboutField(maxLines: 4),

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
          Container(
            height: statusBarHeight,
            width: double.infinity,
            color: ColorResources.primarycolor2,
          ),
        ],
      ),
    );
  }

  Widget _cityc({
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
  // ---------------- TOP HEADER ----------------

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          // LEFT BACK BUTTON
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  // onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 28),
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
                fontSize: 14,
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
    return TextField(
      maxLines: maxLines,
      keyboardType: TextInputType.text,
      decoration: _borderDecoration(),
      controller: nameCtrl,
    );
  }

  Widget _textaboutField({int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: _borderDecoration(),
      controller: abouttrl,
    );
  }

  Map<String, String> monthNumber = {
    "Jan": "1",
    "Feb": "2",
    "Mar": "3",
    "Apr": "4",
    "May": "5",
    "Jun": "6",
    "Jul": "7",
    "Aug": "8",
    "Sep": "9",
    "Oct": "10",
    "Nov": "11",
    "Dec": "12",
  };
  String? selectedMonthNumber;
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
            style: opensansMedium.copyWith(
              color: ColorResources.blackhalka,
              fontSize: 14,
            ),
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
            fontSize: 14,
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
        if (lookingC.selectedName.value == null) {
          Get.snackbar(
            'Error',
            'Please Select Profile',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (gender.isEmpty) {
          Get.snackbar(
            'Error',
            'Please Select Gender',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (nameCtrl.text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please Enter Your Name',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (maritalC.selectedName.value == null) {
          Get.snackbar(
            'Error',
            'Please Select Your Marital Status',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (stateC.selectedName.value == null) {
          Get.snackbar(
            'Error',
            'Please Select Your State',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (selectedDay == null) {
          Get.snackbar(
            'Error',
            'Please Select Your Date',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (selectedMonth == null) {
          Get.snackbar(
            'Error',
            'Please Select Your Month',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (selectedYear == null) {
          Get.snackbar(
            'Error',
            'Please Select Your Year',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (abouttrl.text.isEmpty) {
          Get.snackbar(
            'Error',
            'Please Enter Your About',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          stapercontroller.submitBasicProfile(
            formData: {
              "profile_for": lookingC.selectedId.value,
              "gender": gender,
              "name": nameCtrl.text,
              "marital_status": maritalC.selectedId.value,

              "birth_day": selectedDay,
              "birth_month": selectedMonthNumber,
              "birth_year": selectedYear,
              "birth_state": stateC.selectedStateId.value,
              "about": abouttrl.text,
              "app_step": "1",
              "step": "1",
            },
            mobilenumber: widget.mobielemild,
          );
        }
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
