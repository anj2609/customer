import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController2 extends GetxController implements GetxService {
  var isLoading = false.obs;

  var nameShow = 2.obs;
  var emailShow = 2.obs;
  var customerIdShow = 2.obs;
  var photoShow = 2.obs;
  var dobShow = 2.obs;
  var workWithShow = 2.obs;
  var incomeShow = 2.obs;

  Future<void> getProfileSetting() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      isLoading(true);

      var response = await http.get(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/get-profile-information-setting-list",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["status"] == true) {
        var d = data["data"];

        nameShow.value = d["name_show"] ?? 2;
        emailShow.value = d["email_show"] ?? 2;
        customerIdShow.value = d["customer_id_show"] ?? 2;
        photoShow.value = d["photo_show"] ?? 2;
        dobShow.value = d["date_of_birth_show"] ?? 2;
        workWithShow.value = d["work_with_show"] ?? 2;
        incomeShow.value = d["income_show"] ?? 2;
      }
    } catch (e) {
      print("GET ERROR: $e");
    } finally {
      isLoading(false);
    }
  }
}
