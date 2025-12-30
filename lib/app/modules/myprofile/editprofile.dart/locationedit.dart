import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/check_percentage.dart';
import 'package:vivashri/data/controller/citycontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/nationality.dart';
import 'package:vivashri/data/controller/statecontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class EditLocationScreen extends StatefulWidget {
  const EditLocationScreen({super.key});

  @override
  State<EditLocationScreen> createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  // Dropdown values
  String? nationality;
  String? residenceType;
  String? permanentHouse;
  final cityC = Get.put(CityController());
  StaperfromController stapercontroller = Get.put(StaperfromController());

  String? pState;
  String? pCity;

  String? tState;
  String? tCity;

  bool sameFill = false;
  final countryC = Get.put(CountryController());

  // Controllers
  final pLandmark = TextEditingController();
  final pPincode = TextEditingController();

  final tLandmark = TextEditingController();
  final tPincode = TextEditingController();
  final stateC = Get.put(StateController());

  // ----------------- SAME FILL FUNCTION -----------------
  void fillTemporaryAddress() {
    if (sameFill) {
      tState = pState;
      tCity = pCity;
      tLandmark.text = pLandmark.text;
      tPincode.text = pPincode.text;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  final usercontroller = Get.put(UserDetailController());

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;
    countryC.selectedCountryId.value = u.locNationality!.id.toString();
    countryC.selectedCountryName.value = u.locNationality!.name;
    residenceType = u.locResidenceType;
    permanentHouse = u.locHouseType;
    stateC.selectedStateId.value = u.locState!.id.toString();
    stateC.selectedName.value = u.locState!.name;
    cityC.fetchCity(stateC.selectedStateId.value);
    cityC.selectedCityId.value = u.locCity!.id.toString();
    cityC.selectedCityName.value = u.locCity!.name;
    pLandmark.text = u.locLandmark.toString();
    pPincode.text = u.locPincode.toString();
    stateC.sameselectedStateId.value = u.locTempState!.id.toString();
    stateC.sameselectedName.value = u.locTempState!.name;
    cityC.fetchCity222(stateC.sameselectedStateId.value);
    cityC.sameselectedCityId.value = u.locTempCity!.id.toString();
    cityC.sameeselectedCityName.value = u.locTempCity!.name;
    tLandmark.text = u.locTempLandmark.toString();
    tPincode.text = u.locTempPincode.toString();
    setState(() {});
  }

  @override
  void dispose() {
    pLandmark.dispose();
    pPincode.dispose();
    tLandmark.dispose();
    tPincode.dispose();
    super.dispose();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Location Details',
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
                    // Nationality
                    _label("Nationality:"),
                    Obx(() {
                      return _dropdown22(
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

                    // Residence
                    _label("Residence Type:"),
                    _dropdown(
                      value: residenceType,
                      items: [
                        "Owned House",
                        "Rented House",
                        "Staying with Family",
                        "Hostel / PG",
                        "Company Accommodation",
                        "Living Alone",
                        "Living Abroad",
                        "Other",
                      ],
                      onChanged: (v) => setState(() => residenceType = v),
                    ),

                    // Permanent House Type
                    _label("Permanent House Type:"),
                    _dropdown(
                      value: permanentHouse,
                      items: [
                        "Independent House",
                        "Apartment / Flat",
                        "Bungalow",
                        "Ancestral Home",
                        "Government Quarters / Staff Housing",
                        "Temporary / Rented House",
                        "Other",
                      ],
                      onChanged: (v) => setState(() => permanentHouse = v),
                    ),

                    const SizedBox(height: 15),
                    Text(
                      "Permanent Address Location:",
                      style: opensansMedium.copyWith(
                        fontSize: 16,
                        color: ColorResources.blackhalka,
                      ),
                    ),

                    _label("State:"),
                    Obx(() {
                      return _cityc(
                        value: stateC.selectedStateId.value.isEmpty
                            ? null
                            : stateC.selectedStateId.value,

                        onChanged: (v) {
                          stateC.onSelect(v!);
                          cityC.fetchCity(v);
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

                    _label("City:"),
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

                    _label("Landmark/Remarks"),
                    _textField(
                      controller: pLandmark,
                      onChanged: (v) => fillTemporaryAddress(),
                    ),

                    _label("Pin code / zip code:"),
                    _textpincode(
                      controller: pPincode,
                      keyboard: TextInputType.number,
                      onChanged: (v) => fillTemporaryAddress(),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      "Temporary Address Location:",
                      style: opensansMedium.copyWith(
                        fontSize: 16,
                        color: ColorResources.blackhalka,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // SAME FILL CHECKBOX
                    Row(
                      children: [
                        Checkbox(
                          value: sameFill,
                          activeColor: Colors.pink,
                          onChanged: (v) {
                            setState(() {
                              sameFill = v!;
                              fillTemporaryAddress();
                            });
                          },
                        ),
                        Text(
                          "Same Fill",
                          style: opensansSemiBold.copyWith(fontSize: 14),
                        ),
                      ],
                    ),

                    // TEMPORARY FIELDS
                    sameFill == true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("State:"),
                              Obx(() {
                                return _cityc(
                                  value: stateC.selectedStateId.value.isEmpty
                                      ? null
                                      : stateC.selectedStateId.value,

                                  onChanged: (v) {
                                    stateC.onSelect(v!);
                                    cityC.fetchCity(v);
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

                              _label("City:"),
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
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label("State:"),
                              Obx(() {
                                return _cityc(
                                  value:
                                      stateC.sameselectedStateId.value.isEmpty
                                      ? null
                                      : stateC.sameselectedStateId.value,

                                  onChanged: (v) {
                                    stateC.onSelect22(v!);
                                    cityC.fetchCity222(v);
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
                              _label("City:"),
                              Obx(() {
                                return _cityc(
                                  value: cityC.sameselectedCityId.value.isEmpty
                                      ? null
                                      : cityC.sameselectedCityId.value,

                                  onChanged: (v) {
                                    cityC.onSelect222(v!);
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
                            ],
                          ),

                    _label("Landmark/Remarks"),
                    _textField(controller: tLandmark, enabled: !sameFill),

                    _label("Pin code / zip code:"),
                    _textpincode(
                      controller: tPincode,
                      keyboard: TextInputType.number,
                      enabled: !sameFill,
                    ),

                    const SizedBox(height: 30),
                    _buttons(),
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

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade400),
    );
  }

  Widget _dropstateDown({
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
                  "Reference Details",
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
                        value: 0.25,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "7 of 18",
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
                  "Location Details",
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

  // ---------------- Dropdown ----------------
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: value,
          hint: Text(
            "Select",
            style: opensansMedium.copyWith(
              color: ColorResources.blackhalka,
              fontSize: 14,
            ),
          ),
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

  Widget _textpincode({
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboard = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboard,
      onChanged: onChanged,
      maxLength: 6,
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColorResources.primarycolor),
        ),
      ),
    );
  }

  // ---------------- TextField ----------------
  Widget _textField({
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboard = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: ColorResources.primarycolor),
        ),
      ),
    );
  }

  final checkpercentagecontroller = Get.put(CheckProfileController());

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
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              String? profileid = prefs.getString("profileid");
              stapercontroller.updatelocationdeatilss(
                formData: {
                  "loc_nationality": countryC.selectedCountryId.value,
                  "loc_residence_type": residenceType,
                  "loc_house_type": permanentHouse,
                  "loc_state": stateC.selectedStateId.value,
                  "loc_city": cityC.selectedCityId.value,
                  "loc_landmark": pLandmark.text.trim(),
                  "loc_pincode": pPincode.text.trim(),
                  "loc_temp_state": sameFill == true
                      ? stateC.selectedStateId.value
                      : stateC.sameselectedStateId.value,
                  "loc_temp_city": sameFill == true
                      ? cityC.selectedCityId.value
                      : cityC.sameselectedCityId.value,
                  "loc_temp_landmark": sameFill == true
                      ? pLandmark.text.trim()
                      : tLandmark.text.trim(),
                  "loc_temp_pincode": sameFill == true
                      ? pPincode.text.trim()
                      : tPincode.text.trim(),
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
