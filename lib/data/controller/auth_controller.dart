import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/auth/login_otp.dart';
import 'package:vivashri/app/modules/profilefrom/basic_details.dart';
import 'package:vivashri/config/route.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

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
    String? userid,
    String? otp,
    String? devicetoken,
  }) async {
    EasyLoading.show();
    update();

    Response response = await authRepo.otpverifyapi(
      useridd: userid!.trim(),
      otp: otp,
      devicetoken: devicetoken,
    );

    if (response.statusCode == 200) {
      print(':::::::::${response.body['user_id']}');
      EasyLoading.dismiss();
      authRepo.saveUserToken(response.body['token'].toString());
      Get.to(
        BasicDetailsScreen(),
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
    //=-=-=-=-=-=-=-=-=-=- basic From-=-=-=-=-=-=-=-=-=-=-=-

    update();
    return response;
  }

  String? getAuthToken() {
    return authRepo.getUserToken();
  }

  void logOut() {
    Get.offNamed(RouteHelper.getLoginRoute());
    return authRepo.removeUserToken();
  }
}
