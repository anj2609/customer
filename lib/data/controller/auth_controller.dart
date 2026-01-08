import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:evfual/app/modules/auth/login_otp.dart';

import 'package:evfual/config/route.dart';
import 'package:evfual/config/utils/constants.dart';
import 'package:evfual/data/repository/auth_repo.dart';

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

    EasyLoading.dismiss();

    final body = response.body;

    if (response.statusCode == 409 && body['status'] == "ALREADY_LOGGED_IN") {
      Get.dialog(
        CupertinoAlertDialog(
          title: const Text('Session Alert'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(body['message'] ?? ''),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Get.back(),
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Get.back();
                secoundortverifyapi(
                  context: Get.context!,
                  userid: userid.toString(),
                  otp: otp.toString(),
                  devicetoken: devicetoken,
                  mobilenu7mber: mobilenu7mber,
                );
              },
              child: const Text('Yes'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else if (response.statusCode == 200 && body['status'] == true) {
      authRepo.saveUserToken(body['token'].toString());
      authRepo.saveUserprofileid(userid);

     // await checkUser(userid, mobilenu7mber);
    } else if (response.statusCode == 422) {
      Get.snackbar(
        'Error',
        body['message'] ?? 'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    update();
    return response;
  }

  void showAlreadyLoggedInIOSDialog({
    required BuildContext context,
    required String message,
    VoidCallback? onYes,
    VoidCallback? onNo,
  }) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Session Alert'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Get.back();
                onNo?.call();
              },
              child: const Text('No'),
            ),

            CupertinoDialogAction(
              onPressed: () {
                Get.back();
                onYes?.call();
              },
              isDefaultAction: true,
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<Response> secoundortverifyapi({
    required BuildContext context,
    required String userid,
    required String otp,
    required String devicetoken,
    required String mobilenu7mber,
  }) async {
    EasyLoading.show();
    update();

    Response response = await authRepo.secoundotpverifyapi(
      useridd: userid,
      otp: otp,
      devicetoken: devicetoken,
    );

    if (response.statusCode == 200) {
      print(':::::::::${response.body['user_id']}');

      authRepo.saveUserToken(response.body['token'].toString());
      authRepo.saveUserprofileid(userid);

      EasyLoading.dismiss();

    //  await checkUser(userid, mobilenu7mber);
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
