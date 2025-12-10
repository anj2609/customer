import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/langunage.dart';
import 'package:vivashri/data/controller/marital_staus.contro.dart';
import 'package:vivashri/data/controller/match_list.dart';
import 'package:vivashri/data/controller/nationality.dart';
import 'package:vivashri/data/controller/occupation.dart';
import 'package:vivashri/data/controller/qualification.dart';
import 'package:vivashri/data/controller/religion.dart';
import 'package:vivashri/data/controller/statecontroller.dart';
import 'package:vivashri/widgets/drawer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class BasicSearchPage extends StatefulWidget {
  final String? hidevalue;
  const BasicSearchPage({super.key, this.hidevalue});

  @override
  State<BasicSearchPage> createState() => _BasicSearchPageState();
}

class _BasicSearchPageState extends State<BasicSearchPage> {
  int selectedTab = 0;
  int gender = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RangeValues ageRange = const RangeValues(18, 60);
  RangeValues heightRange = const RangeValues(120, 183);
  final searchprofileid = TextEditingController();
  final countryC = Get.put(CountryController());
  final eduC = Get.put(EducationController());

  String? maritalStatus;
  String? motherTongue;
  String? religion;
  String? country;
  String? state;
  String? education;
  String? income;
  String? occupation;
  String? manglik;
  final religionC = Get.put(ReligionController());

  List<String> maritalList = [
    "Unmarried",
    "Married",
    "Divorced",
    "Widow",
    "Separated",
  ];

  List<String> motherTongueList = ["Hindi", "English", "Gujarati", "Punjabi"];
  List<String> manglikList = ["Yes", "No", "Manglik"];
  final stateC = Get.put(StateController());
  final maritalC = Get.put(MaritalStatusController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,

      drawer: CustomAppDrawer(),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(w),
                widget.hidevalue == "Hide" ? SizedBox() : _buildTopTabs(),
                widget.hidevalue == "Hide" ? SizedBox() : Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [_buildSearchBox(w)]),
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

  final occC = Get.put(OccupationController());

  Widget _buildTopBar(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color.fromARGB(255, 244, 229, 214),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                  //  _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorResources.blackcolor11,
                  size: 22,
                ),
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 245, 242),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.hidevalue == "Hide" ? "Refine Search" : "Search",
              style: opensansMedium.copyWith(
                fontSize: 17,
                color: ColorResources.blackhalkaa,
              ),
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

  Widget _buildTopTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _tabButton("Basic", 0),
          const SizedBox(width: 10),
          _tabButton("Advanced", 1),
        ],
      ),
    );
  }

  final languageC = Get.put(LanguageController());

  Widget _tabButton(String text, int index) {
    bool isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xfffde9f3) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? ColorResources.primarycolor3
                : Colors.grey.shade400,
            width: 1.4,
          ),
        ),
        child: Text(
          text,
          style: opensansMedium.copyWith(
            color: isSelected ? ColorResources.primarycolor3 : Colors.black,
            fontSize: 15,
          ),
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

  Widget _buildSearchBox(double w) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: const Color(0xffd6287f),
          strokeWidth: 1.5,
          dashPattern: const [5, 8],
        ),
        child: Container(
          width: w,

          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2F9),
            borderRadius: BorderRadius.circular(0),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title("Search Profile Id:"),
              _textField("Search Profile Id", controller: searchprofileid),

              _centerText("---- or ----"),

              _title("Search:"),
              SizedBox(height: 5),
              _genderSelector(),

              const SizedBox(height: 15),
              _title(
                "Age (${ageRange.start.toInt()} - ${ageRange.end.toInt()})",
              ),
              _ageSlider(),

              const SizedBox(height: 10),
              _title(
                "Height (${heightRange.start.toInt()} cm - ${heightRange.end.toInt()} cm)",
              ),
              _heightSlider(),

              const SizedBox(height: 5),
              _label("Marital Status:"),
              Obx(() {
                return _dropDown22(
                  hint: "Select",
                  value: maritalC.selectedName.value,
                  onChanged: (v) => maritalC.onSelect(v!),
                  items: maritalC.maritalList.map((e) => e.name).toList(),
                );
              }),
              _label("Mother Tongue:"),
              Obx(() {
                return _dropdown22(
                  value: languageC.motherselectedLanguageId.value.isEmpty
                      ? null
                      : languageC.motherselectedLanguageId.value,

                  onChanged: (v) {
                    languageC.onSelect22(v!);
                  },

                  items: languageC.languageList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id, // ID based dropdown
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

              // _dropDown(
              //   "Marital Status",
              //   maritalList,
              //   maritalStatus,
              //   (v) => setState(() => maritalStatus = v),
              // ),
              // _dropDown(
              //   "Mother Tongue",
              //   motherTongueList,
              //   motherTongue,
              //   (v) => setState(() => motherTongue = v),
              // ),
              _label("Religion:"),
              Obx(() {
                return _dropdown(
                  value: religionC.selectedId.value.isEmpty
                      ? null
                      : religionC.selectedId.value,

                  onChanged: (v) {
                    religionC.onSelectById(v!);
                  },

                  items: religionC.religionList
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
              _label("Nationality:"),
              Obx(() {
                return _dropdown(
                  value: countryC.selectedCountryId.value.isEmpty
                      ? null
                      : countryC.selectedCountryId.value,

                  onChanged: (v) {
                    countryC.onSelect(v!);
                  },

                  items: countryC.countryList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id, // value = ID
                          child: Text(
                            e.name, // Show country name
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

              _label("State:"),
              Obx(() {
                return _dropdown(
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
              SizedBox(height: 5),
              _label("Highest Qualification"),
              Obx(() {
                return _dropdown(
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
              SizedBox(height: 5),
              _label("Annual Income"),
              _dropdown(
                value: incomeFrom,
                items: buildIncomeItems(fromIncomeKeys),
                onChanged: (v) {
                  setState(() {
                    incomeFrom = v;
                    print('$incomeFrom');
                  });
                },
              ),
              SizedBox(height: 5),
              _label("Occupation"),
              Obx(() {
                return _dropdown(
                  value: occC.selectedOccId.value.isEmpty
                      ? null
                      : occC.selectedOccId.value,

                  onChanged: (v) {
                    occC.onSelect(v!);
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

              _dropDown(
                "Manglik Status",
                manglikList,
                manglik,
                (v) => setState(() => manglik = v),
              ),

              const SizedBox(height: 20),
              _searchBtn(),
            ],
          ),
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

  Widget _dropDown22({
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 8),
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

  Widget _dropdown({
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

  // ----------------------------
  // FIELD TITLE
  // ----------------------------
  Widget _title(String text) {
    return Text(
      text,
      style: opensansMedium.copyWith(
        fontSize: 15,

        color: ColorResources.blackgrey,
      ),
    );
  }

  Widget _textField(String hint, {required TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: opensansMedium.copyWith(
            color: ColorResources.blackgrey,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _centerText(String text) {
    return Center(
      child: Text(
        text,
        style: opensansMedium.copyWith(color: Colors.grey, fontSize: 17),
      ),
    );
  }

  Widget _genderSelector() {
    return Row(
      children: [
        _genderBox("Bride", 0),
        const SizedBox(width: 10),
        _genderBox("Groom", 1),
      ],
    );
  }

  Widget _genderBox(String title, int index) {
    bool active = gender == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => gender = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? Color(0xfffde7f2) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active ? const Color(0xffd6287f) : Colors.grey,
            ),
          ),
          child: Center(
            child: Text(title, style: opensansMedium.copyWith(fontSize: 14)),
          ),
        ),
      ),
    );
  }

  Widget _ageSlider() {
    return RangeSlider(
      values: ageRange,
      min: 18,
      max: 60,
      activeColor: const Color(0xffd6287f),
      onChanged: (val) {
        setState(() => ageRange = val);
        print("Age Range: ${val.start} - ${val.end}");
      },
    );
  }

  Widget _heightSlider() {
    return RangeSlider(
      values: heightRange,
      min: 120,
      max: 183,
      activeColor: const Color(0xffd6287f),
      onChanged: (val) {
        setState(() => heightRange = val);
        print("Height Range: ${val.start} cm - ${val.end} cm");
      },
    );
  }

  Widget _dropDown(
    String title,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(title),
          const SizedBox(height: 6),
          Container(
            height: 45,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: value,
                hint: Text(
                  "-- Select --",
                  style: opensansMedium.copyWith(
                    color: ColorResources.blackhalka,
                    fontSize: 14,
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
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
          ),
        ],
      ),
    );
  }

  final searchC = Get.put(SearchmatchController());

  // ----------------------------
  // SEARCH BUTTON
  // ----------------------------
  Widget _searchBtn() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                searchprofileid.clear();
                motherTongue = null;
                maritalStatus = null;
                manglik = null;
                incomeFrom = null;

                gender = 0;

                ageRange = const RangeValues(18, 60);
                heightRange = const RangeValues(120, 183);

                countryC.selectedCountryId.value = "";
                stateC.selectedStateId.value = "";
                eduC.selectedEduId.value = "";
                occC.selectedOccId.value = "";
                religionC.selectedId.value = "";
                religionC.selectedId.value = "";
                religionC.selectedName.value = "";
                maritalC.selectedId.value = "";
                maritalC.selectedName.value = null;
                languageC.motherselectedLanguageId.value = "";
                languageC.morherselectedLanguageName.value = null;
              });
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: Text(
                "Clear All",
                style: opensansMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (searchprofileid.text.isEmpty) {
                searchC.searchlist(
                  searchgender: gender == 0 ? "Bride" : "Groom",
                  minage: ageRange.start.toString(),
                  maxage: ageRange.end.toString(),
                  minheight: heightRange.start.toString(),
                  maxheight: heightRange.end.toString(),
                  searchLanguage: languageC.motherselectedLanguageId.value,
                  searchMaritalstatus: maritalC.selectedId.value,
                  manglik: manglik,
                  searccountry: countryC.selectedCountryId.value,
                  searcheducation: eduC.selectedEduId.value,
                  searctate: stateC.selectedStateId.value,
                  annualincom: incomeFrom,
                  occupation: occC.selectedOccId.value,
                );
              } else {
                searchC.searchprofileid(profileid: searchprofileid.text);
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
                "Search Now",
                style: opensansMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
