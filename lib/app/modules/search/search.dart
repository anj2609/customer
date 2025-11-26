import 'package:flutter/material.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/widgets/drawer.dart';
import 'package:dotted_border/dotted_border.dart';

class BasicSearchPage extends StatefulWidget {
  const BasicSearchPage({super.key});

  @override
  State<BasicSearchPage> createState() => _BasicSearchPageState();
}

class _BasicSearchPageState extends State<BasicSearchPage> {
  int selectedTab = 0;
  int gender = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RangeValues ageRange = const RangeValues(25, 45);
  RangeValues heightRange = const RangeValues(120, 183);

  String? maritalStatus;
  String? motherTongue;
  String? religion;
  String? country;
  String? state;
  String? education;
  String? income;
  String? occupation;
  String? manglik;

  List<String> maritalList = [
    "Never Married",
    "Divorced",
    "Widow",
    "Separated",
  ];
  List<String> motherTongueList = ["Hindi", "English", "Gujarati", "Punjabi"];
  List<String> religionList = ["Hindu", "Muslim", "Sikh", "Christian"];
  List<String> countryList = ["India", "USA", "Canada", "UK"];
  List<String> stateList = ["Delhi", "Bihar", "UP", "Maharashtra"];
  List<String> educationList = ["B.Com", "B.Tech", "MBA", "MCA"];
  List<String> incomeList = ["1-2 Lakh", "2-5 Lakh", "5-10 Lakh", "10+ Lakh"];
  List<String> occupationList = ["Teacher", "Engineer", "Doctor", "Business"];
  List<String> manglikList = ["Yes", "No", "Angshik"];

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopBar(w),
                  _buildTopTabs(),
                  Divider(),
                  _buildSearchBox(w),
                ],
              ),
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

  Widget _buildTopBar(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color.fromARGB(255, 244, 229, 214),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  color: ColorResources.blackcolor11,
                  size: 28,
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
              "Search",
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
              _textField("Search Profile Id"),

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
              _dropDown(
                "Marital Status",
                maritalList,
                maritalStatus,
                (v) => setState(() => maritalStatus = v),
              ),

              _dropDown(
                "Mother Tongue",
                motherTongueList,
                motherTongue,
                (v) => setState(() => motherTongue = v),
              ),

              _dropDown(
                "Religion",
                religionList,
                religion,
                (v) => setState(() => religion = v),
              ),

              _dropDown(
                "Country",
                countryList,
                country,
                (v) => setState(() => country = v),
              ),

              _dropDown(
                "State",
                stateList,
                state,
                (v) => setState(() => state = v),
              ),

              _dropDown(
                "Education",
                educationList,
                education,
                (v) => setState(() => education = v),
              ),

              _dropDown(
                "Annual Income",
                incomeList,
                income,
                (v) => setState(() => income = v),
              ),

              _dropDown(
                "Occupation",
                occupationList,
                occupation,
                (v) => setState(() => occupation = v),
              ),

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

  Widget _textField(String hint) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
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

  // ----------------------------
  // SEARCH BUTTON
  // ----------------------------
  Widget _searchBtn() {
    return GestureDetector(
      onTap: () {
        print("----- SEARCH VALUES -----");
        print("Gender: ${gender == 0 ? "Bride" : "Groom"}");
        print("Age: ${ageRange.start} - ${ageRange.end}");
        print("Height: ${heightRange.start} - ${heightRange.end}");
        print("Marital: $maritalStatus");
        print("Mother Tongue: $motherTongue");
        print("Religion: $religion");
        print("Country: $country");
        print("State: $state");
        print("Education: $education");
        print("Income: $income");
        print("Occupation: $occupation");
        print("Manglik: $manglik");
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
          style: opensansMedium.copyWith(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
