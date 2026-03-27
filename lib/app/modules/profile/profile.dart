import 'dart:io';
import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/constants.dart';

import 'package:evfual/config/utils/style.dart';
import 'package:evfual/data/controller/auth_controller.dart';
import 'package:evfual/data/controller/profile_controller.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final String? phonenumber;
  ProfilePage({super.key, this.phonenumber});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Get.find<ProfileController>();

  final TextEditingController nameController = TextEditingController(
    text: "Ansh Saxena",
  );

  final TextEditingController emailController = TextEditingController(
    text: "ansh@infinitetechsolution.com",
  );

  final TextEditingController phoneController = TextEditingController(
    text: "+91 9673645278",
  );

  final TextEditingController dobController = TextEditingController();

  String selectedGender = "Male";
  List<String> genderList = ["Male", "Female", "Other"];

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

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
    phoneController.text = "+91${widget.phonenumber}";
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
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return   
             Column(
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
                          :  AssetImage("${ApiConstants.baseUrl}${controller.profileimagee}")
                                as ImageProvider,
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
              buildTextField(controller.nameController),

              const SizedBox(height: 22),

              buildLabel("Email"),
              buildTextField(controller.emailController, icon: Icons.mail_outline),

              const SizedBox(height: 22),

              /// Phone with Flag
              buildLabel("Phone Number"),
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
                text: "Continue",
                onTap: () {
                  String phone = phoneController.text.trim();
                  String email = emailController.text.trim();
                  String dob = dobController.text.trim();

                  //dobController
                  if (phone.isEmpty) {
                    Get.snackbar(
                      'Error',
                      "Please enter phone number",
                      backgroundColor: ColorResources.textColorRed,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }

                  if (email.isEmpty) {
                    Get.snackbar(
                      'Error',
                      "Please enter email",
                      backgroundColor: ColorResources.textColorRed,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }

                  if (!GetUtils.isEmail(email)) {
                    Get.snackbar(
                      'Error',
                      "Please enter valid email",
                      backgroundColor: ColorResources.textColorRed,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }

                  if (selectedGender.isEmpty ||
                      selectedGender.toString().isEmpty) {
                    Get.snackbar(
                      'Error',
                      "Please select gender",
                      backgroundColor: ColorResources.textColorRed,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }
                  if (dob.isEmpty) {
                    Get.snackbar(
                      'Error',
                      "Please select Date of Birth",
                      backgroundColor: ColorResources.textColorRed,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }

                  ///dobController

                  if (selectedImage == null) {
                    Get.snackbar(
                      'Error',
                      "Please select profile image",
                      backgroundColor: ColorResources.textColorRed,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }
                  Get.find<AuthController>().fillPersonalInfoApi(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    gender: selectedGender.toString(),
                    dob: dob,
                    profileimage:selectedImage,
                    context: context,
                  );
                },
              ),

              // CustomPrimaryButton(
              //   text: "Continue",
              //   onTap: () {
              //     Get.find<AuthController>().fillPersonalInfoApi(
              //       phone: phoneController.text.trim(),
              //       email: emailController.text.trim(),
              //       gender: selectedGender.toString(),
              //       dob: selectedGender,
              //       profile_image: selectedImage!.path,
              //       context: context,
              //     );

              //   },
              // ),
              const SizedBox(height: 25),
            ],
          );
            //  Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Column(
            //     children: [
            //       /// Profile Image
            //       controller.profileimagee != null
            //           ? CircleAvatar(
            //               radius: 50,
            //               backgroundImage: NetworkImage(
            //                 "${ApiConstants.baseUrl}${controller.profileimagee}",
            //               ),
            //             )
            //           : const CircleAvatar(
            //               radius: 50,
            //               child: Icon(Icons.person),
            //             ),

            //       const SizedBox(height: 20),

            //       /// Phone
            //       TextField(
            //         controller: controller.phoneController,
            //         decoration: const InputDecoration(labelText: "Phone"),
            //       ),

            //       const SizedBox(height: 10),

            //       /// Email
            //       TextField(
            //         controller: controller.emailController,
            //         decoration: const InputDecoration(labelText: "Email"),
            //       ),
            //     ],
            //   ),
            // );
        
        
        
        
        
          }),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const SizedBox(height: 25),

          //     /// Profile Image
          //     Center(
          //       child: Stack(
          //         children: [
          //           CircleAvatar(
          //             radius: 55,
          //             backgroundColor: Colors.grey.shade300,
          //             backgroundImage: selectedImage != null
          //                 ? FileImage(selectedImage!)
          //                 : const AssetImage("assets/images/profile.png")
          //                       as ImageProvider,
          //           ),
          //           Positioned(
          //             bottom: 5,
          //             right: 5,
          //             child: GestureDetector(
          //               onTap: showImageSourceDialog,
          //               child: Container(
          //                 padding: const EdgeInsets.all(6),
          //                 decoration: const BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   color: Colors.blue,
          //                 ),
          //                 child: const Icon(
          //                   Icons.edit,
          //                   size: 15,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),

          //     const SizedBox(height: 35),

          //     buildLabel("Full Name"),
          //     buildTextField(nameController),

          //     const SizedBox(height: 22),

          //     buildLabel("Email"),
          //     buildTextField(emailController, icon: Icons.mail_outline),

          //     const SizedBox(height: 22),

          //     /// Phone with Flag
          //     buildLabel("Phone Number"),
          //     Container(
          //       height: 55,
          //       padding: const EdgeInsets.symmetric(horizontal: 15),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFEFEFF1),
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       child: Row(
          //         children: [
          //           const Text("🇮🇳", style: TextStyle(fontSize: 18)),
          //           const SizedBox(width: 6),
          //           const Icon(Icons.keyboard_arrow_down, size: 18),
          //           const SizedBox(width: 10),
          //           Expanded(
          //             child: TextField(
          //               readOnly: true,
          //               controller: phoneController,
          //               decoration: const InputDecoration(
          //                 border: InputBorder.none,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),

          //     const SizedBox(height: 22),

          //     buildLabel("Gender"),
          //     Container(
          //       height: 55,
          //       padding: const EdgeInsets.symmetric(horizontal: 15),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFEFEFF1),
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       child: DropdownButtonHideUnderline(
          //         child: DropdownButton<String>(
          //           value: selectedGender,
          //           isExpanded: true,
          //           icon: const Icon(Icons.keyboard_arrow_down),
          //           items: genderList
          //               .map(
          //                 (e) => DropdownMenuItem(
          //                   value: e,
          //                   child: Text(e, style: PoppinsMedium),
          //                 ),
          //               )
          //               .toList(),
          //           onChanged: (value) {
          //             setState(() {
          //               selectedGender = value!;
          //             });
          //           },
          //         ),
          //       ),
          //     ),

          //     const SizedBox(height: 22),

          //     buildLabel("Date of Birth"),
          //     GestureDetector(
          //       onTap: () async {
          //         DateTime? pickedDate = await showDatePicker(
          //           context: context,
          //           initialDate: DateTime(2000),
          //           firstDate: DateTime(1950),
          //           lastDate: DateTime.now(),
          //         );

          //         if (pickedDate != null) {
          //           dobController.text =
          //               "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

          //           dobController.text = DateFormat(
          //             'yyyy-MM-dd',
          //           ).format(pickedDate);

          //         }
          //       },
          //       child: AbsorbPointer(
          //         child: buildTextField(
          //           dobController,
          //           icon: Icons.calendar_today_outlined,
          //         ),
          //       ),
          //     ),

          //     const SizedBox(height: 40),
          //     CustomPrimaryButton(
          //       text: "Continue",
          //       onTap: () {
          //         String phone = phoneController.text.trim();
          //         String email = emailController.text.trim();
          //         String dob = dobController.text.trim();

          //         //dobController
          //         if (phone.isEmpty) {
          //           Get.snackbar(
          //             'Error',
          //             "Please enter phone number",
          //             backgroundColor: ColorResources.textColorRed,
          //             colorText: Colors.white,
          //             snackPosition: SnackPosition.TOP,
          //           );
          //           return;
          //         }

          //         if (email.isEmpty) {
          //           Get.snackbar(
          //             'Error',
          //             "Please enter email",
          //             backgroundColor: ColorResources.textColorRed,
          //             colorText: Colors.white,
          //             snackPosition: SnackPosition.TOP,
          //           );
          //           return;
          //         }

          //         if (!GetUtils.isEmail(email)) {
          //           Get.snackbar(
          //             'Error',
          //             "Please enter valid email",
          //             backgroundColor: ColorResources.textColorRed,
          //             colorText: Colors.white,
          //             snackPosition: SnackPosition.TOP,
          //           );
          //           return;
          //         }

          //         if (selectedGender.isEmpty ||
          //             selectedGender.toString().isEmpty) {
          //           Get.snackbar(
          //             'Error',
          //             "Please select gender",
          //             backgroundColor: ColorResources.textColorRed,
          //             colorText: Colors.white,
          //             snackPosition: SnackPosition.TOP,
          //           );
          //           return;
          //         }
          //         if (dob.isEmpty) {
          //           Get.snackbar(
          //             'Error',
          //             "Please select Date of Birth",
          //             backgroundColor: ColorResources.textColorRed,
          //             colorText: Colors.white,
          //             snackPosition: SnackPosition.TOP,
          //           );
          //           return;
          //         }

          //         ///dobController

          //         if (selectedImage == null) {
          //           Get.snackbar(
          //             'Error',
          //             "Please select profile image",
          //             backgroundColor: ColorResources.textColorRed,
          //             colorText: Colors.white,
          //             snackPosition: SnackPosition.TOP,
          //           );
          //           return;
          //         }
          //         Get.find<AuthController>().fillPersonalInfoApi(
          //           name: nameController.text.trim(),
          //           email: emailController.text.trim(),
          //           gender: selectedGender.toString(),
          //           dob: dob,
          //           profileimage:selectedImage,
          //           context: context,
          //         );
          //       },
          //     ),

          //     // CustomPrimaryButton(
          //     //   text: "Continue",
          //     //   onTap: () {
          //     //     Get.find<AuthController>().fillPersonalInfoApi(
          //     //       phone: phoneController.text.trim(),
          //     //       email: emailController.text.trim(),
          //     //       gender: selectedGender.toString(),
          //     //       dob: selectedGender,
          //     //       profile_image: selectedImage!.path,
          //     //       context: context,
          //     //     );

          //     //   },
          //     // ),
          //     const SizedBox(height: 25),
          //   ],
          // ),
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
