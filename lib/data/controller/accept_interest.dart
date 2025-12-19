import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/data/controller/recived_interst.dart';

class StatusController extends GetxController implements GetxService {
  var isLoading = false.obs;
  final inboxCtrl = Get.put(InboxReceivedController());

  Future<void> changeStatus({
    required String id,
    required String status,
  }) async {
    isLoading.value = true;
    EasyLoading.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      var response = await http.post(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/status-change",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {"id": id, "status": status},
      );

      var data = jsonDecode(response.body);

      if (data["status"] == true) {
        EasyLoading.dismiss();
        inboxCtrl.fetchInboxData();
        Get.snackbar(
          "Success",
          data["message"] ?? "Status updated",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
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

  Future<void> photorequest({
    required String id,
    required String status,
  }) async {
    isLoading.value = true;
    EasyLoading.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      var response = await http.post(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/change-photo-request-status",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {"request_id": id, "status": status},
      );

      var data = jsonDecode(response.body);

      if (data["status"] == true) {
        EasyLoading.dismiss();
        inboxCtrl.photorecived();
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
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

  Future<void> dobrequest({required String id, required String status}) async {
    isLoading.value = true;
    EasyLoading.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      var response = await http.post(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/change-send-birth-request-status",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {"request_id": id, "status": status},
      );

      var data = jsonDecode(response.body);

      if (data["status"] == true) {
        EasyLoading.dismiss();
        inboxCtrl.dobrequest();
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
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
