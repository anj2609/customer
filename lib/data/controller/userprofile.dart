import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vivashri/data/modal/usermodal.dart';

class UserDetailController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<UserData?> userData = Rx<UserData?>(null);

  Future<void> fetchUserDetail(String userId) async {
    try {
      isLoading.value = true;

      final url =
          "https://testing.akslearning.in/vivashribackend/api/user/user-detail-all/$userId";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final result = UserDetailAllModel.fromJson(json.decode(response.body));

        if (result.data != null && result.data!.isNotEmpty) {
          userData.value = result.data!.first;
        }
      }
    } catch (e) {
      print("Error : $e");
    } finally {
      isLoading.value = false;
    }
  }
}
