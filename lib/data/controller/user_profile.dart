import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileController extends GetxController implements GetxService {
  RxBool isLoading = false.obs;
  Rx<UserProfileModel?> profile = Rx<UserProfileModel?>(null);

  Future<void> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
     // isLoading(true);

      var response = await http.post(
        Uri.parse("https://evfuel.akslearning.in/api/user-profile"),
        headers: {"Accept": "application/json"},
        body: {"user_id": token},
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 200) {
        profile.value = UserProfileModel.fromJson(data["success"]);
      } else {
        Get.snackbar("Error", "Profile not found");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class UserProfileModel {
  int? id;
  String? evNumber;
  String? ownerName;
  String? evRcCopy;
  String? idProof;
  String? vehiclePhoto;
  int? status;
  String? address;
  String? phone;
  String? email;
  String? profilePhoto;

  UserProfileModel({
    this.id,
    this.evNumber,
    this.ownerName,
    this.evRcCopy,
    this.idProof,
    this.vehiclePhoto,
    this.status,
    this.address,
    this.phone,
    this.email,
    this.profilePhoto,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      evNumber: json['ev_number'],
      ownerName: json['owner_name'],
      evRcCopy: json['ev_rc_copy'],
      idProof: json['id_proof'],
      vehiclePhoto: json['vehicle_photo'],
      status: json['status'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      profilePhoto: json['profile_photo'],
    );
  }
}
