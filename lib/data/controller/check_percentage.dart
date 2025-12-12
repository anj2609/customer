import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class CheckProfileController extends GetxController implements GetxService {
  var isLoading = false.obs;

  Rx<CheckProfileModel?> profileStatus = Rx<CheckProfileModel?>(null);

  Future<void> checkProfileComplete(String userId) async {
    try {
      isLoading(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/front/check-profile-complete",
      );

      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileStatus.value = CheckProfileModel.fromJson(jsonData);
      } else {
        print("API Error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }
}

class CheckProfileModel {
  final bool status;
  final dynamic completion;

  CheckProfileModel({required this.status, required this.completion});

  factory CheckProfileModel.fromJson(Map<String, dynamic> json) {
    return CheckProfileModel(
      status: json["status"] ?? false,
      completion: json["completion"] ?? "",
    );
  }
}
