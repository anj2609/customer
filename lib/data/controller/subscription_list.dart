import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController implements GetxService {
  var isLoading = false.obs;
  var subscriptionList = <SubscriptionModel>[].obs;

  Future<void> getSubscriptions() async {
    try {
      isLoading(true);

      var response = await http.post(
        Uri.parse("https://evfuel.akslearning.in/api/subscription-list"),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        subscriptionList.value = List.from(data['success'])
            .asMap()
            .entries
            .map((e) => SubscriptionModel.fromJson(e.value, e.key))
            .toList();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    getSubscriptions();
    super.onInit();
  }
}

class SubscriptionModel {
  int subscriptionId;
  String planName;
  String planPrice;
  String description;
  String validityDays;
  String freeSwap;
  String ratePerSwap;
  Color bgColor; // 👈 static color

  SubscriptionModel({
    required this.subscriptionId,
    required this.planName,
    required this.planPrice,
    required this.description,
    required this.validityDays,
    required this.freeSwap,
    required this.ratePerSwap,
    required this.bgColor,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json, int index) {
    // 👇 3 static colors
    final colors = [
      const Color(0xFF6CF47A), // Green
      const Color(0xFFFFE08A), // Blue
      const Color(0xFF74EEFF), // Orange
    ];

    return SubscriptionModel(
      subscriptionId: json['subscription_id'],
      planName: json['plan_name'],
      planPrice: json['plan_price'],
      description: json['description'],
      validityDays: json['validity_days'],
      freeSwap: json['free_swap'],
      ratePerSwap: json['rate_per_swap'],
      bgColor: colors[index % colors.length], // 👈 auto assign
    );
  }
}
