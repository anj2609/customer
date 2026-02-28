import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlanController extends GetxController implements GetxService {
  var isLoading = false.obs;
  var plan = Rxn<PlanModel>();

  Future<void> getPlanList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      isLoading(true);

      final response = await http.post(
        Uri.parse("https://evfuel.akslearning.in/api/plan-list"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": token}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 200) {
        plan.value = PlanModel.fromJson(data['success']);
      } else {
        Get.snackbar("Error", "Plan not found");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPlanList();
  }
}

class PlanModel {
  final String planName;
  final int totalSwap;
  final String validDateTill;

  PlanModel({
    required this.planName,
    required this.totalSwap,
    required this.validDateTill,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      planName: json['plan_name'] ?? '',
      totalSwap: json['total_swap'] ?? 0,
      validDateTill: json['valid_date_till'] ?? '',
    );
  }
}
