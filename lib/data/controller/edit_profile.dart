import 'dart:convert';
import 'dart:io';
import 'package:evfual/data/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileController extends GetxController {
  final evController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  Rx<File?> profileImage = Rx<File?>(null);
  Rx<File?> rcImage = Rx<File?>(null);
  Rx<File?> idImage = Rx<File?>(null);
  Rx<File?> vehicleImage = Rx<File?>(null);
  final procontroller = Get.put(ProfileController(profileRepo: Get.find()));

  final picker = ImagePicker();
  String? profileimagee;
  @override
  void onInit() {
    final data = Get.arguments;

    evController.text = data['ev'] ?? "";
    nameController.text = data['name'] ?? "";
    addressController.text = data['address'] ?? "";
    phoneController.text = data['phone'] ?? "";
    emailController.text = data['email'] ?? "";
    profileimagee = data['profileimage'] ?? "";

    super.onInit();
  }

  Future<void> pickImage(Rx<File?> target) async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      target.value = File(img.path);
    }
  }

  void saveProfile() {
    debugPrint("EV: ${evController.text}");
    debugPrint("Name: ${nameController.text}");
    debugPrint("Address: ${addressController.text}");
    debugPrint("Phone: ${phoneController.text}");
    debugPrint("Email: ${emailController.text}");
    debugPrint("Profile Img: ${profileImage.value?.path}");
    debugPrint("RC Img: ${rcImage.value?.path}");
    debugPrint("ID Img: ${idImage.value?.path}");
    debugPrint("Vehicle Img: ${vehicleImage.value?.path}");
    registerEV();
    Get.back();
  }

  Future<void> registerEV() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      var uri = Uri.parse("https://evfuel.akslearning.in/api/profile-update");
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'user_id': token!,

        'owner_name': nameController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        'email': emailController.text,
      });

      if (rcImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath('ev_rc_copy', rcImage.value!.path),
        );
      }
      if (idImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath('id_proof', idImage.value!.path),
        );
      }
      if (vehicleImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'vehicle_photo',
            vehicleImage.value!.path,
          ),
        );
      }
      if (profileImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_photo',
            profileImage.value!.path,
          ),
        );
      }

      request.headers['Accept'] = 'application/json';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decoded = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          decoded['message'] ?? 'Update Successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        procontroller.fetchProfile();
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        if (decoded['error'] != null) {
          String firstError = decoded['error'].values.first[0];

          Get.snackbar(
            'Error',
            firstError,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            decoded['message'] ?? 'Validation failed',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          decoded['message'] ?? 'Something went wrong',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint("Exception 👉 $e");
    }
  }
}
