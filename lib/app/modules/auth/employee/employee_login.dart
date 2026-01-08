import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/employee/deshboard/buttom_desh.dart';

class EmployeLogin extends StatefulWidget {
  const EmployeLogin({super.key});

  @override
  State<EmployeLogin> createState() => _EmployeLoginState();
}

class _EmployeLoginState extends State<EmployeLogin> {
  TextEditingController inputCtrl = TextEditingController();
  bool isValid = false;
  void validateInput(String value) {
    if (RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      setState(() => isValid = true);

      FocusScope.of(context).unfocus();
      return;
    }

    if (value.contains("@") &&
        (value.endsWith(".com") || value.endsWith(".in"))) {
      setState(() => isValid = true);
      FocusScope.of(context).unfocus();
      return;
    }

    setState(() => isValid = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorResources.primarycolor3,

      body: Stack(
        children: [
          SizedBox(
            height: size.height * 0.45,
            width: double.infinity,
            child: Image.asset('assets/images/Frame 87.png', fit: BoxFit.cover),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: size.height * 0.35,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: ColorResources.primarycolor3,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login Here",
                        style: opensansSemiBold.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Login to your account with your credentials",
                        style: opensansSemiBold.copyWith(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Mobile No",
                          style: opensansSemiBold.copyWith(
                            fontSize: 14,
                            color: ColorResources.blackgrey,
                          ),
                          children: [
                            TextSpan(
                              text: " *",
                              style: opensansSemiBold.copyWith(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 7),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black38),
                        ),
                        child: TextField(
                          onChanged: validateInput,
                          controller: inputCtrl,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text.rich(
                        TextSpan(
                          text: "Password",
                          style: opensansSemiBold.copyWith(
                            fontSize: 14,
                            color: ColorResources.blackgrey,
                          ),
                          children: [
                            TextSpan(
                              text: " *",
                              style: opensansSemiBold.copyWith(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 7),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black38),
                        ),
                        child: TextField(
                          onChanged: validateInput,
                          controller: inputCtrl,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const SizedBox(height: 40),

                      GestureDetector(
                        onTap: () {
                          Get.to(
                            EmployeButtomScreen(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                        },

                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFBE266B), Color(0xFFEB1D7B)],
                            ),
                            // : null,
                            color: !isValid ? Colors.grey.shade400 : null,
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: opensansMedium.copyWith(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "© 2025 Vivashri.com. All rights reserved.",
                          style: opensansSemiBold.copyWith(
                            fontSize: 12,
                            color: ColorResources.blackgrey,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
