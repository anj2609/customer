import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/data/controller/match_list.dart';
import 'package:vivashri/data/controller/recived_interst.dart';

class SentInterestController extends GetxController implements GetxService {
  var isLoading = false.obs;
  final searchC = Get.put(SearchmatchController());
  final inboxCtrl = Get.put(InboxReceivedController());

  Future<void> sendInterest(String partnerId) async {
    try {
      EasyLoading.show();
      // isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      var body = jsonEncode({"partner_id": partnerId});

      var response = await http.post(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/sent-interest",
        ),
        headers: headers,
        body: body,
      );

      var res = jsonDecode(response.body);

      if (res["status"] == true) {
        EasyLoading.dismiss();
        searchC.fetchSearchList("", "");
        Get.snackbar(
          "Success",
          res["message"] ?? "Success",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          res["message"] ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  //
  Future<void> sendshortlisted(String partnerId) async {
    try {
     // EasyLoading.show();
      // isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      var body = jsonEncode({"partner_id": partnerId});

      var response = await http.post(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/send-shortlist",
        ),
        headers: headers,
        body: body,
      );

      var res = jsonDecode(response.body);

      if (res["status"] == true) {
        EasyLoading.dismiss();
        searchC.fetchSearchList("", "");

        // Get.snackbar(
        //   "Success",
        //   res["message"] ?? "Success",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          res["message"] ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  Future<void> removeshortlisted(String partnerId) async {
    try {
     // EasyLoading.show();
      // isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      var body = jsonEncode({"partner_id": partnerId});

      var response = await http.post(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/shortlist-remove",
        ),
        headers: headers,
        body: body,
      );

      var res = jsonDecode(response.body);

      if (res["status"] == true) {
        EasyLoading.dismiss();
        searchC.fetchSearchList("", "");
        inboxCtrl.shortlistedprofileinboxdata();
        // Get.snackbar(
        //   "Success",
        //   res["message"] ?? "Success",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          res["message"] ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }
}
