import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/citycontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/nationality.dart';
import 'package:vivashri/data/controller/statecontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class EditPartnerlocation extends StatefulWidget {
  const EditPartnerlocation({super.key});

  @override
  State<EditPartnerlocation> createState() => _EditPartnerlocationState();
}

class _EditPartnerlocationState extends State<EditPartnerlocation> {
  String? nationality;
  String? stateValue;
  StaperfromController stapercontroller = Get.put(StaperfromController());

  String? cityValue;
  final countryC = Get.put(CountryController());
  final stateC = Get.put(StateController());
  final cityC = Get.put(CityController());
  @override
  void initState() {
    super.initState();
    getdata();
  }

  final usercontroller = Get.put(UserDetailController());

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;
    countryC.selectedCountryId.value = u.partnerCountry!.id.toString();
    countryC.selectedCountryName.value = u.partnerCountry!.name;

    stateC.selectedStateId.value = u.partnerState!.id.toString();
    stateC.selectedName.value = u.partnerState!.name;
    cityC.fetchCity(stateC.selectedStateId.value);
    cityC.selectedCityId.value = u.partnerCity!.id.toString();
    cityC.selectedCityName.value = u.partnerCity!.name;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Partner’s Location Details',
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

  // ---------------- DROPDOWN ----------------

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              stapercontroller.updatepartnerotherdetails(
                formData: {
                  "partner_country": countryC.selectedCountryId.value,
                  "partner_state": stateC.selectedStateId.value,
                  "partner_city": cityC.selectedCityId.value,
                },
              );  Future.delayed(const Duration(microseconds: 1000), () {
                Get.back();
              });
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
