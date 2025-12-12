import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/data/modal/user_by_user.dart';
import 'dart:convert';

class UserbyUserDetailController extends GetxController implements GetxService {
  var isLoading = false.obs;

  Rx<MemberData?> memberData = Rx<MemberData?>(null);
  Rx<ProfileResponse?> fullResponse = Rx<ProfileResponse?>(null);

  Rx<PartnerPreferences?> partnerPreferences = Rx<PartnerPreferences?>(null);
  void debugJson(dynamic json, [String prefix = ""]) {
    if (json is Map) {
      json.forEach((key, value) {
        final newPrefix = prefix.isEmpty ? key : "$prefix.$key";

        if (value is Map) {
          debugJson(value, newPrefix);
        } else if (value is List) {
          for (var i = 0; i < value.length; i++) {
            debugJson(value[i], "$newPrefix[$i]");
          }
        } else if (value is String) {
          print("⚠ String FOUND at: $newPrefix => '$value'");
        }
      });
    }
  }

  Future<void> fetchUserDetail(String memberId) async {
    isLoading.value = true;
    print('Memberid::::::${memberId}');
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/get-member-profile",
      );

      final body = jsonEncode({"member_id": memberId});

      final response = await http.post(
        url,
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("USER PROFILE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = profileResponseFromJson(response.body);
        fullResponse.value = data;

        memberData.value = data.data?.memberData;

        partnerPreferences.value = data.data?.partnerPreferences;
      } else {
        print("API ERROR: ${response.body}");
      }
    } catch (e) {
      print("EXCEPTION: $e");
    }

    isLoading.value = false;
  }
}
