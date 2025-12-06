import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class EditFamilyDetailsScreen extends StatefulWidget {
  const EditFamilyDetailsScreen({super.key});

  @override
  State<EditFamilyDetailsScreen> createState() =>
      _EditFamilyDetailsScreenState();
}

class _EditFamilyDetailsScreenState extends State<EditFamilyDetailsScreen> {
  String familyType = "";
  String familyValue = "";

  String? noOfSister;
  String? marriedSister;
  String? noOfBrother;
  String? marriedBrother;
  String? noOfSisterInLaw;
  String? noOfBrotherInLaw;
  String? totalFamilyMember;
  StaperfromController stapercontroller = Get.put(StaperfromController());

  List<String> getMarriedSisterList() {
    if (noOfSister == null) return ["0"];

    int count = int.tryParse(noOfSister!) ?? 0;

    return List.generate(count + 1, (i) => "$i");
  }

  List<String> getMarriedBrotherList() {
    if (noOfBrother == null) return ["0"];

    int count = int.tryParse(noOfBrother!) ?? 0;

    return List.generate(count + 1, (i) => "$i");
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
    familyType = u.familyType.toString();
    familyValue = u.familyValue.toString();
    noOfSister = u.noOfSister?.toString();
    marriedSister = u.marriedSister.toString();
    noOfBrother = u.noOfBrother.toString();
    marriedBrother = u.marriedBrother.toString();
    noOfSisterInLaw = u.noOfSisterInLaw.toString();
    noOfBrotherInLaw = u.noOfBrotherInLaw.toString();
    // totalFamilyMember = u.fa

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
          'Family Details',
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
                    _label("Family Type:"),
                    _familyTypeButtons(),

                    _label("Family Value:"),
                    _familyValueButtons(),

                    _label("No. of Sister:"),
                    _dropdown(
                      value: noOfSister,
                      items: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
                      onChanged: (v) {
                        setState(() {
                          noOfSister = v;
                          marriedSister = "0";
                        });
                      },
                    ),

                    _label("Married Sister:"),

                    _dropdown(
                      value: marriedSister,
                      items: getMarriedSisterList(),
                      onChanged: (v) {
                        setState(() => marriedSister = v);
                      },
                    ),

                    _label("No. of Brother:"),
                    _dropdown(
                      value: noOfBrother,
                      items: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
                      onChanged: (v) {
                        setState(() {
                          noOfBrother = v;
                          marriedBrother = "0"; // Reset married brother
                        });
                      },
                    ),

                    _label("Married Brother:"),
                    _dropdown(
                      value: marriedBrother,
                      items: getMarriedBrotherList(), // 🔥 Dynamic items
                      onChanged: (v) {
                        setState(() => marriedBrother = v);
                      },
                    ),

                    _label("No. of Sister in Law:"),
                    _dropdown(
                      value: noOfSisterInLaw,
                      items: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
                      onChanged: (v) => setState(() => noOfSisterInLaw = v),
                    ),

                    _label("No. of Brother in Law:"),
                    _dropdown(
                      value: noOfBrotherInLaw,
                      items: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
                      onChanged: (v) => setState(() => noOfBrotherInLaw = v),
                    ),

                    // _label("Total Family Member:"),
                    // _dropdown(
                    //   value: totalFamilyMember,
                    //   items: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
                    //   onChanged: (v) => setState(() => totalFamilyMember = v),
                    // ),
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

  // ------------------- FAMILY TYPE -------------------
  Widget _familyTypeButtons() {
    return Row(
      children: [
        _typeButton("Joint", familyType == "Joint", () {
          setState(() => familyType = "Joint");
        }),
        const SizedBox(width: 12),
        _typeButton("Nuclear", familyType == "Nuclear", () {
          setState(() => familyType = "Nuclear");
        }),
      ],
    );
  }

  Widget _typeButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? ColorResources.primarycolor3
                  : Colors.grey.shade400,
              width: 1.4,
            ),
            color: selected ? Colors.pink.shade50 : Colors.white,
          ),
          child: Text(
            label,
            style: opensansMedium.copyWith(
              fontSize: 14,
              //fontWeight: FontWeight.w600,
              color: selected ? ColorResources.primarycolor3 : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------- FAMILY VALUE BUTTONS -------------------
  Widget _familyValueButtons() {
    final values = ["Orthodox", "Traditional", "Moderate", "Liberal"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values.map((v) {
        bool selected = familyValue == v;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 5),
            child: InkWell(
              onTap: () => setState(() => familyValue = v),
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
                  v,
                  style: opensansSemiBold.copyWith(
                    fontSize: 13,

                    color: selected
                        ? ColorResources.primarycolor3
                        : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ------------------- DROPDOWN -------------------
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
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
          child: GestureDetector(
            onTap: () {
              stapercontroller.updatepartnerotherdetails(
                formData: {
                  "family_type": familyType,
                  "family_value": familyValue,
                  "no_of_sister": noOfSister,
                  "married_sister": marriedSister,
                  "no_of_brother": noOfBrother,
                  "married_brother": marriedBrother,
                  "no_of_sister_in_law": noOfSisterInLaw,
                  "no_of_brother_in_law": noOfBrotherInLaw,
                  // "total_family": totalFamilyMember,
                },
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
