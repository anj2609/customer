import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/complecxion.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/looking_for_controller.dart';
import 'package:vivashri/data/controller/marital_staus.contro.dart';
import 'package:vivashri/data/controller/statecontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class EditBasicDetailsScreen extends StatefulWidget {
  String? mobielemild;
  EditBasicDetailsScreen({super.key, this.mobielemild});

  @override
  State<EditBasicDetailsScreen> createState() => _EditBasicDetailsScreenState();
}

class _EditBasicDetailsScreenState extends State<EditBasicDetailsScreen> {
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
  String? healthInfo;
  List<DropdownMenuItem<String>> buildWeightItems(List<String> keys) {
    return keys
        .map(
          (key) => DropdownMenuItem(
            value: key, // "50"
            child: Text(
              weightRange[key]!,
              style: opensansMedium.copyWith(
                color: ColorResources.blackhalka,
                fontSize: 14,
              ),
            ), // "50 Kg"
          ),
        )
        .toList();
  }

  String? fromWeight;

  List<String> get fromWeightKeys => weightRange.keys.toList();
  List<String> filteredToWeight(String? from) {
    if (from == null) return weightRange.keys.toList();

    int selected = int.parse(from);

    return weightRange.keys.where((k) => int.parse(k) >= selected).toList();
  }

  final usercontroller = Get.put(UserDetailController());

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
    getdata();
  }

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;

    lookingC.selectedName.value = u.profileFor?.name ?? "";
    lookingC.selectedId.value = u.profileFor?.id?.toString() ?? "";

    gender = u.gender ?? "";
    nameCtrl.text = u.name ?? "";

    height = u.height?.toString().trim();

    final match = heights.firstWhere(
      (h) => h["value"]?.toString().trim() == height,
      orElse: () => {"value": ?null},
    );

    setState(() {
      height = match["value"]?.toString();
    });

    String? rawWeight = u.weight?.toString().trim(); // "50.0"

    // Convert "50.0" → "50"
    String cleanedWeight = rawWeight?.contains(".") == true
        ? rawWeight!.split(".").first
        : rawWeight ?? "";

    // tryParse again
    int? apiWeight = int.tryParse(cleanedWeight);

    String? matchedKey;

    if (apiWeight != null) {
      matchedKey = weightRange.keys.firstWhere(
        (k) => int.tryParse(k) == apiWeight,
        orElse: () => "",
      );
    }

    // Debug prints
    print("Raw: $rawWeight");
    print("Cleaned: $cleanedWeight");
    print("Parsed: $apiWeight");
    print("Matched Key: $matchedKey");

    setState(() {
      fromWeight = (matchedKey != null && matchedKey.isNotEmpty)
          ? matchedKey // "50"
          : null;
    });

    maritalC.selectedName.value = u.maritalStatus?.name ?? "";
    maritalC.selectedId.value = u.maritalStatus?.id?.toString() ?? "";

    complexionC.selectedComplexionId.value = u.complexion?.id?.toString() ?? "";
    complexionC.selectedComplexionName.value = u.complexion?.name ?? "";

    healthInfo = u.healthInformation ?? "";
    manglik = u.manglik?.toString() ?? "";
    disability = u.disability?.toString() ?? "";
    bloodGroup = u.bloodGroup?.toString() ?? "";

    stateC.selectedStateId.value = u.birthState?.id?.toString() ?? "";
    stateC.selectedName.value = u.birthState?.name ?? "";

    if (u.dob != null) {
      try {
        DateTime dt = DateTime.parse(u.dob.toString());
        selectedDay = dt.day.toString().padLeft(2, '0');
        selectedMonthNumber = dt.month.toString().padLeft(2, '0');
        selectedYear = dt.year.toString();

        selectedMonth = monthNumber.entries
            .firstWhere(
              (e) => e.value == selectedMonthNumber,
              orElse: () => MapEntry("Jan", "01"),
            )
            .key;
      } catch (e) {
        selectedDay = "";
        selectedMonth = "";
        selectedYear = "";
      }
    }

    abouttrl.text = u.about ?? "";
  }

  final complexionC = Get.put(ComplexionController());

  String? height;
  String manglik = "";
  String? bloodGroup;
  final Map<String, String> monthNumber = {
    "Jan": "01",
    "Feb": "02",
    "Mar": "03",
    "Apr": "04",
    "May": "05",
    "Jun": "06",
    "Jul": "07",
    "Aug": "08",
    "Sep": "09",
    "Oct": "10",
    "Nov": "11",
    "Dec": "12",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Basic Details',
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //  _buildTopHeader(),
            // Divider(),
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
                        items: lookingC.lookingList.map((e) => e.name).toList(),
                      );
                    }),

                    _label("Gender:"),
                    _genderButtons(),
                    _label("Name:"),
                    _textField(),
                    _label("Height:"),
                    _dropdown22(
                      value: height,
                      items: heights
                          .map(
                            (h) => DropdownMenuItem(
                              value: h["value"], // value = 8.6
                              child: Text(
                                h["label"]!,
                                style: opensansMedium.copyWith(
                                  color: ColorResources.blackhalka,
                                  fontSize: 14,
                                ),
                              ), // label = 8 ft 6 in
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => height = v);
                        print(
                          "Selected Height Value: $v",
                        ); // yaha 8.6 print hoga
                      },
                    ),
                    _label("Weight (in Kg):"),
                    _dropdown22(
                      value: fromWeight,
                      items: buildWeightItems(fromWeightKeys),
                      onChanged: (v) {
                        setState(() {
                          fromWeight = v;
                        });
                      },
                    ),

                    _label("Marital Status:"),
                    Obx(() {
                      return _dropDown(
                        hint: "Select",
                        value: maritalC.selectedName.value,
                        onChanged: (v) => maritalC.onSelect(v!),
                        items: maritalC.maritalList.map((e) => e.name).toList(),
                      );
                    }),
                    _label("Complexion"),
                    Obx(() {
                      return _dropdown22(
                        value: complexionC.selectedComplexionId.value.isEmpty
                            ? null
                            : complexionC.selectedComplexionId.value,

                        onChanged: (v) {
                          complexionC.onSelect(v!);
                        },

                        items: complexionC.complexionList
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
                    _label("Health Information:"),
                    _dropdown(
                      value: healthInfo,
                      items: [
                        "No Health Problems",
                        "Average",
                        "Weak",
                        "Diabetes",
                        "HIV Positive",
                        "Low BP",
                        "High BP",
                        "Heart Ailments",
                        "Others",
                      ],
                      onChanged: (v) => setState(() => healthInfo = v),
                    ),
                    _label("Manglik Status:"),
                    _manglikButtons(),

                    // _label("State:"),
                    // Obx(() {
                    //   return _cityc(
                    //     value: stateC.selectedStateId.value.isEmpty
                    //         ? null
                    //         : stateC.selectedStateId.value,

                    //     onChanged: (v) {
                    //       stateC.onSelect(v!);
                    //     },

                    //     items: stateC.stateList
                    //         .map(
                    //           (e) => DropdownMenuItem(
                    //             value: e.id,
                    //             child: Text(
                    //               e.name,
                    //               style: opensansMedium.copyWith(
                    //                 color: ColorResources.blackhalka,
                    //                 fontSize: 14,
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //         .toList(),
                    //   );
                    // }),

                    //  _label("Date of Birth:"),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: _dropDown(
                    //         hint: "Date",
                    //         value: selectedDay,
                    //         onChanged: (v) => setState(() => selectedDay = v),
                    //         // FIXED HERE 👇
                    //         items: List.generate(
                    //           31,
                    //           (i) => (i + 1).toString().padLeft(2, '0'),
                    //         ),
                    //       ),
                    //     ),

                    //     const SizedBox(width: 10),

                    //     Expanded(
                    //       child: _dropDown(
                    //         hint: "Months",
                    //         value: selectedMonth,
                    //         onChanged: (v) {
                    //           setState(() {
                    //             selectedMonth = v;
                    //             selectedMonthNumber = monthNumber[v];
                    //           });

                    //           print("Month Name: $v");
                    //           print("Month Number: $selectedMonthNumber");
                    //         },
                    //         items: [
                    //           "Jan",
                    //           "Feb",
                    //           "Mar",
                    //           "Apr",
                    //           "May",
                    //           "Jun",
                    //           "Jul",
                    //           "Aug",
                    //           "Sep",
                    //           "Oct",
                    //           "Nov",
                    //           "Dec",
                    //         ],
                    //       ),
                    //     ),

                    //     const SizedBox(width: 10),
                    //     Expanded(
                    //       child: _dropDown(
                    //         hint: "Year",
                    //         value: selectedYear,
                    //         onChanged: (v) => setState(() => selectedYear = v),
                    //         items: List.generate(
                    //           (DateTime.now().year - 1900) + 1,
                    //           (i) => "${DateTime.now().year - i}",
                    //         ),
                    //       ),
                    //     ),

                    // Expanded(
                    //   child: _dropDown(
                    //     hint: "Year",
                    //     value: selectedYear,
                    //     onChanged: (v) => setState(() => selectedYear = v),
                    //     items: List.generate(
                    //       60,
                    //       (i) => "${DateTime.now().year - 18 - i}",
                    //     ),//
                    //   ),
                    // ),
                    //   ],
                    // ),
                    _label("About:"),
                    _textaboutField(maxLines: 4),
                    _label("Any Disability:"),
                    _disabilityButtons(),
                    _label("Blood Group:"),
                    _dropdown(
                      value: bloodGroup,
                      items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
                      onChanged: (v) => setState(() => bloodGroup = v),
                    ),

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

  String disability = "";

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
          icon: Icon(Icons.keyboard_arrow_down),
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
        stapercontroller.updateedcuationdetailss(
          formData: {
            "profile_for": lookingC.selectedId.value,
            "gender": gender,
            "name": nameCtrl.text,
            "marital_status": maritalC.selectedId.value,
            "weight": fromWeight,
            "height": height,
            "health_information": healthInfo,
            "complexion": complexionC.selectedComplexionId.value,
            // "birth_day": selectedDay,
            // "birth_month": selectedMonthNumber,
            "manglik": manglik,
            "disability": disability,
            "blood_group": bloodGroup,
            // "birth_year": selectedYear,
            //"birth_state": stateC.selectedStateId.value,
            "about": abouttrl.text,
            // "app_step": "1",
            // "step": "1",
          },
          ///////////////////// mobilenumber: widget.mobielemild,
        );  Future.delayed(const Duration(microseconds: 1000), () {
                Get.back();
              });
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
            "Update",
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
