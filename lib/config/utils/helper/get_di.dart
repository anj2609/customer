import 'package:evfual/data/controller/plan_list.dart';
import 'package:evfual/data/controller/profile_update.dart';
import 'package:evfual/data/controller/subscription_list.dart';
import 'package:evfual/data/controller/swap_history.dart';
import 'package:evfual/data/controller/swap_station.dart';
import 'package:evfual/data/controller/user_profile.dart';
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
  Get.lazyPut(() => SubscriptionController());
  Get.lazyPut(() => UserProfileController());
  Get.lazyPut(() => NearestSwapStationController());
  Get.lazyPut(() => PlanController());
  Get.lazyPut(() => SwapController());
  Get.lazyPut(() => ProfileController());
  return _languages;
}
