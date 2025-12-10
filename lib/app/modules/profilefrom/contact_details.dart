import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class ContactDetailsScreen extends StatefulWidget {
  String? mobileemail;
  ContactDetailsScreen({super.key, this.mobileemail});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  String? selectedReference;
  TextEditingController emailController = TextEditingController();
  TextEditingController instgramidController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  StaperfromController stapercontroller = Get.put(StaperfromController());
  final usercontroller = Get.put(UserDetailController());
  bool deshboard = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileapi();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        deshboard = false;
      });
    });
  }

  void profileapi() async {
    final prefs = await SharedPreferences.getInstance();

    String? profileid = prefs.getString("profileid");
    usercontroller.fetchUserDetail(profileid.toString());
  }

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

                Obx(() {
                  if (usercontroller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorResources.primarycolor2,
                      ),
                    );
                  }

                  if (usercontroller.userData.value == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorResources.primarycolor2,
                      ),
                    );
                  }

                  final data = usercontroller.userData.value!;

                  return Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Contact Number:"),
                          _readOnlyBox("+91 ${data.mobile ?? ""}"),

                          _emailWithOtp(),

                          _label1("Insagram Id:"),
                          _inputField(controller: instgramidController),

                          _label1("Facebook Id:"),
                          _inputField(controller: facebookController),

                          const SizedBox(height: 10),
                          Text(
                            "Reference:",
                            style: opensansMedium.copyWith(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),

                          _label1("Reference Details:"),
                          _dropdownBox(
                            hint: "Select",
                            items: [
                              "Google Search",
                              "Facebook",
                              "Instagram",
                              "WhatsApp",
                              "Event",
                              "Linked In",
                            ],
                            value: selectedReference,
                            onChanged: (v) =>
                                setState(() => selectedReference = v),
                          ),

                          _label1("Other"),
                          _inputField(controller: otherController),

                          const SizedBox(height: 25),
                          _bottomButtons(data.mobile),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  );
                }),
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

  // ---------------- TOP HEADER ----------------

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
                    "Basic Details",
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
                        value: 0.50,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "2 of 4",
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
                  "Contact Details",
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
                if (emailController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please Enter Your Email Address',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else if (!emailController.text.contains("@")) {
                  Get.snackbar(
                    'Error',
                    'Email must contain @',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  stapercontroller.conectdetailsProfile(
                    formData: {
                      "contact_no": widget.mobileemail,
                      "contact_email": emailController.text.trim(),
                      "instagram": instgramidController.text.trim(),
                      "facebook": facebookController.text,
                      "reference": selectedReference,
                      "reference_other": otherController.text.trim(),
                      "app_step": '2',
                      "step": '2',
                    },
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
                    "Aadhaar Verification",
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

  Widget _label1(String text) {
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
              style: opensansMedium.copyWith(
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
  // ---------------- INPUT FIELD ----------------

  Widget _inputField({
    int maxLines = 1,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: _decoration(),
    );
  }

  // ---------------- READONLY PHONE BOX ----------------

  Widget _readOnlyBox(String text) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: opensansMedium.copyWith(
          fontSize: 17,
          color: ColorResources.blackgrey,
        ),
      ),
    );
  }

  // ---------------- EMAIL + OTP ----------------

  Widget _emailWithOtp() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_label("Contact Email Address:")],
              ),
              _inputField(controller: emailController),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- DROPDOWN ----------------

  Widget _dropdownBox({
    required String hint,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
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

  // ---------------- BOTTOM BUTTONS ----------------

  Widget _bottomButtons(numberemaild) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (emailController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Enter Your Email Address',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (!emailController.text.contains("@")) {
                Get.snackbar(
                  'Error',
                  'Email must contain @',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.conectdetailsProfile(
                  formData: {
                    "contact_no": numberemaild,
                    "contact_email": emailController.text.trim(),
                    "instagram": instgramidController.text.trim(),
                    "facebook": facebookController.text,
                    "reference": selectedReference,
                    "reference_other": otherController.text.trim(),
                    "app_step": '2',
                    "step": '2',
                  },
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

  // ---------------- COMMON DECORATION ----------------

  InputDecoration _decoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.pink),
      ),
    );
  }
}
