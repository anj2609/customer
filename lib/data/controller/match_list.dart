import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/data/modal/matchmodal.dart';

class SearchmatchController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<MatchListData> users = <MatchListData>[].obs;

  String apiUrl = "https://vivashri.com/vivashribackend/api/front/search-list";

  Future<void> fetchSearchList() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? profileid = prefs.getString("profileid");
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"member_id": "$profileid"}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        SearchListModel model = SearchListModel.fromJson(data);
        users.value = model.data;
      } else {
        print("API Error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
