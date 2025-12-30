import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/check_percentage.dart';
import 'package:vivashri/data/controller/citycontroller.dart';
import 'package:vivashri/data/controller/complecxion.dart';
import 'package:vivashri/data/controller/dietcontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/hobbies.dart';
import 'package:vivashri/data/controller/statecontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class HoroscropeEdit extends StatefulWidget {
  const HoroscropeEdit({super.key});

  @override
  State<HoroscropeEdit> createState() => _HoroscropeEditState();
}

class _HoroscropeEditState extends State<HoroscropeEdit> {
  StaperfromController stapercontroller = Get.put(StaperfromController());
  final cityC = Get.put(CityController());

  final hobbyC = Get.put(HobbyController());
  final dietC = Get.put(DietController());

  List<String> selectedHobbies = [];
  final complexionC = Get.put(ComplexionController());
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? diet;
  String? cityOfBirth;
  String manglik = "";
  String? weight;
  String? height;
  String? complexion;
  String? healthInfo;
  String disability = "";
  String? bloodGroup;
  String? selectedHour;
  String? selectedMin;
  String? selectedAmPm = "AM";
  final usercontroller = Get.put(UserDetailController());
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
  final stateC = Get.put(StateController());

  @override
  void initState() {
    super.initState();
    getdata();
    // cityC.fetchCity();
  }

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;

    stateC.selectedStateId.value = u.birthState?.id?.toString() ?? "";
    stateC.selectedName.value = u.birthState?.name ?? "";
    cityC.fetchCity(stateC.selectedStateId.value);
    cityC.selectedCityId.value = u.birthCity!.id.toString();

    cityC.selectedCityName.value = u.birthCity!.name;

    if (u.dob != null) {
      try {
        String apiTime = u.dob.toString(); // "2000-08-08T15:25:00.000Z"
        DateTime dt = DateTime.parse(apiTime);

        /// SET TIME
        selectedHour = (dt.hour == 0)
            ? "12"
            : (dt.hour > 12
                  ? (dt.hour - 12).toString().padLeft(2, '0')
                  : dt.hour.toString().padLeft(2, '0'));

        selectedMin = dt.minute.toString().padLeft(2, "0");
        selectedAmPm = dt.hour >= 12 ? "PM" : "AM";

        /// SET DATE
        selectedDay = dt.day.toString().padLeft(2, "0"); // "08"
        selectedYear = dt.year.toString(); // "2000"

        /// SET MONTH NAME
        selectedMonthNumber = dt.month.toString().padLeft(2, "0"); // "08"
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

    DateTime dob = DateTime.parse(u.dob.toString());

    selectedHour = dob.hour == 0
        ? "12"
        : (dob.hour > 12
              ? (dob.hour - 12).toString().padLeft(2, '0')
              : dob.hour.toString().padLeft(2, '0'));

    int apiMinute = dob.minute;
    selectedMin = normalizeMinute(apiMinute); // <-- AUTO FIX HERE
    selectedAmPm = dob.hour >= 12 ? "PM" : "AM";
  }

  final List<int> validMinutes = [
    0,
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    //38,
    40,
    45,
    50,
    55,
  ];

  String normalizeMinute(int apiMinute) {
    int closest = validMinutes.reduce(
      (a, b) => (apiMinute - a).abs() < (apiMinute - b).abs() ? a : b,
    );
    return closest.toString().padLeft(2, '0');
  }

  String? selectedMonthNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Horoscope',
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
                    _label("State of Birth:"),
                    Obx(() {
                      return _cityc(
                        value: stateC.selectedStateId.value.isEmpty
                            ? null
                            : stateC.selectedStateId.value,

                        onChanged: (v) {
                          stateC.onSelect(v!);
                          cityC.fetchCity(stateC.selectedStateId.value);
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
                    _label("Time of Birth:"),

                    Row(
                      children: [
                        Expanded(
                          child: _dropdown(
                            value: selectedHour,
                            hint: "Hour",
                            items: [
                              "01",
                              "02",
                              "03",
                              "04",
                              "05",
                              "06",
                              "07",
                              "08",
                              "09",
                              "10",
                              "11",
                              "12",
                            ],
                            onChanged: (v) {
                              setState(() => selectedHour = v);
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _dropdown(
                            value: selectedMin,
                            hint: "Min",
                            items: [
                              "00",
                              "05",
                              "10",
                              "15",
                              "20",
                              "25",
                              "30",
                              "35",
                              //  "38",
                              "40",
                              "45",
                              "50",
                              "55",
                            ],

                            onChanged: (v) {
                              setState(() => selectedMin = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),

                        Expanded(
                          child: _dropdown(
                            value: selectedAmPm,
                            hint: "AM",
                            items: ["AM", "PM"],
                            onChanged: (v) {
                              setState(() => selectedAmPm = v);
                            },
                          ),
                        ),
                      ],
                    ),

                    // ---------------- City of Birth ----------------
                    _label("City of Birth:"),
                    Obx(() {
                      return _cityc(
                        value: cityC.selectedCityId.value.isEmpty
                            ? null
                            : cityC.selectedCityId.value,

                        onChanged: (v) {
                          cityC.onSelect(v!);
                        },

                        items: cityC.cityList
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
                            onChanged: (v) => setState(() => selectedDay = v),
                            // FIXED HERE 👇
                            items: List.generate(
                              31,
                              (i) => (i + 1).toString().padLeft(2, '0'),
                            ),
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
                                selectedMonthNumber = monthNumber[v];
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
                            onChanged: (v) => setState(() => selectedYear = v),
                            items: List.generate(
                              (2007 - 1950) + 1,
                              (i) => "${2007 - i}",
                            ),
                          ),
                        ),

                        // Expanded(
                        //   child: _dropDown(
                        //     hint: "Year",
                        //     value: selectedYear,
                        //     onChanged: (v) => setState(() => selectedYear = v),
                        //     items: List.generate(
                        //       60,
                        //       (i) => "${DateTime.now().year - 18 - i}",
                        //     ),
                        //   ),
                        // ),
                      ],
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

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade400),
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

  Widget hobbiesScrollableBox() {
    return Obx(() {
      return Container(
        height: 170,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
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
              children: hobbyC.hobbyList.map((h) {
                bool selected = hobbyC.selectedHobbyIds.contains(h.id);

                return InkWell(
                  onTap: () {
                    hobbyC.toggleHobby(h.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 6,
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
                      h.name, // Name show
                      style: opensansSemiBold.copyWith(
                        fontSize: 13,
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
    });
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

  final checkpercentagecontroller = Get.put(CheckProfileController());

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              String? profileid = prefs.getString("profileid");

              await stapercontroller.updatehobbies(
                formData: {
                  "birth_hour": selectedHour ?? "",
                  "birth_minute": selectedMin ?? "",
                  "birth_am": selectedAmPm ?? "",
                  "birth_city": cityC.selectedCityId.value,
                  "birth_day": selectedDay ?? "",
                  "birth_month": selectedMonthNumber ?? "",
                  "birth_year": selectedYear ?? "",
                  "birth_state": stateC.selectedStateId.value,
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
