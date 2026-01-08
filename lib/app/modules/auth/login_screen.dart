import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/constants.dart';
import 'package:evfual/config/utils/style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: Image.asset(
                    "assets/images/login.png",
                    fit: BoxFit.cover,
                  ),
                ),

                Text(
                  "LOGIN NOW",
                  style: opensansSemiBold.copyWith(
                    fontSize: 22,

                    color: ColorResources.primarycolor,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "Please login to get started",
                  style: opensansSemiBold.copyWith(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 30),

                /// 🧾 Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      /// Email / UserId
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration("Userid/Email"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Userid/Email is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      /// Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: _inputDecoration(
                          "Password",
                          suffix: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 8),

                      /// Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: opensansSemiBold.copyWith(
                              color: ColorResources.blueeebutton,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ✅ Gradient Login Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Material(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Get.to(
                            MainNavigation(),
                            duration: Duration(
                              milliseconds: ApiConstants.screenTransitionTime,
                            ),
                            transition: Transition.rightToLeft,
                          );
                          // if (_formKey.currentState!.validate()) {

                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text("Login Successful")),
                          //   );

                          // }
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF0CD97B), Color(0xFF0BA35E)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "LOG IN",
                              style: opensansSemiBold.copyWith(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t Have An Account? ",
                      style: opensansSemiBold.copyWith(
                        color: ColorResources.blackgrey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Register Now",
                        style: opensansSemiBold.copyWith(
                          color: ColorResources.blueeebutton,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Input Decoration
  InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
