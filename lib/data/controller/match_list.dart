import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/search/search_list.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/data/modal/matchmodal.dart';

class SearchmatchController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<MatchListData> users = <MatchListData>[].obs;
  RxList<MatchListData> searchlistdata = <MatchListData>[].obs;

  String apiUrl = "https://vivashri.com/vivashribackend/api/front/search-list";

  Future<void> fetchSearchList(String todaymatch, String nearme) async {
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
        body: jsonEncode({
          "member_id": "$profileid",
          "my_matches": "1",
          "today_match": todaymatch,
          "near_me": nearme,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        SearchListModel model = SearchListModel.fromJson(data);
        users.value = model.data!;
        update();
      } else {
        print("API Error: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchprofileid({String? profileid}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      EasyLoading.show();

      final Map<String, dynamic> bodyMap = {"searchProfile_id": profileid};

      final bodyJson = jsonEncode(bodyMap);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: bodyJson,
      );

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var data = jsonDecode(response.body);
        SearchListModel model = SearchListModel.fromJson(data);
        searchlistdata.value = model.data!;
        Get.to(
          SearchListScreen(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      } else {
        print("❌ API Error: ${response.body}");
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchlist({
    String? profileid,
    String? searchgender,
    String? minage,
    String? maxage,
    String? maxheight,
    String? minheight,
    String? searchMaritalstatus,
    String? searchLanguage,
    String? searcheducation,
    String? relign,
    String? searccountry,
    String? searctate,
    String? annualincom,
    String? occupation,
    String? manglik,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      EasyLoading.show();

      final Map<String, dynamic> bodyMap = {
        // "member_id": "6936652a84657cc55c8540e5",
        // "my_matches":"1",
        "caste": [],
        "formDataMatch": {},
        "looking": null,
        "maxAge": maxage,
        "minAge": minage,
        "page": 1,
        "religion": [relign],
        "searchAnnual_income": [annualincom],
        "searchCity": [],
        "searchComplexion": [],
        "searchCountry": [searccountry],
        "searchDiet": [],
        "searchEducation": [searcheducation],
        "searchGender": "$searchgender",
        "searchHobbies": [],
        "searchLanguage": searchLanguage,
        "searchManaged_by": [],
        "searchManglik": manglik,
        "searchMarital_status": [null],
        "searchMaxHeight": maxheight,
        "searchMinHeight": minheight,
        "searchOccupation": occupation,
        "searchOrganization": [],
        "searchProfession": [],
        "searchProfile_id": null,
        "searchState": [searctate],
        "sortBy": 1,
        "today": null,
        "near_me": null,

        // "caste": [],
        // "formDataMatch": {},
        // "looking": null,
        // "maxAge": maxage.toString(),
        // "minAge": minage.toString(),
        // "page": 1,
        // "religion": [],
        // "searchAnnual_income": annualincom,
        // "searchCity": [],
        // "searchComplexion": [],
        // "searchCountry": [],
        // "searchDiet": [],
        // "searchEducation": [],
        // "searchGender": searchgender.toString(),
        // "searchHobbies": [],
        // "searchLanguage": searchLanguage.toString(),
        // "searchManaged_by": [],
        // "searchManglik": manglik.toString(),
        // "searchMarital_status": [null],
        // "searchMaxHeight": maxheight.toString(),
        // "searchMinHeight": minheight.toString(),
        // "searchOccupation": occupation.toString(),
        // "searchOrganization": [],
        // "searchProfession": [],
        // "searchProfile_id": null,
        // "searchState": [],
        // "sortBy": 1,
        // "today": null,
        // "near_me": null,
      };

      final bodyJson = jsonEncode(bodyMap);

      print("👉 REQUEST BODY GOING TO API:");
      print(bodyJson);
      print("------------------------------------");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: bodyJson,
      );

      print('👉 RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var data = jsonDecode(response.body);
        SearchListModel model = SearchListModel.fromJson(data);
        searchlistdata.value = model.data!;
        Get.to(
          SearchListScreen(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      } else {
        print("❌ API Error: ${response.body}");
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
