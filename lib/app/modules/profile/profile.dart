import 'dart:io';
import 'package:mobile_number/mobile_number.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';

import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

class ProfilePage extends StatefulWidget {
  final String? phonenumber;

  ProfilePage({super.key, this.phonenumber});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Get.find<ProfileController>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  String selectedGender = "Male";
  List<String> genderList = ["Male", "Female", "Other"];

  File? selectedImage;
  bool _isSubmitting = false;
  final ImagePicker _picker = ImagePicker();

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String? phoneNumber;
  @override
  void initState() {
    super.initState();
       phoneController.text = widget.phonenumber ?? '';
   /// getNumber();
  }

  Future<void> getNumber() async {
    try {
      String? mobileNumber = await MobileNumber.mobileNumber;

      if (mobileNumber != null && mobileNumber.startsWith("9191")) {
        phoneNumber = mobileNumber.substring(4);
      }
      phoneController.text = phoneNumber!.isNotEmpty
          ? phoneNumber!
          : (widget.phonenumber ?? '');
      nameController.text = ApiConstants.usernames;
      emailController.text = ApiConstants.emailAddress;

      print('get social provider ${ApiConstants.provider}');
      print("Number: $phoneNumber");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorResources.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "Fill Personal Info",
          style: PoppinsMedium.copyWith(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),

              /// Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : null,
                      child: selectedImage == null
                          ? Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.grey.shade500,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: showImageSourceDialog,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              buildLabel("Full Name"),
              buildTextField(nameController),

              const SizedBox(height: 22),

              buildLabel("Email"),
              buildTextField(emailController, icon: Icons.mail_outline),

              const SizedBox(height: 22),

              /// Phone with Flag
              buildLabel("Phone Number"),
              // widget.phonenumber != null
              //     ?
                   Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFF1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Text("🇮🇳", style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              controller: phoneController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                
                  // : Container(
                  //     height: 55,
                  //     padding: const EdgeInsets.symmetric(horizontal: 15),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFEFEFF1),
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         const Text("🇮🇳", style: TextStyle(fontSize: 18)),
                  //         const SizedBox(width: 6),
                  //         const Icon(Icons.keyboard_arrow_down, size: 18),
                  //         const SizedBox(width: 10),
                  //         Expanded(
                  //           child: TextField(
                  //             readOnly: false,
                  //             controller: phoneController,
                  //             decoration: const InputDecoration(
                  //               border: InputBorder.none,
                  //             ),
                  //             keyboardType: TextInputType.number,
                  //             inputFormatters: [
                  //               FilteringTextInputFormatter.digitsOnly,
                  //               LengthLimitingTextInputFormatter(10),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),

              const SizedBox(height: 22),

              buildLabel("Gender"),
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFF1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGender,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genderList
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: PoppinsMedium),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 22),

              buildLabel("Date of Birth"),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    dobController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

                    dobController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(pickedDate);
                  }
                },
                child: AbsorbPointer(
                  child: buildTextField(
                    dobController,
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 40),
              CustomPrimaryButton(
                text: _isSubmitting ? "Saving..." : "Continue",
                onTap: () async {
                  if (_isSubmitting) return;

                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();
                  final email = emailController.text.trim();
                  final dob = dobController.text.trim();

                  if (name.isEmpty) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please enter your full name.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  if (phone.isEmpty) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please enter your phone number.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  if (email.isEmpty) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please enter your email address.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  if (!GetUtils.isEmail(email)) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please enter a valid email address.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  if (dob.isEmpty) {
                    AnimatedTopToast.show(
                      context: context,
                      message: "Please select your date of birth.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                    return;
                  }

                  setState(() => _isSubmitting = true);

                  try {
                    await Get.find<AuthController>().fillPersonalInfoApi(
                      name: name,
                      email: email,
                      gender: selectedGender,
                      dob: dob,
                      profileimage: selectedImage,
                      context: context,
                    );
                  } catch (e) {
                    debugPrint('fillPersonalInfoApi Error: $e');
                    AnimatedTopToast.show(
                      context: context,
                      message: "Something went wrong. Please try again.",
                      backgroundColor: ColorResources.textColorBaclColor,
                      icon: Icons.error_outline,
                    );
                  } finally {
                    if (mounted) setState(() => _isSubmitting = false);
                  }
                  // Get.find<AuthController>().fillPersonalInfoApi(
                  //   name: nameController.text.trim(),
                  //   email: emailController.text.trim(),
                  //   gender: selectedGender.toString(),
                  //   dob: dob,
                  //   profileimage: selectedImage,
                  //   context: context,
                  // );
                },
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image != null) {
      File file = File(image.path);

      // 🔽 Compress again for safety
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 800,
        minHeight: 800,
        quality: 70,
      );

      File compressedFile = file;

      if (result != null) {
        compressedFile = File(file.path)..writeAsBytesSync(result);
      }

      // 🔍 Final size check (optional but recommended)
      int sizeInKB = compressedFile.lengthSync() ~/ 1024;

      if (sizeInKB > 2048) {
        Get.snackbar("Error", "Image must be less than 2MB");
        return;
      }

      setState(() {
        selectedImage = compressedFile;
      });
    }
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: PoppinsMedium.copyWith(fontSize: 14, color: Colors.black),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, {IconData? icon}) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFF1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 10),
          ],
          (ApiConstants.usernames.isNotEmpty ||
                  ApiConstants.emailAddress.isNotEmpty)
              ? Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: true,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                )
              : Expanded(
                  child: TextField(
                    controller: controller,
                    
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
        ],
      ),
    );
  }
}
