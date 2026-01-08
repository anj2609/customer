import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController evController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  File? rcImage;
  File? idImage;
  File? vehicleImage;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(Function(File) onPicked) async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      onPicked(File(file.path));
    }
  }

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
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: Image.asset(
                        "assets/images/register.png",
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 40,
                      left: 16,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  "REGISTER NOW",
                  style: opensansSemiBold.copyWith(
                    fontSize: 22,

                    color: ColorResources.primarycolor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Please Register to get credential",
                  style: opensansSemiBold.copyWith(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _field("EV Number", evController),
                      _field("Password", passwordController, isPassword: true),
                      _field(
                        "Confirm Password",
                        confirmPasswordController,
                        isPassword: true,
                        confirm: true,
                      ),
                      _field("Owner Name", ownerController),

                      /// 📷 EV RC COPY
                      _imagePickerTile(
                        title: "EV RC Copy",
                        file: rcImage,
                        onTap: () => pickImage((f) {
                          setState(() => rcImage = f);
                        }),
                      ),

                      /// 📷 ID PROOF
                      _imagePickerTile(
                        title: "ID Proof",
                        file: idImage,
                        onTap: () => pickImage((f) {
                          setState(() => idImage = f);
                        }),
                      ),

                      /// 📷 VEHICLE PHOTO
                      _imagePickerTile(
                        title: "Vehicle Photo",
                        file: vehicleImage,
                        onTap: () => pickImage((f) {
                          setState(() => vehicleImage = f);
                        }),
                      ),

                      _field("Address", addressController, maxLines: 3),
                      _field(
                        "Phone Number",
                        phoneController,
                        keyboard: TextInputType.phone,
                      ),
                      _field(
                        "Email ID",
                        emailController,
                        keyboard: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (rcImage == null ||
                                    idImage == null ||
                                    vehicleImage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please upload all images"),
                                    ),
                                  );
                                  return;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registration Successful"),
                                  ),
                                );
                              }
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00D672),
                                    Color(0xFF198D5A),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  "REGISTER",
                                  style: opensansSemiBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// LOGIN LINK
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already Have An Account? ",
                            style: opensansSemiBold.copyWith(
                              color: ColorResources.blackgrey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Login Now",
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 TEXT FIELD
  Widget _field(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    bool confirm = false,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: _decoration(hint),
        validator: (v) {
          if (v == null || v.isEmpty) return "$hint is required";
          if (confirm && v != passwordController.text) {
            return "Password not match";
          }
          if (hint == "Phone Number" && v.length < 10) {
            return "Enter valid phone number";
          }
          if (hint == "Email ID" && !v.contains("@")) {
            return "Enter valid email";
          }
          return null;
        },
      ),
    );
  }

  /// 🔹 IMAGE PICK TILE + THUMBNAIL
  Widget _imagePickerTile({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(title, style: opensansSemiBold.copyWith()),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 48,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Browse')),
            ),
          ),

          if (file != null) ...[
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(file, height: 40, width: 40, fit: BoxFit.cover),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: opensansSemiBold.copyWith(),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
