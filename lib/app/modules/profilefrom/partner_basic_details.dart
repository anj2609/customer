import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/partner_basic_details2.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/complecxion.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/langunage.dart';
import 'package:vivashri/data/controller/marital_staus.contro.dart';
import 'package:vivashri/widgets/dropdownitems.dart';

class PartnerBasicDetailsScreen extends StatefulWidget {
  const PartnerBasicDetailsScreen({super.key});

  @override
  State<PartnerBasicDetailsScreen> createState() =>
      _PartnerBasicDetailsScreenState();
}

class _PartnerBasicDetailsScreenState extends State<PartnerBasicDetailsScreen> {
  // AGE RANGE
  String? fromAge;
  String? toAge;
  @override
  void initState() {
    super.initState();
    complexionC.fetchComplexion();
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
  List<String> filteredToWeight(String? from) {
    if (from == null) return weightRange.keys.toList();

    int selected = int.parse(from);

    return weightRange.keys.where((k) => int.parse(k) >= selected).toList();
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    bool hideChildren =
        maritalC.selectedNames.isEmpty ||
        (maritalC.selectedNames.length == 1 &&
            maritalC.selectedNames.contains("Unmarried"));

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
                              "Provide partner’s basic details:",
                              style: opensansMedium.copyWith(
                                fontSize: 16,

                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

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
                            value:
                                complexionC.selectedComplexionId2.value.isEmpty
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

                        hideChildren ? SizedBox() : _label("Have Children:"),

                        hideChildren
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
                            value:
                                languageC.motherselectedLanguageId.value.isEmpty
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
          Container(
            height: statusBarHeight,
            width: double.infinity,
            color: ColorResources.primarycolor2,
          ),
        ],
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

  Widget _dropDown3232({
    Key? key,
    required String hint,
    required String? value,
    required Function(String?) onChanged,
    required List<String> items,
  }) {
    return Container(
      key: key, // ← ADD THIS
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

          value: value, // NOW IT WILL UPDATE

          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          items: const [],
          onChanged: null,
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
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
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
                    "Partner’s Qualities",
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
                        value: 0.72,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "13 of 18",
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
                  "Partner’s Basic Details",
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
            child: GestureDetector(
              onTap: () {
                if (fromAge == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Age Range ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (toAge == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Age Range ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (fromWeight == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Weight Range ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (toWeight == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Weight Range ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (fromHeight == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your To Height ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (toHeight == null) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your From Height ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (complexionC.selectedComplexionId2.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Complexion ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (languageC.selectedLanguageId.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Language ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (maritalC.selectedNames.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Marital Status ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (languageC.motherselectedLanguageId.value.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Select Your Mother Language ',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  stapercontroller.partnerbasicdetails(
                    formData: {
                      "partner_age_from": fromAge,
                      "partner_age_to": toAge,
                      "partner_weight_from": fromAge,
                      "partner_weight_to": toAge,
                      "partner_height_from": fromHeight,
                      "partner_height_to": toHeight,
                      "partner_complexion":
                          complexionC.selectedComplexionId2.value,
                      "partner_language": languageC.selectedLanguageId.value,
                      // "partner_marital_status": maritalC.selectedId.value,
                      "partner_have_children": children,
                      "partner_mother_tongue":
                          languageC.motherselectedLanguageId.value,
                      "app_step": '13',
                      "step": '13',
                    },
                    selected: maritalC.selectedIds,
                  );
                }
              },
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
                    "Partner’s Family Det.",
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

  // ---------------- SELECT BUTTON ----------------
  Widget _selectButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected ? Colors.pink.shade50 : Colors.white,
            border: Border.all(
              color: selected ? Colors.pink : Colors.grey.shade400,
              width: 1.3,
            ),
          ),
          child: Text(
            label,
            style: opensansMedium.copyWith(
              color: selected ? Colors.pink : Colors.black87,

              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.to(
                PartnerFamilyDetailsScreen(),
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
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (fromAge == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Age Range ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (toAge == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Age Range ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (fromWeight == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Weight Range ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (toWeight == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Weight Range ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (fromHeight == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your To Height ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (toHeight == null) {
                Get.snackbar(
                  'Error',
                  'Please Select Your From Height ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (complexionC.selectedComplexionId2.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Complexion ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (languageC.selectedLanguageId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Language ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (maritalC.selectedNames.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Marital Status ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (languageC.motherselectedLanguageId.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Select Your Mother Language ',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.partnerbasicdetails(
                  formData: {
                    "partner_age_from": fromAge,
                    "partner_age_to": toAge,
                    "partner_weight_from": fromAge,
                    "partner_weight_to": toAge,
                    "partner_height_from": fromHeight,
                    "partner_height_to": toHeight,
                    "partner_complexion":
                        complexionC.selectedComplexionId2.value,
                    "partner_language": languageC.selectedLanguageId.value,
                    // "partner_marital_status": maritalC.selectedId.value,
                    "partner_have_children": children,
                    "partner_mother_tongue":
                        languageC.motherselectedLanguageId.value,
                    "app_step": '13',
                    "step": '13',
                  },
                  selected: maritalC.selectedIds,
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
