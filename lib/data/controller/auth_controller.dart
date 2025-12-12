import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/Deshboard/buttom_navigation.dart';
import 'package:vivashri/app/modules/auth/login_otp.dart';
import 'package:vivashri/app/modules/profilefrom/basic_details.dart';
import 'package:vivashri/app/modules/profilefrom/contact_details.dart';
import 'package:vivashri/app/modules/profilefrom/religition_details.dart';
import 'package:vivashri/config/route.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/data/controller/userprofile.dart';
import 'package:vivashri/data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});
  final userC = Get.put(UserDetailController());

  Future<Response> userloginapi({
    required BuildContext context,
    String? mobileemail,
  }) async {
    EasyLoading.show();
    update();

    Response response = await authRepo.usersignup(
      numberemail: mobileemail!.trim(),
    );

    if (response.statusCode == 200) {
      print(':::::::::${response.body['user_id']}');
      EasyLoading.dismiss();
      Get.snackbar(
        'Success',
        'OTP has been sent successfully to your number $mobileemail.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.to(
        OtpScreen(
          mobileemail: mobileemail,
          userid: '${response.body['user_id']}',
        ),
        duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
        transition: Transition.rightToLeft,
      );
    } else if (response.statusCode == 422) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        response.body['message'],
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      EasyLoading.dismiss();
    }

    update();
    return response;
  }
  //=-=--=-=-=-=--=-=-otp-verify-=-=-=-=-=-=-=-=-=-==-=

  Future<Response> ortverifyapi({
    required BuildContext context,
    required String userid,
    required String otp,
    required String devicetoken,
    required String mobilenu7mber,
  }) async {
    EasyLoading.show();
    update();

    Response response = await authRepo.otpverifyapi(
      useridd: userid,
      otp: otp,
      devicetoken: devicetoken,
    );

    if (response.statusCode == 200) {
      print(':::::::::${response.body['user_id']}');

      authRepo.saveUserToken(response.body['token'].toString());
      authRepo.saveUserprofileid(userid);

      EasyLoading.dismiss();

      /// ✔ step navigation call
      await checkUser(userid, mobilenu7mber);
    } else if (response.statusCode == 422) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        response.body['message'],
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      EasyLoading.dismiss();
    }

    update();
    return response;
  }

  Future<void> checkUser(userid, mobileemail) async {
    await userC.fetchUserDetail(userid);

    final step = userC.userData.value?.appStep;

    if (step is String) {
      Get.offAll(
        MainNavigation(),
        duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
        transition: Transition.rightToLeft,
      );

      return;
    }

    // 0 to 18 but skip 4
    if (step is int) {
      switch (step) {
        case 0:
          Get.offAll(
            BasicDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
          break;
        case 1:
          Get.offAll(
            ContactDetailsScreen(mobileemail: mobileemail),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
          break;
        // case 2:
        //   Get.offAll(
        //     AadharVerificationScreen(),
        //     duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
        //     transition: Transition.rightToLeft,
        //   );
        //   break;
        // case 3:
        //   Get.offAll(
        //     AadharOtpScreen(),
        //     duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
        //     transition: Transition.rightToLeft,
        //   );
        //   break;

        // 4 skip

        case 4:
          Get.offAll(
            ReligionDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
          break;

        default:
          Get.offAll(
            MainNavigation(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
      }
    }
  }

  String? getAuthToken() {
    return authRepo.getUserToken();
  }

  String? getAuthprofileid() {
    return authRepo.getUserprofileid();
  }

  void logOut() {
    Get.offNamed(RouteHelper.getLoginRoute());
    return authRepo.removeUserToken();
  }
}
