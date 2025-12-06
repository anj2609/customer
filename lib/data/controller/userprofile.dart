import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:vivashri/data/modal/usermodal.dart';

class UserDetailController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<UserData?> userData = Rx<UserData?>(null);

  Future<void> fetchUserDetail(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      isLoading.value = true;

      final url =
          "https://vivashri.com/vivashribackend/api/user/user-detail-all/$userId";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final result = UserDetailAllModel.fromJson(json.decode(response.body));

        if (result.data != null && result.data!.isNotEmpty) {
          userData.value = result.data!.first;
        }
        update();
      } else {
        print("API Error : ${response.statusCode}");
        print("Response : ${response.body}");
      }
    } catch (e) {
      print("Error : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
