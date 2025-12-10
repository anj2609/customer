import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileHideController extends GetxController implements GetxService{
  RxBool isLoading = false.obs;
final RxInt showStatus = 0.obs;

  Rx<ProfileHideModel> data = ProfileHideModel().obs;

  String baseUrl =
      "https://vivashri.com/vivashribackend/api/user/get-profile-hide";

  Future<void> fetchProfileHide() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
     // isLoading.value = true;

      var response = await http.get(
        Uri.parse(baseUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        data.value = ProfileHideModel.fromJson(jsonData["data"]);
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

class ProfileHideModel {
  int? profileShow;
  int? profileDelete;

  ProfileHideModel({this.profileShow, this.profileDelete});

  factory ProfileHideModel.fromJson(Map<String, dynamic> json) {
    return ProfileHideModel(
      profileShow: json["profile_show"],
      profileDelete: json["profile_delete"],
    );
  }
}
