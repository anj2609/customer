import 'dart:convert';

import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/app/modules/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:evfual/config/route.dart';
import 'package:evfual/config/utils/constants.dart';
import 'package:evfual/data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  Future<Response> userloginapi({
    required BuildContext context,
    String? evnumber,
    String? passowrd,
  }) async {
    EasyLoading.show();
    update();

    Response response = await authRepo.usersignup(
      evnumber: evnumber!.trim(),
      passsowrd: passowrd,
    );

    if (response.statusCode == 200) {
      print(':::::::::${response.body['status']}');

      if (response.body['status'] == 200) {
        print('id:::::${response.body['success']['userData']['id']}');
        authRepo.saveUserToken(
          response.body['success']['userData']['id'].toString(),
        );
        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      }
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        response.body['error'],
        backgroundColor: Colors.red,
        colorText: Colors.white,
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

  Future<void> registerEV({
    String? evnumber,
    String? password,
    String? confirmpassword,
    String? ownername,
    String? address,
    String? phone,
    String? email,
    String? evrccopy,
    String? idproof,
    String? vehiclephoto,
  }) async {
    try {
      var uri = Uri.parse("https://evfuel.akslearning.in/api/register");
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'ev_number': evnumber ?? '',
        'password': password ?? '',
        'confirm_password': confirmpassword ?? '',
        'owner_name': ownername ?? '',
        'address': address ?? '',
        'phone': phone ?? '',
        'email': email ?? '',
      });

      /// 🔹 Files
      if (evrccopy != null) {
        request.files.add(
          await http.MultipartFile.fromPath('ev_rc_copy', evrccopy),
        );
      }
      if (idproof != null) {
        request.files.add(
          await http.MultipartFile.fromPath('id_proof', idproof),
        );
      }
      if (vehiclephoto != null) {
        request.files.add(
          await http.MultipartFile.fromPath('vehicle_photo', vehiclephoto),
        );
      }

      request.headers['Accept'] = 'application/json';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decoded = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          decoded['message'] ?? 'Registration successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAll(() => LoginScreen());
        });
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        if (decoded['error'] != null) {
          /// show first validation error
          String firstError = decoded['error'].values.first[0];

          Get.snackbar(
            'Error',
            firstError,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            decoded['message'] ?? 'Validation failed',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
      /// ❌ SERVER ERROR
      else {
        Get.snackbar(
          'Error',
          decoded['message'] ?? 'Something went wrong',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
    /// ❌ EXCEPTION (No internet, timeout, crash)
    catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint("Exception 👉 $e");
    }
  }

  Future<Response> subscribeadd({
    required String subscrptionid,
    required String userid,
  }) async {
    EasyLoading.show();
    update();

    Response response = await authRepo.otpverifyapi(
      useridd: userid,
      subscrptionid: subscrptionid,
    );

    EasyLoading.dismiss();

    final body = response.body;

    if (response.statusCode == 409 && body['status'] == "ALREADY_LOGGED_IN") {
    } else if (response.statusCode == 200) {
      EasyLoading.dismiss();
      if (response.body['status'] == 200) {
        Get.snackbar(
          'Success',
          'Plan Upgrade Successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          body['error'] ?? 'Something went wrong',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else if (response.statusCode == 422) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        body['error'] ?? 'Something went wrong',
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
