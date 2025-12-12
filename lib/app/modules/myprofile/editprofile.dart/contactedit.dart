import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class EditContectScreen extends StatefulWidget {
  String? mobileemail;
  EditContectScreen({super.key, this.mobileemail});

  @override
  State<EditContectScreen> createState() => _EditContectScreenState();
}

class _EditContectScreenState extends State<EditContectScreen> {
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
    final u = usercontroller.userData.value;
    if (u == null) return;
    emailController.text = u.email.toString();
    instgramidController.text = u.instagram.toString();
    facebookController.text = u.facebook.toString();
    // emailController.text = u.email.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.primarycolor2,
        centerTitle: true,
        title: Text(
          'Contact Details',
          style: opensansMedium.copyWith(fontSize: 18, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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

                      _label("Insagram Id:"),
                      _inputField(controller: instgramidController),

                      _label("Facebook Id:"),
                      _inputField(controller: facebookController),

                      const SizedBox(height: 10),

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

  Widget _bottomButtons(numberemaild) {
    return Row(
      children: [
        // Expanded(
        //   child: GestureDetector(
        //     onTap: () {
        //       Get.to(
        //         MainNavigation(),
        //         duration: Duration(
        //           milliseconds: ApiConstants.screenTransitionTime,
        //         ),
        //         transition: Transition.rightToLeft,
        //       );
        //     },
        //     child: Container(
        //       height: 45,
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         color: ColorResources.halkapink,
        //       ),
        //       child: Text(
        //         "SKIP",
        //         style: opensansMedium.copyWith(
        //           color: ColorResources.primarycolor2,
        //           fontSize: 18,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              stapercontroller.updatepartnerotherdetails(
                formData: {
                  // "contact_no": widget.mobileemail,
                  // "contact_email": emailController.text.trim(),
                  "instagram": instgramidController.text.trim(),
                  "facebook": facebookController.text,

                  // "reference": selectedReference,
                  // "reference_other": otherController.text.trim(),
                },
              );
              Future.delayed(const Duration(microseconds: 1000), () {
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
