import 'dart:io';
import 'package:evfual/data/modal/profileModel.dart';
import 'package:evfual/data/repository/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfiileRepo profileRepo;

  ProfileController({required this.profileRepo});
  RxBool isLoading = false.obs;
  Rx<ProfileModels> profile = ProfileModels().obs;

  final evController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();

  Rx<File?> profileImage = Rx<File?>(null);
  String? profileimagee;
  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  void fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      isLoading.value = true;

      final response = await profileRepo.profileRepoApi();
      if (response.statusCode == 200) {
        final body = response.body;

        if (body['code'] == "200") {
          final data = body['data'];

          profile.value = ProfileModels.fromJson(data);

          phoneController.text = profile.value.data!.userType ?? "";
          emailController.text = profile.value.data!.email ?? "";

          // nameController.text = profile.value.ownerName ?? "";
          // addressController.text = profile.value.address ?? "";
          genderController.text = profile.value.data!.gender ?? "";

          profileimagee = profile.value.data!.profileImage ?? "";
        } else {
          Get.snackbar("Error", body['message'] ?? "Something went wrong");
        }
      } else {
        Get.snackbar("Error", "Server Error: ${response.statusCode}");
      }
      //   final data = response['success'];

      //   profile.value = ProfileModels.fromJson(data);

      //   evController.text = profile.value.evNumber ?? "";
      //   nameController.text = profile.value.ownerName ?? "";
      //   addressController.text = profile.value.address ?? "";
      //   phoneController.text = profile.value.phone ?? "";
      //   emailController.text = profile.value.email ?? "";
      //   profileimagee = profile.value.profilePhoto ?? "";
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  void printAllData() {
    debugPrint("EV: ${evController.text}");
    debugPrint("Name: ${nameController.text}");
    debugPrint("Address: ${addressController.text}");
    debugPrint("Phone: ${phoneController.text}");
    debugPrint("Email: ${emailController.text}");
    debugPrint("Profile Image: ${profileImage.value?.path}");
  }
}

class ApiService {
  static const String baseUrl =
      "https://evfuel.akslearning.in/api/user-profile";

  static Future<Map<String, dynamic>> getProfile({
    required String userId,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        // "Authorization": "Bearer YOUR_TOKEN"
      },
      body: {"user_id": userId},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile");
    }
  }
}

// class ProfileModel {
//   int? id;
//   String? evNumber;
//   String? ownerName;
//   String? address;
//   String? phone;
//   String? email;
//   String? profilePhoto;

//   ProfileModel({
//     this.id,
//     this.evNumber,
//     this.ownerName,
//     this.address,
//     this.phone,
//     this.email,
//     this.profilePhoto,
//   });

//   factory ProfileModel.fromJson(Map<String, dynamic> json) {
//     return ProfileModel(
//       id: json['id'],
//       evNumber: json['ev_number'],
//       ownerName: json['owner_name'],
//       address: json['address'],
//       phone: json['phone'],
//       email: json['email'],
//       profilePhoto: json['profile_photo'],
//     );
//   }
// }
