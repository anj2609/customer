import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/dietcontroller.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class Editpartnereditother extends StatefulWidget {
  const Editpartnereditother({super.key});

  @override
  State<Editpartnereditother> createState() => _EditpartnereditotherState();
}

class _EditpartnereditotherState extends State<Editpartnereditother> {
  String? diet;
  String? drinking;
  StaperfromController stapercontroller = Get.put(StaperfromController());

  String? smoking;
  String? profileManaged;
  final dietC = Get.put(DietController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dietC.fetchDiet();
    getdata();
  }

  void getdata() async {
    final u = usercontroller.userData.value;
    if (u == null) return;
    dietC.selectedDietId.value = u.partnerDiet!.id.toString();
    dietC.selectedDietName.value = u.partnerDiet!.name;
    drinking = u.partnerDrinking;
    smoking = u.partnerSmoking;
    profileManaged = u.partnerManagedBy;

    setState(() {});
  }

  final usercontroller = Get.put(UserDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Edit Partner’s Other Details',
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

                    // ---------------- Diet Preference ----------------
                    _label("Diet Preference:"),

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

                    // ---------------- Drinking Habit ----------------
                    _label("Drinking Habit:"),
                    _dropdown(
                      value: drinking,
                      items: ["No", "Occasionally", "Yes"],
                      onChanged: (v) => setState(() => drinking = v),
                    ),

                    // ---------------- Smoking Habit ----------------
                    _label("Smoking Habit:"),
                    _dropdown(
                      value: smoking,
                      items: ["No", "Occasionally", "Yes"],
                      onChanged: (v) => setState(() => smoking = v),
                    ),

                    // ---------------- Profile Managed ----------------
                    _label("Profile Managed by:"),
                    _dropdown(
                      value: profileManaged,
                      items: [
                        "Self",
                        "Parent/Guardian",
                        "Sibling/Friend/Other",
                        "Open to All",
                      ],
                      onChanged: (v) => setState(() => profileManaged = v),
                    ),

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

  // ---------------- DROPDOWN ----------------
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
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
                  "partner_diet": dietC.selectedDietId.value,
                  "partner_drinking": drinking,
                  "partner_smoking": smoking,
                  "partner_managed_by": profileManaged,
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
