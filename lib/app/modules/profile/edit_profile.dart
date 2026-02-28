import 'dart:io';

import 'package:evfual/data/controller/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/drawer.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final controller = Get.put(EditProfileController());
  Widget field11(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        maxLength: 10,
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterText: '',
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget imagePicker(String title, Rx<File?> img, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Obx(() {
            return Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white),
              ),
              child: img.value != null
                  ? Image.file(img.value!, fit: BoxFit.cover)
                  : const Icon(Icons.add_a_photo, color: Colors.white),
            );
          }),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomAppDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/iPhone2.png", fit: BoxFit.cover),
          ),

          Column(
            children: [
              SizedBox(
                height: 160,
                width: double.infinity,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                            Image.asset(
                              'assets/images/logo.png',
                              height: 60,
                              width: 100,
                            ),

                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                "assets/images/user 1.png",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Center(
                            child: Text(
                              "Edit Profile",
                              style: opensansSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              controller.pickImage(controller.profileImage),
                          child: Obx(() {
                            return CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade300,
                              backgroundImage:
                                  controller.profileImage.value != null
                                  ? FileImage(controller.profileImage.value!)
                                  : (controller.profileimagee != null &&
                                        controller.profileimagee!.isNotEmpty)
                                  ? NetworkImage(
                                      'https://evfuel.akslearning.in/${controller.profileimagee}',
                                    )
                                  : const AssetImage(
                                      'assets/images/user 1.png',
                                    ),
                            );
                          }),
                        ),

                        const SizedBox(height: 20),

                        field("EV Number", controller.evController),
                        field("Owner Name", controller.nameController),
                        field("Address", controller.addressController),
                        field11("Phone", controller.phoneController),
                        field("Email", controller.emailController),

                        const SizedBox(height: 10),

                        imagePicker(
                          "RC Copy",
                          controller.rcImage,
                          () => controller.pickImage(controller.rcImage),
                        ),
                        imagePicker(
                          "ID Proof",
                          controller.idImage,
                          () => controller.pickImage(controller.idImage),
                        ),
                        imagePicker(
                          "Vehicle Photo",
                          controller.vehicleImage,
                          () => controller.pickImage(controller.vehicleImage),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: controller.saveProfile,
                            child: const Text("Update Profile"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget profileItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              value?.isNotEmpty == true ? value! : "—",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
