import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/citycontroller.dart';
import 'package:vivashri/data/controller/complecxion.dart';
import 'package:vivashri/data/controller/dietcontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/hobbies.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

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
  StaperfromController stapercontroller = Get.put(StaperfromController());
  final cityC = Get.put(CityController());

  final hobbyC = Get.put(HobbyController());
  final dietC = Get.put(DietController());

  List<String> selectedHobbies = [];
  final complexionC = Get.put(ComplexionController());

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
  @override
  void initState() {
    super.initState();
    hobbyC.fetchHobbies();
    dietC.fetchDiet();
    cityC.fetchCity('68cd23efc04fec5457f4a866');
  }

  List<DropdownMenuItem<String>> buildWeightItems(List<String> keys) {
    return keys
        .map(
          (key) => DropdownMenuItem(
            value: key, // "55"
            child: Text(
              weightRange[key]!,
              style: opensansMedium.copyWith(
                color: ColorResources.blackhalka,
                fontSize: 14,
              ),
            ), // "55 Kg"
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
                        // ---------------- HOBBIES ----------------
                        _label("Hobbies:"),
                        hobbiesScrollableBox(),

                        // ---------------- DIET ----------------
                        _label("Diet"),
                        Obx(() {
                          return _dropdown22(
                            value: dietC.selectedDietId.value.isEmpty
                                ? null
                                : dietC.selectedDietId.value,

                            onChanged: (v) {
                              dietC.onSelect(v!);
                            },

                            items: dietC.dietList
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

                        // ---------------- TIME OF BIRTH ----------------
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

                        // ---------------- Manglik ----------------
                        _label("Manglik Status:"),
                        _manglikButtons(),

                        // ---------------- Weight ----------------
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
                        // _dropdown(
                        //   value: weight,
                        //   items: [
                        //     "40",
                        //     "41",
                        //     "42",
                        //     "43",
                        //     "44",
                        //     "45",
                        //     "46",
                        //     "47",
                        //     "48",
                        //     "49",
                        //     "50",
                        //     "51",
                        //     "52",
                        //     "53",
                        //     "54",
                        //     "55",
                        //     "56",
                        //     "57",
                        //     "58",
                        //     "59",
                        //     "60",
                        //     "61",
                        //     "62",
                        //     "63",
                        //     "64",
                        //     "65",
                        //     "66",
                        //     "67",
                        //     "68",
                        //     "69",
                        //     "70",
                        //     "71",
                        //     "72",
                        //     "73",
                        //     "74",
                        //     "75",
                        //     "76",
                        //     "77",
                        //     "78",
                        //     "79",
                        //     "80",
                        //     "81",
                        //     "82",
                        //     "83",
                        //     "84",
                        //     "85",
                        //     "86",
                        //     "87",
                        //     "88",
                        //     "89",
                        //     "90",
                        //     "91",
                        //     "92",
                        //     "93",
                        //     "94",
                        //     "95",
                        //     "96",
                        //     "97",
                        //     "98",
                        //     "99",
                        //     "100",
                        //     "101",
                        //     "102",
                        //     "103",
                        //     "104",
                        //     "105",
                        //     "106",
                        //     "107",
                        //     "108",
                        //     "109",
                        //     "110",
                        //     "111",
                        //     "112",
                        //     "113",
                        //     "114",
                        //     "115",
                        //     "116",
                        //     "117",
                        //     "118",
                        //     "119",
                        //     "120",
                        //     "121",
                        //     "122",
                        //     "123",
                        //     "124",
                        //     "125",
                        //     "126",
                        //     "127",
                        //     "128",
                        //     "129",
                        //     "130",
                        //     "131",
                        //     "132",
                        //     "133",
                        //     "134",
                        //     "135",
                        //     "136",
                        //     "137",
                        //     "138",
                        //     "139",
                        //     "140",
                        //     "141",
                        //     "142",
                        //     "143",
                        //     "144",
                        //     "145",
                        //     "146",
                        //     "147",
                        //     "148",
                        //     "149",
                        //     "150",
                        //   ],

                        //   onChanged: (v) => setState(() => weight = v),
                        // ),

                        // ---------------- Height ----------------
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

                        // ---------------- Complexion ----------------
                        _label("Complexion"),
                        Obx(() {
                          return _dropdown22(
                            value:
                                complexionC.selectedComplexionId.value.isEmpty
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

                        // ---------------- Health Info ----------------
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

                        // ---------------- Disability ----------------
                        _label("Any Disability:"),
                        _disabilityButtons(),

                        // ---------------- Blood Group ----------------
                        _label("Blood Group:"),
                        _dropdown(
                          value: bloodGroup,
                          items: [
                            "A+",
                            "A-",
                            "B+",
                            "B-",
                            "O+",
                            "O-",
                            "AB+",
                            "AB-",
                          ],
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
                        value: 0.40,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "9 of 18",
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
              if (hobbyC.selectedHobbyIds.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Hobbies ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (dietC.selectedDietId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Diet ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (selectedHour == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Time of Birth ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (selectedMin == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Time of Birth ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (cityC.selectedCityId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your City of Birth ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (manglik == "") {
                Get.snackbar(
                  'Error',
                  'Please Select Your Manglik Status ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (fromWeight == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Weight (in kg) ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (height == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Height',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (complexionC.selectedComplexionId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Complexion',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (healthInfo == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Health Information',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (disability == "") {
                Get.snackbar(
                  'Error',
                  'Please Select Any Disability',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (bloodGroup == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Blood Group',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.moredetailsapi(
                  formData: {
                    "health_information": healthInfo,
                    "disability": disability,
                    "blood_group": bloodGroup,
                    "diet": dietC.selectedDietId.value,
                    "birth_hour": selectedHour,
                    "birth_minute": selectedMin,
                    "birth_am": selectedAmPm,
                    "birth_city": cityC.selectedCityId.value,
                    "manglik": manglik,
                    "weight": fromWeight,
                    "height": height,
                    "complexion": complexionC.selectedComplexionId.value,
                    "app_step": '9',
                    "step": '9',
                  },
                  selected: hobbyC.selectedHobbyIds,
                );
              }
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
