import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';

import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';

import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.find<ProfileController>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  String selectedGender = "Male";
  List<String> genderList = ["Male", "Female", "Other"];

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 70, // Compress image
    );

    if (image != null) {
      final File compressedFile = await compressImage(File(image.path));

      setState(() {
        selectedImage = compressedFile;
      });
    }
  }

  Future<File> compressImage(File file) async {
    final String targetPath =
        '${file.parent.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );

    return File(result!.path);
  }

  // Future<void> pickImage(ImageSource source) async {
  //   final XFile? image = await _picker.pickImage(source: source);
  //   if (image != null) {
  //     setState(() {
  //       selectedImage = File(image.path);
  //     });
  //   }
  // }

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // phoneController.text = "+91${widget.phonenumber}";
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
          "Edit Personal Info",
          style: PoppinsMedium.copyWith(color: Colors.black, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: PremiumBlurLoader());
            }
            nameController.text = controller.nameController.text;
            emailController.text = controller.emailController.text;
            phoneController.text = controller.phoneController.text;
            dobController.text = controller.dobController.text;

            // Gender safe set
            String apiGender = controller.genderController.text;

            if (genderList.contains(apiGender)) {
              selectedGender = apiGender;
            } else {
              selectedGender = "Male"; // default fallback
            }
            // DateTime date = DateTime.parse(controller.dobController.text);
            // dobController.text = DateFormat('yyyy-MM-dd').format(date);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                /// Profile Image
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : (controller.profileimagee != null &&
                                  controller.profileimagee!.isNotEmpty)
                            ? NetworkImage(
                                "${ApiConstants.imageurl}${controller.profileimagee}",
                              )
                            : null,
                        child:
                            selectedImage == null &&
                                (controller.profileimagee == null ||
                                    controller.profileimagee!.isEmpty)
                            ? Icon(Icons.person, size: 50, color: Colors.grey)
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

                buildLabel("Phone Number"),
                controller.phoneController.text == ''
                    ? Container(
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
                                //readOnly: true,
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
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

                      // if (controller.dobController != null) {
                      //   controller.dobController.text = DateFormat(
                      //     'yyyy-MM-dd',
                      //   ).format(pickedDate);
                      // }
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
                  text: "Continue",
                  onTap: () {
                    
                    try {
                      String num = controller.phoneController.text.toString();
                      showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => PremiumBlurLoader(),
                    );

                      Get.find<ProfileController>().updatePersonalInfoApi(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        gender: selectedGender.toString(),
                        dob: dobController.text.toString(),
                        phonebumer: num.isNotEmpty
                            ? num
                            : phoneController.text.toString(),
                        profileimage: selectedImage,
                        oldProfile: controller.profileimagee.toString(),
                        context: context,
                      );
                    } catch (e) {
                      debugPrint('updateVehicleDocument Error: $e');
                    } finally {
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }
                    }
                    // Get.find<ProfileController>().updatePersonalInfoApi(
                    //   name: nameController.text.trim(),
                    //   email: emailController.text.trim(),
                    //   gender: selectedGender.toString(),
                    //   dob: dobController.text.toString(),
                    //   phonebumer: num.isNotEmpty ? num : phoneController.text.toString(),
                    //   profileimage: selectedImage,
                    //   oldProfile: controller.profileimagee.toString(),
                    //   context: context,
                    // );
                  },
                ),

                const SizedBox(height: 25),
              ],
            );
          }),
        ),
      ),
    );
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
          Expanded(
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
