import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/data/modal/user_by_user.dart';
import 'dart:convert';

// IMPORT YOUR FULL MODEL

class UserbyUserDetailController extends GetxController implements GetxService {
  var isLoading = false.obs;

  /// Member Data (inside data.memberData)
  Rx<MemberData?> memberData = Rx<MemberData?>(null);

  /// Partner Preferences (inside data.partnerPreferences)
  Rx<PartnerPreferences?> partnerPreferences = Rx<PartnerPreferences?>(null);

  Future<void> fetchUserDetail(String memberId) async {
    isLoading.value = true;

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
        /// Parse full model
        final data = profileResponseFromJson(response.body);

        /// Assign memberData
        memberData.value = data.data?.memberData;

        /// Assign partnerPreferences
        partnerPreferences.value = data.data?.partnerPreferences;
      } else {
        print("API ERROR: ${response.body}");
      }
    } catch (e) {
      print("EXCEPTION: $e");
    }

    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchUserDetail("6936652a84657cc55c8540e5");
    super.onInit();
  }
}
