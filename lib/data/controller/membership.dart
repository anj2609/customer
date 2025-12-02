import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
