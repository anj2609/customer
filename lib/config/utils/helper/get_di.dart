import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:evfual/config/utils/apis/api_client.dart';
import 'package:evfual/data/controller/auth_controller.dart';

import 'package:evfual/data/repository/auth_repo.dart';
import 'package:evfual/data/repository/home_repo.dart';

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

  return _languages;
}
