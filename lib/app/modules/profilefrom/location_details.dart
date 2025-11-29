import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/family_details.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/citycontroller.dart';
import 'package:vivashri/data/controller/nationality.dart';
import 'package:vivashri/data/controller/statecontroller.dart';

class LocationDetailsScreen extends StatefulWidget {
  const LocationDetailsScreen({super.key});

  @override
  State<LocationDetailsScreen> createState() => _LocationDetailsScreenState();
}

class _LocationDetailsScreenState extends State<LocationDetailsScreen> {
  // Dropdown values
  String? nationality;
  String? residenceType;
  String? permanentHouse;
  final cityC = Get.put(CityController());

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

                        // _dropdown(
                        //   value: pCity,
                        //   items: ["Ahmedabad", "Surat", "Mumbai", "Delhi"],
                        //   onChanged: (v) {
                        //     pCity = v;
                        //     fillTemporaryAddress();
                        //   },
                        // ),
                        _label("Landmark/Remarks"),
                        _textField(
                          controller: pLandmark,
                          onChanged: (v) => fillTemporaryAddress(),
                        ),

                        _label("Pin code / zip code:"),
                        _textField(
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
                            const Text(
                              "Same Fill",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        // TEMPORARY FIELDS
                        _label("State:"),
                        _dropdown(
                          value: tState,
                          items: ["Gujarat", "Delhi", "UP", "Maharashtra"],
                          onChanged: sameFill
                              ? null
                              : (v) => setState(() => tState = v),
                        ),

                        _label("City:"),
                        _dropdown(
                          value: tCity,
                          items: ["Ahmedabad", "Surat", "Mumbai", "Delhi"],
                          onChanged: sameFill
                              ? null
                              : (v) => setState(() => tCity = v),
                        ),

                        _label("Landmark/Remarks"),
                        _textField(controller: tLandmark, enabled: !sameFill),

                        _label("Pin code / zip code:"),
                        _textField(
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
                FamilyDetailsScreen(),
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
