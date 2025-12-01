import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/partner_education.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/citycontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/nationality.dart';
import 'package:vivashri/data/controller/statecontroller.dart';

class PartnerLocationDetailsScreen extends StatefulWidget {
  const PartnerLocationDetailsScreen({super.key});

  @override
  State<PartnerLocationDetailsScreen> createState() =>
      _PartnerLocationDetailsScreenState();
}

class _PartnerLocationDetailsScreenState
    extends State<PartnerLocationDetailsScreen> {
  String? nationality;
  String? stateValue;
  StaperfromController stapercontroller = Get.put(StaperfromController());

  String? cityValue;
  final countryC = Get.put(CountryController());
  final stateC = Get.put(StateController());
  final cityC = Get.put(CityController());

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
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                "assets/images/femalee.png",
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Provide location details:",
                              style: opensansMedium.copyWith(
                                fontSize: 16,

                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // --------------- NATIONALITY ---------------
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
                        // --------------- STATE ---------------
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
                        // --------------- CITY / DISTRICT ---------------
                        _label("City / District:"),
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

                        const SizedBox(height: 40),
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
                  "Partner’s Family Det",
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
                        value: 0.85,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "15 of 18",
                      style: opensansMedium.copyWith(
                        color: ColorResources.blackgrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                Text(
                  "Partner’s Location Details",
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
                  "Partner Education &  Career Details",
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

  // ---------------- DROPDOWN ----------------

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
              if (countryC.selectedCountryId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Nationality',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (stateC.selectedStateId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your State',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (cityC.selectedCityId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your City',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.partnerlocationdetails(
                  formData: {
                    "partner_country": countryC.selectedCountryId.value,
                    "partner_state": stateC.selectedStateId.value,
                    "partner_city": cityC.selectedCityId.value,
                    "app_step": '15',
                    "step": '15',
                  },
                );
              }

              // Get.to(
              //   PartnerEducationCareerScreen(),
              //   duration: Duration(
              //     milliseconds: ApiConstants.screenTransitionTime,
              //   ),
              //   transition: Transition.rightToLeft,
              // );
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
