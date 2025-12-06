import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:vivashri/data/modal/deshbaord_match_modal.dart';

class MatchController extends GetxController {
  RxList<MatchUserModel> freeMatches = <MatchUserModel>[].obs;
  RxList<MatchUserModel> premiumMatches = <MatchUserModel>[].obs;

  RxBool isLoading = false.obs;

  Future<void> fetchMatches() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      isLoading(true);

      var response = await http.get(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/user/dashboard-matches",
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      var data = json.decode(response.body);

      if (data["status"] == true) {
        var free = data["data"]["usersFree"] as List;
        var premium = data["data"]["usersPremium"] as List;

        freeMatches.value = free.map((e) => MatchUserModel.fromJson(e)).toList();

        premiumMatches.value = premium
            .map((e) => MatchUserModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error => $e");
    } finally {
      isLoading(false);
    }
  }
}
