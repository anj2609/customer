import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/style.dart';

class MembershipPlanController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<MembershipPlan> planList = <MembershipPlan>[].obs;

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/front/membership-plan-list",
      );

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          planList.value = List<MembershipPlan>.from(
            jsonData["data"].map((x) => MembershipPlan.fromJson(x)),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> activatePlan(String planId) async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/activate-plan",
      );

      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {"plan_id": planId},
      );

      var data = jsonDecode(response.body);

      if (data["status"] == true) {
        Get.defaultDialog(
          title: "Success",
          titleStyle: opensansBold.copyWith(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),

          middleText: data["message"] ?? "Plan Activated Successfully!",
          middleTextStyle: opensansMedium.copyWith(
            color: Colors.black87,
            fontSize: 16,
          ),

          textConfirm: "OK",
          confirmTextColor: Colors.white,

          buttonColor: ColorResources.primarycolor3,

          onConfirm: () {
            Get.back();
          },
        );
      } else {
        Get.snackbar("Error", data["message"] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchPlans();
    super.onInit();
  }
}

class MembershipPlan {
  final String id;
  final String name;
  final int price;

  MembershipPlan({required this.id, required this.name, required this.price});

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      price: json["price"] ?? 0,
    );
  }
}
