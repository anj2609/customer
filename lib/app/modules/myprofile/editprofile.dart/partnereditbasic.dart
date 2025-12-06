import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/complecxion.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/langunage.dart';
import 'package:vivashri/data/controller/marital_staus.contro.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class EditPartnerBasicDetailsScreen extends StatefulWidget {
  const EditPartnerBasicDetailsScreen({super.key});

  @override
  State<EditPartnerBasicDetailsScreen> createState() =>
      _EditPartnerBasicDetailsScreenState();
}

class _EditPartnerBasicDetailsScreenState
    extends State<EditPartnerBasicDetailsScreen> {
  // AGE RANGE
  String? fromAge;
  String? toAge;
  final usercontroller = Get.put(UserDetailController());

  @override
  void initState() {
    super.initState();
    complexionC.fetchComplexion();
    getdata();
  }

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;
    fromAge = u.partnerAgeFrom?.toString();
    toAge = u.partnerAgeTo?.toString();
    fromHeight = u.partnerHeightFrom?.toString();
    toHeight = u.partnerHeightTo?.toString();
    complexionC.selectedComplexionId2.value = u.partnerComplexion!.id
        .toString();
    complexionC.selectedComplexionName2.value = u.partnerComplexion!.name;
    languageC.selectedLanguageId.value = u.partnerLanguage!.id.toString();
    languageC.selectedLanguageName.value = u.partnerLanguage!.name;
    children = u.partnerHaveChildren;
    languageC.motherselectedLanguageId.value = u.partnerMotherTongue!.id
        .toString();
    languageC.morherselectedLanguageName.value = u.partnerMotherTongue!.name;
    maritalC.selectedIds.clear();
    maritalC.selectedNames.clear();

    // Add IDs & Names
    for (var item in u.partnerMaritalStatus) {
      maritalC.selectedIds.add(item.id);
      maritalC.selectedNames.add(item.name);
    }

    // fromWeight = u.partnerWeightFrom?.toString();
    // toWeight = u.partnerWeightTo?.toString();

    setState(() {});
  }

  StaperfromController stapercontroller = Get.put(StaperfromController());

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

  final maritalC = Get.put(MaritalStatusController());

  List<String> get fromWeightKeys => weightRange.keys.toList();
  List<String> filteredToWeight(String? fromWeight) {
    if (fromWeight == null) return [];

    int start = int.parse(fromWeight);

    return weightRange.keys.where((key) => int.parse(key) >= start).toList();
  }

  List<DropdownMenuItem<String>> buildItems(List<String> keys) {
    return keys
        .map(
          (key) => DropdownMenuItem(
            value: key,
            child: Text(
              ageRange[key]!,
              style: opensansMedium.copyWith(
                color: ColorResources.blackhalka,
                fontSize: 14,
              ),
            ),
          ),
        )
        .toList();
  }

  List<String> get fromKeys => ageRange.keys.toList();

  List<String> filteredToKeys(String? fromAge) {
    if (fromAge == null) return ageRange.keys.toList();

    int selected = int.parse(fromAge);
    return ageRange.keys.where((k) => int.parse(k) >= selected).toList();
  }

  final complexionC = Get.put(ComplexionController());

  // WEIGHT
  String? fromWeight;
  String? toWeight;

  // HEIGHT
  String? fromHeight;
  String? toHeight;

  // DROPDOWNS
  String? complexion;
  String? language;
  String? children;
  String? motherTongue;
  List<DropdownMenuItem<String>> buildHeightItems(List<String> keys) {
    return keys
        .map(
          (key) => DropdownMenuItem(
            value: key, // "5.7"
            child: Text(
              heightRange[key]!,
              style: opensansMedium.copyWith(
                color: ColorResources.blackhalka,
                fontSize: 14,
              ),
            ), // "5 ft 7 in"
          ),
        )
        .toList();
  }

  List<String> get fromHeightKeys => heightRange.keys.toList();
  List<String> filteredToHeight(String? fromHeight) {
    if (fromHeight == null) return heightRange.keys.toList();

    double selected = double.parse(fromHeight.replaceAll(".", ""));

    return heightRange.keys.where((k) {
      double h = double.parse(k.replaceAll(".", ""));
      return h >= selected;
    }).toList();
  }

  final languageC = Get.put(LanguageController());

  // MARITAL STATUS BUTTON
  String maritalStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Partner’s Basic Details',
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,

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

                    // ---------------- AGE RANGE ----------------
                    _label("Age Range:"),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown22(
                            value: fromAge,
                            items: buildItems(fromKeys),
                            onChanged: (v) {
                              setState(() {
                                fromAge = v;
                                toAge = null;
                                print('fromage::::::$fromAge');
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("To"),
                        SizedBox(width: 10),
                        Expanded(
                          child: _dropdown22(
                            value: toAge,
                            items: buildItems(filteredToKeys(fromAge)),
                            onChanged: (v) {
                              setState(() {
                                toAge = v;
                                print('toage::::::$toAge');
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    _label("Body Weight:"),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown22(
                            value: fromWeight,
                            items: buildWeightItems(fromWeightKeys),
                            onChanged: (v) {
                              setState(() {
                                fromWeight = v;
                                toWeight = null; // reset second dropdown
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("To"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropdown22(
                            value: toWeight,
                            items: buildWeightItems(
                              filteredToWeight(fromWeight),
                            ),
                            onChanged: (v) => setState(() => toWeight = v),
                          ),
                        ),
                      ],
                    ),

                    _label("Height Range:"),
                    Row(
                      children: [
                        Expanded(
                          child: _dropdown22(
                            value: fromHeight,
                            items: buildHeightItems(fromHeightKeys),
                            onChanged: (v) {
                              setState(() {
                                fromHeight = v;
                                toHeight = null;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text("To"),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _dropdown22(
                            value: toHeight,
                            items: buildHeightItems(
                              filteredToHeight(fromHeight),
                            ),
                            onChanged: (v) {
                              setState(() => toHeight = v);
                            },
                          ),
                        ),
                      ],
                    ),

                    _label("Complexion:"),
                    Obx(() {
                      return _dropdown22(
                        value: complexionC.selectedComplexionId2.value.isEmpty
                            ? null
                            : complexionC.selectedComplexionId2.value,

                        onChanged: (v) {
                          complexionC.onSelect2222(v!);
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
                    _label("Language"),
                    Obx(() {
                      return _dropdown22(
                        value: languageC.selectedLanguageId.value.isEmpty
                            ? null
                            : languageC.selectedLanguageId.value,

                        onChanged: (v) {
                          languageC.onSelect(v!);
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

                    // ---------------- MARITAL STATUS ----------------
                    _label("Marital Status:"),
                    Obx(() {
                      return GestureDetector(
                        onTap: () => _openMultiSelectDialog(context),

                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: _boxDecoration(),
                          child: Text(
                            maritalC.selectedNames.isEmpty
                                ? "Select"
                                : maritalC.selectedNames.join(", "),

                            style: opensansMedium.copyWith(
                              color: ColorResources.blackhalka,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }),
                    // Obx(() {
                    //   return _dropDown(
                    //     hint: "Select",
                    //     value: maritalC.selectedName.value,
                    //     onChanged: (v) {
                    //       maritalC.onSelect(v!);
                    //       print('name::::::${maritalC.selectedName.value}');
                    //       setState(() {});
                    //     },
                    //     items: maritalC.maritalList.map((e) => e.name).toList(),
                    //   );
                    // }),
                    // Row(
                    //   children: [
                    //     _selectButton(
                    //       "Married",
                    //       maritalStatus == "Married",
                    //       () {
                    //         setState(() => maritalStatus = "Married");
                    //       },
                    //     ),
                    //     const SizedBox(width: 12),
                    //     _selectButton(
                    //       "Unmarried",
                    //       maritalStatus == "Unmarried",
                    //       () {
                    //         setState(() => maritalStatus = "Unmarried");
                    //       },
                    //     ),
                    //   ],
                    // ),

                    // ---------------- CHILDREN ----------------
                    maritalC.selectedName.value == "Unmarried"
                        ? SizedBox()
                        : _label("Have Children:"),
                    maritalC.selectedName.value == "Unmarried"
                        ? SizedBox()
                        : _dropdown(
                            value: children,
                            items: [
                              "No",
                              "Yes - Living together",
                              "Yes - Living separately",
                            ],
                            onChanged: (v) => setState(() => children = v),
                          ),

                    // ---------------- MOTHER TONGUE ----------------
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

  void _openMultiSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Marital Status"),
          content: Obx(() {
            return SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: maritalC.maritalList.map((item) {
                  bool isSelected = maritalC.selectedIds.contains(item.id);

                  return CheckboxListTile(
                    title: Text(item.name),
                    value: isSelected,
                    onChanged: (v) {
                      maritalC.toggleSelection(item);
                    },
                  );
                }).toList(),
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Done"),
            ),
          ],
        );
      },
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade400),
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
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: value,
          icon: Icon(Icons.keyboard_arrow_down),
          hint: Text(
            "Select",
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
              stapercontroller.updatepartnerbasicdetails(
                formData: {
                  "partner_age_from": fromAge,
                  "partner_age_to": toAge,
                  "partner_weight_from": fromAge,
                  "partner_weight_to": toAge,
                  "partner_height_from": fromHeight,
                  "partner_height_to": toHeight,
                  "partner_complexion": complexionC.selectedComplexionId2.value,
                  "partner_language": languageC.selectedLanguageId.value,
                  // "partner_marital_status": maritalC.selectedId.value,
                  "partner_have_children": children,
                  "partner_mother_tongue":
                      languageC.motherselectedLanguageId.value,
                },
                selected: maritalC.selectedId.value,
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
