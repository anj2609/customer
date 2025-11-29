import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/aadhar_otp.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';

class AadharVerificationScreen extends StatefulWidget {
  const AadharVerificationScreen({super.key});

  @override
  State<AadharVerificationScreen> createState() =>
      _AadharVerificationScreenState();
}

class _AadharVerificationScreenState extends State<AadharVerificationScreen> {
  final aadhaar1 = TextEditingController();
  final aadhaar2 = TextEditingController();
  final aadhaar3 = TextEditingController();
  StaperfromController stapercontroller = Get.put(StaperfromController());

  late FocusNode fn1;
  late FocusNode fn2;
  late FocusNode fn3;

  @override
  void initState() {
    super.initState();
    fn1 = FocusNode();
    fn2 = FocusNode();
    fn3 = FocusNode();
  }

  @override
  void dispose() {
    fn1.dispose();
    fn2.dispose();
    fn3.dispose();
    aadhaar1.dispose();
    aadhaar2.dispose();
    aadhaar3.dispose();
    super.dispose();
  }

  // -------------------- Single Aadhaar Input Box --------------------
  Widget _aadhaarBox(
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? next,
  ) {
    return SizedBox(
      width: 100,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 4,
        onChanged: (value) {
          if (value.length == 4 && next != null) {
            FocusScope.of(context).requestFocus(next);
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.pink, width: 1.5),
          ),
        ),
      ),
    );
  }

  // -------------------- HEADER --------------------
  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          // LEFT SIDE — Auto Resize
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
                  "Contact Details",
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

          // CENTER — Circle + Text Perfect Middle
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
                        value: 0.75,
                        strokeWidth: 5,
                        color: ColorResources.primarycolor2,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "3 of 4",
                      style: TextStyle(
                        color: ColorResources.blackgrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Center text stays big — no resize
                Text(
                  "Aadhaar Verification",
                  style: opensansMedium.copyWith(
                    color: ColorResources.blackcolor,
                    fontSize: 17, // fixed size
                  ),
                ),
              ],
            ),
          ),

          // RIGHT SIDE (empty but balanced)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AutoSizeText(
                  "",
                  maxLines: 1,
                  minFontSize: 8,
                  maxFontSize: 14,
                  style: opensansBold.copyWith(
                    color: ColorResources.primarycolor,
                  ),
                ),
                AutoSizeText(
                  "",
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
      padding: const EdgeInsets.only(top: 5, bottom: 8),
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
            const TextSpan(
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

  // -------------------- BOTTOM BUTTONS --------------------
  Widget _bottomButtons() {
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
              if (aadhaar1.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Enter Your Aadhaar Number',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (aadhaar2.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Enter Your Aadhaar Number',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else if (aadhaar3.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please Enter Your Aadhaar Number',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                stapercontroller.aadharnumberProfile(
                  formData: {
                    "aadhaar_no":
                        '${aadhaar1.text}${aadhaar2.text}${aadhaar3.text}',
                    "app_step": "3",
                    "step": "3",
                  },
                );
              }
              print(
                'otp::::::${aadhaar1.text}${aadhaar2.text}${aadhaar3.text}',
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
                "Send OTP",
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

  // -------------------- MAIN UI --------------------
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
                        _label("Enter Aadhaar Number:"),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _aadhaarBox(aadhaar1, fn1, fn2),
                            _aadhaarBox(aadhaar2, fn2, fn3),
                            _aadhaarBox(aadhaar3, fn3, null),
                          ],
                        ),

                        const SizedBox(height: 30),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "You will receive an 4 digit OTP",
                                style: opensansMedium.copyWith(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "(One Time Password) with registered",
                                style: opensansMedium.copyWith(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "Aadhaar Card",
                                style: opensansMedium.copyWith(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                        _bottomButtons(),
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
}
