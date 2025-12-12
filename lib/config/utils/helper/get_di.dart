import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/apis/api_client.dart';
import 'package:vivashri/data/controller/accept_interest.dart';
import 'package:vivashri/data/controller/auth_controller.dart';
import 'package:vivashri/data/controller/check_percentage.dart';
import 'package:vivashri/data/controller/fromcontroller.dart';
import 'package:vivashri/data/controller/profile_delete.dart';
import 'package:vivashri/data/controller/profile_info_contro.dart';
import 'package:vivashri/data/controller/send_interest.dart';
import 'package:vivashri/data/controller/settingcontroller.dart';
import 'package:vivashri/data/controller/userbyuser.dart';
import 'package:vivashri/data/repository/auth_repo.dart';
import 'package:vivashri/data/repository/home_repo.dart';

Future<Map<String, Map<String, String>>> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences, fenix: true);

  Map<String, Map<String, String>> _languages = Map();
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut<ApiClient>(
    () => ApiClient(sharedPreferences: Get.find()),
    fenix: true,
  );

  Get.lazyPut(
    () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  );

  Get.lazyPut(() => HomeRepo(apiClient: Get.find()));
  Get.lazyPut(() => StaperfromController());
  Get.lazyPut(() => NotificationController());
  Get.lazyPut(() => NotificationController2());
  Get.lazyPut(() => ProfileHideController());
  Get.lazyPut(() => UserbyUserDetailController());
  Get.lazyPut(() => CheckProfileController());
  Get.lazyPut(() => SentInterestController());
  Get.lazyPut(() => StatusController());
  return _languages;
}
