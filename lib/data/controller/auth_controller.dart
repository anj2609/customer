import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myrideuser/app/modules/Deshboard/buttom_navigation.dart';
import 'package:myrideuser/app/modules/auth/login_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/data/repository/auth_repo.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  //// ====== Google SignIn =============== //////////////
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  String? deviceToken;
  String? deviceType;

  @override
  void onInit() {
    super.onInit();
    initDeviceData();
  }

  Future<void> initDeviceData() async {
    deviceType = Platform.isAndroid ? "android" : "ios";

    deviceToken = await FirebaseMessaging.instance.getToken();

    await saveDeviceData();

    print("Saved Token: $deviceToken");
    print("Saved Device Type: $deviceType");
  }

  Future<void> saveDeviceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("device_token", deviceToken ?? "");
    await prefs.setString("device_type", deviceType ?? "");
  }

  Future<void> loadSavedDeviceData() async {
    final prefs = await SharedPreferences.getInstance();

    deviceToken = prefs.getString("device_token");
    deviceType = prefs.getString("device_type");
  }

  Future<Response?> signInWithGoogle({
    required BuildContext context,
    String? provider,
  }) async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        print("User cancelled login");
        return null;
      }

      final GoogleSignInAuthentication auth = await account.authentication;

      final String? idToken = auth.idToken;
      final String? accessToken = auth.accessToken;

      // /// ===== STORE DATA =====
      // ApiConstants.socialtoken = accessToken.toString();

      // ApiConstants.gmailAddres = account.email;

      // // User Name
      // ApiConstants.userName = account.displayName ?? "";

      ApiConstants.profileImage = account.photoUrl ?? "";

      print("User Name: ${account.displayName}");
      print("Gmail: ${account.email}");
      print("Photo: ${account.photoUrl}");

      print("ID Token: $idToken");
      print("Access Token: $accessToken");

      /// API CALL
      final response = await socailLogin(
        provider: provider.toString(),
        userToken: idToken,

          context: context,
      );

      return response;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<Response> socailLogin({
     required BuildContext context,
    required String provider,
    String? userToken,
  }) async {
    ///EasyLoading.show(status: "Please wait...");
    update();

    Response response = await authRepo.socialSignup(
      provider: provider,
      idToken: userToken.toString(),
    );

    if (response.body != null && response.body["code"] == "200") {
    ///  await EasyLoading.dismiss();
      print('social login ${response.body['user']}');

      // Get.snackbar(
      //   '',
      //   "${response.body['message']}",

      //   ///${response.body['data']['otp']}",
      //   backgroundColor: ColorResources.blueeebutton,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 5),
      // );
       AnimatedTopToast.show(
        context: context,
        message:
             response.body?['message'],
        backgroundColor: ColorResources.blueeebutton,
        icon: Icons.check_circle_rounded,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      ApiConstants.userTokenSocial = response.body['data']['api_token']
          .toString();
      ApiConstants.userIdSocial = response.body['data']['id'].toString();
      ApiConstants.usernames = response.body['data']['name'].toString();
      ApiConstants.emailAddress = response.body['data']['email'].toString();

      ApiConstants.provider = provider.toString();
      if (response.body['data']['status'].toString() == '1' ) {
        authRepo.saveUserToken(response.body['data']['api_token'].toString());
        authRepo.saveUserprofileid(response.body['data']['id'].toString());
        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      } else {
        Get.offAllNamed(RouteHelper.getprofileScreenRoute());
      }
    } else if (response.statusCode == 500) {
     /// await EasyLoading.dismiss();
  AnimatedTopToast.show(
        context: context,
        message:
             response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.blueeebutton,
        icon: Icons.check_circle_rounded,
      );
      // Get.snackbar(
      //   '',
      //   response.body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    } else {
    ///  await EasyLoading.dismiss();
    }
   /// await EasyLoading.dismiss();
    update();
    return response;
  }

  Future<Response> userloginapi({
    required BuildContext context,
    String? evnumber,
    String? passowrd,
  }) async {
  //  EasyLoading.show();
    update();

    Response response = await authRepo.usersignup(
      evnumber: evnumber!.trim(),
      passsowrd: passowrd,
    );

    if (response.statusCode == 200) {
      print(':::::::::${response.body['status']}');

      if (response.body['status'] == 200) {
        // print('id:::::${response.body['success']['userData']['id']}');
        // authRepo.saveUserToken(
        //   response.body['success']['userData']['id'].toString(),
        // );

        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      }
      //EasyLoading.dismiss();
       AnimatedTopToast.show(
        context: context,
        message:
             response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.check_circle_rounded,
      );
    } else if (response.statusCode == 422) {
     //// EasyLoading.dismiss();
      AnimatedTopToast.show(
        context: context,
        message:
             response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.check_circle_rounded,
      );
    } else {
   ///   EasyLoading.dismiss();
    }

    update();
    return response;
  }

  /// Checks if the phone is registered, then routes to the correct OTP flow.
  /// Throws an Exception with a user-readable message on failure.
  Future<void> checkPhoneAndNavigate({
    required BuildContext context,
    required String phone,
  }) async {
    await initDeviceData();

    // Step 1 — try a login OTP; if it succeeds the number is registered.
    final loginResp = await authRepo.sendOtpApi(
      phone: phone,
      type: ApiConstants.UserLogin,
      deviceToken: deviceToken ?? '',
      devicetype: deviceType,
    );

    if (loginResp.body != null && loginResp.body['code'] == '200') {
      // Registered user
      AnimatedTopToast.show(
        context: context,
        message: 'Your number is already registered. Signing you in...',
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
      await Future.delayed(const Duration(milliseconds: 600));
      RouteHelper.getOtpScreenRoute(
        phone,
        ApiConstants.UserLogin,
        loginResp.body['data']['otp'].toString(),
      );
      return;
    }

    // Step 2 — distinguish "user not found" errors from real server errors.
    final int statusCode = loginResp.statusCode ?? 0;
    final String msg = (loginResp.body?['message'] ?? '').toString().toLowerCase();

    final bool isNotFound = statusCode == 404 ||
        statusCode == 422 ||
        msg.contains('not found') ||
        msg.contains('not register') ||
        msg.contains('does not exist') ||
        msg.contains('no account') ||
        msg.contains('invalid') ||
        (loginResp.body?['code'] != null &&
            loginResp.body['code'] != '200' &&
            statusCode != 500);

    if (isNotFound) {
      // Not registered — send a register OTP.
      AnimatedTopToast.show(
        context: context,
        message: 'Please create your account to continue.',
        backgroundColor: ColorResources.blueeebutton,
        icon: Icons.person_add_rounded,
      );
      await Future.delayed(const Duration(milliseconds: 600));

      final regResp = await authRepo.sendOtpApi(
        phone: phone,
        type: ApiConstants.UserRegister,
        deviceToken: deviceToken ?? '',
        devicetype: deviceType,
      );

      if (regResp.body != null && regResp.body['code'] == '200') {
        AnimatedTopToast.show(
          context: context,
          message:
              '${regResp.body['message']}  ${regResp.body['data']['otp']} \u{1F389}',
          backgroundColor: ColorResources.appColor,
          icon: Icons.check_circle_rounded,
        );
        await Future.delayed(const Duration(milliseconds: 500));
        RouteHelper.getOtpScreenRoute(
          phone,
          ApiConstants.UserRegister,
          regResp.body['data']['otp'].toString(),
        );
        return;
      }

      throw Exception(
        regResp.body?['message'] ??
            'Unable to verify your account at the moment. Please try again.',
      );
    }

    // Step 3 — real server / network error.
    throw Exception(
      'Unable to verify your account at the moment. Please try again.',
    );
  }

  Future<Response> sendOtp({
    required BuildContext context,
    required String mobileNumber,
    required String type,
    required String deviceToken,
  }) async {
    ///EasyLoading.show(status: "Please wait...");
    update();

    Response response = await authRepo.sendOtpApi(
      phone: mobileNumber,
      type: type,
      deviceToken: Get.find<AuthController>().deviceToken!,
      devicetype: deviceType,
    );

    if (response.body["code"] == "200") {
    ///  await EasyLoading.dismiss();

      AnimatedTopToast.show(
        context: context,
        message:
            "${response.body['message']}  ${response.body['data']['otp']} 🎉",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      RouteHelper.getOtpScreenRoute(
        mobileNumber,
        type,
        response.body['data']['otp'].toString(),
      );
    } else if (response.statusCode == 500) {
     // await EasyLoading.dismiss();

      // Get.snackbar(
      //   'Error',
      //   response.body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
       AnimatedTopToast.show(
        context: context,
        message:
           response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.check_circle_rounded,
      );
    } else {
     // await EasyLoading.dismiss();
    }

    update();
    return response;
  }

  // Future<void> socialSignup(String provider) async {
  //   try {
  //     EasyLoading.show(status: "Please wait...");

  //     String? idToken;

  //     if (provider == "google") {
  //       final GoogleSignInAccount googleUser = await _googleSignIn
  //           .authenticate();

  //       final GoogleSignInAuthentication googleAuth =
  //           await googleUser.authentication;

  //       idToken = googleAuth.idToken;
  //     }

  //     if (idToken == null) {
  //       await EasyLoading.dismiss();
  //       Get.snackbar("Error", "Token not found");
  //       return;
  //     }

  //     final response = await authRepo.socialSignup(
  //       provider: provider, // dynamic
  //       idToken: idToken, // real token
  //     );

  //     await EasyLoading.dismiss();

  //     if (response.statusCode == 200) {
  //       var data = response.body;
  //       print("Success Response: $data");

  //       Get.snackbar("Success", "Login Successfully");
  //     } else {
  //       Get.snackbar("Error", "Something went wrong");
  //     }
  //   } catch (e) {
  //     await EasyLoading.dismiss();
  //     Get.snackbar("Error", e.toString());
  //     log('getting  google  issue ${e.toString()}');
  //   }
  // }

  Future<Response> reSendOtp({
    required BuildContext context,
    required String mobileNumber,
    required String otpNumber,
    //reSendOtp
  }) async {
   /// EasyLoading.show(status: "Please wait...");
    update();

    Response response = await authRepo.reSendOtp(phone: mobileNumber);

    if (response.body['code'] == '200') {
      ///await EasyLoading.dismiss();

      AnimatedTopToast.show(
        context: context,
        message:
           "${response.body['message']}  ${response.body['data']['otp']} 🎉",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
    } else if (response.statusCode == 500) {
     // await EasyLoading.dismiss();

      AnimatedTopToast.show(
        context: context,
        message:
           "${response.body['message']}",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
    } else {
      ////await EasyLoading.dismiss();
    }

    update();
    return response;
  }

  Future<Response> userLogOut({
    required BuildContext context,

    //reSendOtp
  }) async {
   /// EasyLoading.show(status: "Please wait...");
    update();

    Response response = await authRepo.logOut();

    if (response.body['code'] == '200') {
    //  await EasyLoading.dismiss();
      logOut();

      // Get.snackbar(
      //   '',
      //   response.body['message'] ?? "Logout Successfully",
      //   backgroundColor: ColorResources.blueeebutton,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 3),
      // );
       AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Logout Successfully",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );

      // 🔥 Remove all previous routes
      Get.offAllNamed(RouteHelper.getLoginRoute());
    } else if (response.statusCode == 500) {
    //  await EasyLoading.dismiss();

      AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Logout Successfully",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.check_circle_rounded,
      );
    } else {
     // await EasyLoading.dismiss();
    }

    update();
    return response;
  }

  Future<Response> verifyOtpApi({
    required BuildContext context,
    required String mobileNumber,
    required String numOfOtp,
    required String type,
  }) async {
   // EasyLoading.show(status: "Please wait...");
    update();

    Response response = await authRepo.verifyOtpApi(
      phone: mobileNumber,
      otp: numOfOtp,
    );

    if (response.body['code'] == "200") {
     /// await EasyLoading.dismiss();

      AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ,
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
      authRepo.saveUserToken(response.body['data']["token"].toString());
      authRepo.saveUserprofileid(
        response.body['data']['user']['id'].toString(),
      );
      log(
        'login  user token ||||||||||||||| ====== ${response.body['data']["token"].toString()}',
      );
      log(
        'login  user user Id ||||||||||||||| ====== ${response.body['data']['user']['id'].toString()}',
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (type == ApiConstants.UserRegister) {
        Get.toNamed(RouteHelper.getprofileScreenRoute(),
        arguments: {
        'phonenumber': mobileNumber.toString()
        }
        );
      } else {
        Get.toNamed(RouteHelper.getmainNavigationScreen());
      }
    } else if (response.body['data'] == "401") {
      
      AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
    } else {
     AnimatedTopToast.show(
        context: context,
        message:
            response.body['message'] ?? "Something went wrong",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
      
    }

    update();
    return response;
  }

  ///// ========= Api  First Sig-Up Api Call  =========
  Future<Response> fillPersonalInfoApi({
    required BuildContext context,
    String? name,
    String? email,
    String? gender,
    String? dob,
    File? profileimage,
  }) async {
   // EasyLoading.show(status: "Please wait...");
    update();

    Response response = await authRepo.fillPersonalApi(
      name: name!.trim(),
      email: email!.trim(),
      gender: gender!.trim(),
      dob: dob!.trim(),
      profile_image: profileimage,
    );

    if (response.body['code'] == "200") {
    //  await EasyLoading.dismiss();

      // Get.snackbar(
      //   'Success',
      //   "${response.body['message']}",
      //   backgroundColor: ColorResources.blueeebutton,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 5),
      // );
      AnimatedTopToast.show(
        context: context,
        message:
            "${response.body['message']}",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Get.toNamed(RouteHelper.getmainNavigationScreen());
    } else if (response.body['data'] == "401") {
     // await EasyLoading.dismiss();
      // Get.snackbar(
      //   '',
      //   response.body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
       AnimatedTopToast.show(
        context: context,
        message:
             "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
    } else {
      
        AnimatedTopToast.show(
        context: context,
        message:
            "Something went wrong",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.check_circle_rounded,
      );
    }
    //await EasyLoading.dismiss();
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
    } catch (e) {
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
      EasyLoading.dismiss();
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
    Get.back();

    return authRepo.removeUserToken();
  }
}
