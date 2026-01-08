import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/auth/employee/employee_login.dart';
import 'package:vivashri/config/utils/all_images.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      backgroundColor: ColorResources.primarycolor,

      body: Stack(
        children: [
          SizedBox(
            height: size.height * 0.45,
            width: double.infinity,
            child: Image.asset(Images.loginscren, fit: BoxFit.cover),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: size.height * 0.35,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset("assets/images/logo2.png", height: 35),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorResources.primarycolor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Login To Your Account",
                      style: opensansSemiBold.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

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
                      Text(
                        "Mobile No. / Email ID",
                        style: opensansSemiBold.copyWith(
                          fontSize: 14,
                          color: ColorResources.blackgrey,
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

                      Text(
                        "We will send you OTP to login",
                        style: opensansSemiBold.copyWith(
                          fontSize: 13,
                          color: ColorResources.blackgrey,
                        ),
                      ),

                      const SizedBox(height: 40),

                      GestureDetector(
                        onTap: () {
                          if (isValid) {
                            Get.find<AuthController>().userloginapi(
                              context: context,
                              mobileemail: inputCtrl.text.trim(),
                            );
                          } else {
                            Get.snackbar(
                              "Error",
                              "Please Enter Your Number/Email",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: ColorResources.primarycolor2,
                              colorText: Colors.white,
                              margin: EdgeInsets.all(12),
                            );
                          }
                        },

                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: isValid
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFBE266B),
                                      Color(0xFFEB1D7B),
                                    ],
                                  )
                                : null,
                            color: !isValid ? Colors.grey.shade400 : null,
                          ),
                          child: Center(
                            child: Text(
                              "Send OTP",
                              style: opensansMedium.copyWith(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              EmployeLogin(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Login as Employee",
                                    style: opensansSemiBold.copyWith(
                                      fontSize: 13,
                                      color: ColorResources.primarycolor2,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                    color: ColorResources.primarycolor2,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 3),
                              Container(
                                height: 1,
                                width: 150,
                                color: ColorResources.primarycolor2,
                              ),
                            ],
                          ),
                        ),
                      ),

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
