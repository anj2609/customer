import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/auth/login_screen.dart';
import 'dart:convert';
import 'package:vivashri/data/modal/usermodal.dart';

class UserDetailController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<UserData?> userData = Rx<UserData?>(null);

  Future<void> fetchUserDetail(String userId, {bool fromRetry = false}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? profileid = prefs.getString("profileid");

    try {
      isLoading.value = true;

      final url =
          "https://vivashri.com/vivashribackend/api/user/user-detail-all/$profileid";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403 ||
          response.statusCode == 404 ||
          response.statusCode >= 500) {
        if (!fromRetry) {
          Get.offAll(() => LoginScreen());
        }
        return;
      }

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData["status"] == true) {
          final result = UserDetailAllModel.fromJson(jsonData);

          if (result.data.isNotEmpty) {
            userData.value = result.data.first;
          }
        } else {
          Get.offAll(() => LoginScreen());
        }
      } else {
        Get.to(() => LoginScreen());
      }
    } catch (e) {
      print("Error : $e");
      if (!fromRetry) Get.offAll(() => LoginScreen());
    } finally {
      isLoading.value = false;
    }
  }
}
