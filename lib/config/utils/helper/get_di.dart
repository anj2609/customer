import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/controller/chat_controller.dart';
import 'package:myrideuser/data/controller/payment_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';

import 'package:myrideuser/data/repository/booking_repo.dart';
import 'package:myrideuser/data/repository/chat_repo.dart';
import 'package:myrideuser/data/repository/profile_repo.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:myrideuser/config/utils/apis/api_client.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';

import 'package:myrideuser/data/repository/auth_repo.dart';
import 'package:myrideuser/data/repository/home_repo.dart';

Future<Map<String, Map<String, String>>> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut<SharedPreferences>(() => sharedPreferences, fenix: true);

  /// API CLIENT
  Get.lazyPut<ApiClient>(
    () => ApiClient(sharedPreferences: Get.find()),
    fenix: true,
  );

  /// REPOSITORIES
  Get.lazyPut<AuthRepo>(
    () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
    fenix: true,
  );

  Get.lazyPut<HomeRepo>(() => HomeRepo(apiClient: Get.find()), fenix: true);

  Get.lazyPut<BookingRepo>(
    () => BookingRepo(apiClient: Get.find()),
    fenix: true,
  );

  Get.lazyPut<ChatRepo>(() => ChatRepo(apiClient: Get.find()), fenix: true);

  Get.lazyPut<ProfiileRepo>(
    () => ProfiileRepo(apiClient: Get.find()),
    fenix: true,
  );

  /// CONTROLLERS
  Get.lazyPut<AuthController>(
    () => AuthController(authRepo: Get.find()),
    fenix: true,
  );

  Get.lazyPut<BookingController>(
    () => BookingController(bookingRepo: Get.find()),
    fenix: true,
  );

  Get.lazyPut<ProfileController>(
    () => ProfileController(profileRepo: Get.find()),
    fenix: true,
  );

  Get.lazyPut<ChatController>(
    () => ChatController(chatRepo: Get.find()),
    fenix: true,
  );

  Get.lazyPut<PaymentController>(
    () => PaymentController(bookingRepo: Get.find()),
    fenix: true,
  );

  return {};
}
