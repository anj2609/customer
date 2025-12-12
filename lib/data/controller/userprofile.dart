// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// import 'package:vivashri/data/modal/usermodal.dart';

// class UserDetailController extends GetxController {
//   RxBool isLoading = false.obs;
//   Rx<UserData?> userData = Rx<UserData?>(null);

//   Future<void> fetchUserDetail(String userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");

//     try {
//       isLoading.value = true;

//       final url =
//           "https://vivashri.com/vivashribackend/api/user/user-detail-all/$userId";

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         final result = UserDetailAllModel.fromJson(json.decode(response.body));

//         if (result.data != null && result.data!.isNotEmpty) {
//           userData.value = result.data!.first;
//         }
//         update();
//       } else {
//         print("API Error : ${response.statusCode}");
//         print("Response : ${response.body}");
//       }
//     } catch (e) {
//       print("Error : $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:vivashri/data/modal/usermodal.dart';
import 'package:vivashri/widgets/serverpage.dart';

class UserDetailController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<UserData?> userData = Rx<UserData?>(null);

  Future<void> fetchUserDetail(String userId, {bool fromRetry = false}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      isLoading.value = true;

      final url =
          "https://vivashri.com/vivashribackend/api/user/user-detail-all/$userId";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403 ||
          response.statusCode == 404 ||
          response.statusCode >= 500) {
        if (!fromRetry) {
          Get.to(() => ServerMaintenancePage());
        }
        return;
      }

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData["status"] == true) {
          final result = UserDetailAllModel.fromJson(jsonData);

          if (result.data.isNotEmpty) {
            userData.value = result.data.first;
          }
        } else {
          Get.to(() => ServerMaintenancePage());
        }
      } else {
        Get.to(() => ServerMaintenancePage());
      }
    } catch (e) {
      print("Error : $e");
      if (!fromRetry) Get.to(() => ServerMaintenancePage());
    } finally {
      isLoading.value = false;
    }
  }
}
