import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController implements GetxService {
  var isLoading = false.obs;

  var settings = NotificationSettingsModel().obs;
  Future<void> saveNotificationSettings({
    required int newInvitation,
    required int newAccepts,
    required int newMatches,
    required int newOffers,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    EasyLoading.show();

    try {
      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/save-notification-settings",
      );

      var body = {
        "new_invitation": newInvitation,
        "new_accepts": newAccepts,
        "new_matches": newMatches,
        "new_offers": newOffers,
      };
      print('data:::::${body}');
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      var json = jsonDecode(response.body);

      if (json["status"] == true) {
        EasyLoading.dismiss();
        // Get.snackbar(
        //   "Success",
        //   json["message"] ?? "Updated",
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          json["message"] ?? "Something went wrong",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.toString());
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  Future<void> fetchNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      isLoading.value = true;

      var response = await http.get(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/get-notification-settings",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("GET RESPONSE = ${response.body}");

      var data = jsonDecode(response.body);

      if (data["status"] == true) {
        settings.value = NotificationSettingsModel.fromJson(data["data"]);
        update();
      } else {
        Get.snackbar("Error", data["message"], colorText: Colors.white);
      }
    } catch (e) {
      print("ERROR = $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
    //==-=-=-=-=-=-=-=
  }

  //-=-=-=-=-=-=-=-=-=-=- profile
  Future<void> profileinfosetting({
    required int nameshow,
    required int emailshow,
    required int customerid,
    required int photoshow,
    required int dateofbirth,
    required int workwithshow,
    required int incomeshow,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    EasyLoading.show();

    try {
      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/save-profile-information-setting",
      );

      var body = {
        "name_show": nameshow,
        "email_show": emailshow,
        "customer_id_show": customerid,
        "photo_show": photoshow,
        "date_of_birth_show": dateofbirth,
        "work_with_show": workwithshow,
        "income_show": incomeshow,
      };
      print('data:::::${body}');
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      var json = jsonDecode(response.body);

      if (json["status"] == true) {
        EasyLoading.dismiss();
        // Get.snackbar(
        //   "Success",
        //   json["message"] ?? "Updated",
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          json["message"] ?? "Something went wrong",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.toString());
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  //-=-=-=-=-=-=-=-=-=-=-=-=
  Future<void> hidedeelteprofile({
    required int profileshow,
    int? profiledelete,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    EasyLoading.show();

    try {
      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/save-profile-hide",
      );

      var body = {
        "profile_show": profileshow,
        // "profile_delete": profiledelete
      };
      print('data:::::${body}');
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      var json = jsonDecode(response.body);

      if (json["status"] == true) {
        EasyLoading.dismiss();
        // Get.snackbar(
        //   "Success",
        //   json["message"] ?? "Updated",
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          json["message"] ?? "Something went wrong",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.toString());
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  //=-=--=-=-=-=-=-=-=-==-=-=-=
  Future<void> phonesetting({
    required int privacysetting,
    // int? profiledelete,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    EasyLoading.show();

    try {
      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/save-profile-phone-setting",
      );

      var body = {"privacy_setting": privacysetting};
      print('data:::::${body}');
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      var json = jsonDecode(response.body);

      if (json["status"] == true) {
        EasyLoading.dismiss();
        // Get.snackbar(
        //   "Success",
        //   json["message"] ?? "Updated",
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          json["message"] ?? "Something went wrong",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar("Error", e.toString());
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
}

class NotificationSettingsModel {
  int? newInvitation;
  int? newAccepts;
  int? newMatches;
  int? newOffers;

  NotificationSettingsModel({
    this.newInvitation,
    this.newAccepts,
    this.newMatches,
    this.newOffers,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      newInvitation: json["new_invitation"],
      newAccepts: json["new_accepts"],
      newMatches: json["new_matches"],
      newOffers: json["new_offers"],
    );
  }
}
