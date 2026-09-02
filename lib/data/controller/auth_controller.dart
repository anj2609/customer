import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myrideuser/app/modules/Deshboard/buttom_navigation.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
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
    listenTokenRefresh();
  }

  Future<void> initDeviceData() async {
    deviceType = Platform.isAndroid ? "android" : "ios";

    deviceToken = await FirebaseMessaging.instance.getToken();

    await saveDeviceData();

    print("Saved Token: $deviceToken");
    print("Saved Device Type: $deviceType");
  }

  /// FCM tokens rotate — app reinstall, device data cleared, restored from
  /// backup, or just periodic rotation by Play services — and nothing in
  /// this app previously reacted to that. The token is only ever sent to
  /// the backend during signup/OTP (see auth_repo.dart's sendOtpApi,
  /// secoundotpverifyapi, socialSignup); no authenticated endpoint resends
  /// it afterwards. So a rider who logged in once and then had their token
  /// rotate would keep an otherwise-working session while the backend kept
  /// pushing to a token that no longer resolves to this install — dispatched
  /// server-side, delivered to nobody, and indistinguishable from "backend
  /// never sent it" on this end.
  ///
  /// This at least keeps the locally cached copy current, so the next call
  /// that does carry device_token sends the live value rather than
  /// whatever was current at login. It does not, by itself, push the
  /// refresh to the backend immediately — there is no endpoint for that
  /// today; one would need to accept device_token on an authenticated call
  /// (update-profile, or a dedicated route) for this to close the gap
  /// completely.
  void listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      deviceToken = newToken;
      await saveDeviceData();
      debugPrint("[FCM] Token refreshed: $newToken");
    });
  }

  Future<void> saveDeviceData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("device_token", deviceToken ?? "");
    await prefs.setString("device_type", deviceType ?? "");
  }

  /// Converts raw backend error messages to user-friendly text
  String _sanitizeBackendMessage(String? rawMessage, String fallback) {
    if (rawMessage == null || rawMessage.isEmpty) return fallback;
    final msg = rawMessage.toLowerCase().trim();
    if (msg.contains('data not found') || msg.contains('no data') || msg == 'not found') {
      return fallback;
    }
    if (msg.contains('server') || msg.contains('internal') || msg.contains('exception') || msg.contains('500')) {
      return "We're having trouble connecting. Please try again.";
    }
    if (msg.contains('unauthorized') || msg.contains('unauthenticated')) {
      return "Your session has expired. Please log in again.";
    }
    if (msg.contains('network') || msg.contains('connection') || msg.contains('timeout')) {
      return "Please check your internet connection and try again.";
    }
    if (rawMessage.contains(' ') && !rawMessage.contains('_')) {
      return rawMessage;
    }
    return fallback;
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
      // Clear any cached Google session before opening the picker.
      //
      // Without this, signIn() resolves against whatever account the plugin
      // already holds — and if that cached state is stale (revoked grant,
      // account removed from the device, a half-finished earlier attempt)
      // the call can sit unresolved instead of failing, which is what left
      // the button stuck on "Signing in..." with no picker and no error.
      // Signing out first costs nothing on a clean state and guarantees the
      // account chooser is actually shown.
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // Nothing to sign out of — not a failure worth reporting.
      }

      // Timeouts on both platform calls. Neither has one of its own, so a
      // hang inside Play Services (the reported "infinite loading") had
      // nothing to break it: the await simply never returned and the
      // caller's finally never ran. 90s is generous for a human picking an
      // account and still bounded.
      final GoogleSignInAccount? account = await _googleSignIn
          .signIn()
          .timeout(const Duration(seconds: 90));

      if (account == null) {
        // Genuine user cancellation — silent by design, no error toast.
        print("User cancelled login");
        return null;
      }

      final GoogleSignInAuthentication auth =
          await account.authentication.timeout(const Duration(seconds: 30));

      final String? idToken = auth.idToken;
      final String? accessToken = auth.accessToken;

      // The backend authenticates on id_token, so without one there is
      // nothing to send. This used to fall through and post the literal
      // string "null", which the backend rejected — landing in the silent
      // else branch of socailLogin below and looking, again, like nothing
      // had happened at all.
      if (idToken == null || idToken.isEmpty) {
        if (context.mounted) {
          AnimatedTopToast.show(
            context: context,
            message:
                "Couldn't verify your Google account. Please try again or "
                "sign in with your mobile number.",
            backgroundColor: ColorResources.textColorBaclColor,
            icon: Icons.error_outline,
          );
        }
        return null;
      }

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
      // Was `print(e); return null;` — every possible failure (a SHA-1
      // fingerprint not registered for this build, which surfaces as
      // PlatformException ApiException: 10; no Play Services; a timeout
      // from above; a dropped network) produced an identical silent no-op.
      // The caller resets its button and the user is left with a screen
      // that visibly did nothing, twice over: no error, no progress, no
      // reason to think retrying would help. Reported as "infinite loading
      // and the user is not able to sign up".
      debugPrint("Google sign-in failed: $e");
      if (context.mounted) {
        final bool timedOut = e is TimeoutException;
        AnimatedTopToast.show(
          context: context,
          message: timedOut
              ? "Google sign-in timed out. Check your connection and try again."
              : "Google sign-in failed. Please try again, or sign in with "
                  "your mobile number.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }
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
      deviceToken: deviceToken,
      deviceType: deviceType,
    );

    // ?.toString() rather than == "200". The backend is not consistent about
    // whether `code` is a string or a number across endpoints, and an int
    // 200 failed this check silently, dropping a perfectly good login into
    // the do-nothing branch at the bottom.
    if (response.body != null && response.body["code"]?.toString() == "200") {
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
      // CONFIRMED: social-auth's response names this field "token", not
      // "api_token" — that mismatch meant `.toString()` was called on a
      // JSON null, producing the four-character *string* "null" (Dart's
      // Null.toString()) rather than throwing or leaving this empty. That
      // string is non-empty, so every `.isNotEmpty` guard downstream (the
      // ones that decide whether to send api_token/id to basic-info, e.g.)
      // treated it as "this rider has a real session token" and sent the
      // literal text "null" as the token — a second, more confusing
      // failure on top of never having a real session in the first place.
      ApiConstants.userTokenSocial = response.body['data']['token']
          .toString();
      ApiConstants.userIdSocial = response.body['data']['id'].toString();
      ApiConstants.usernames = response.body['data']['name'].toString();
      ApiConstants.emailAddress = response.body['data']['email'].toString();

      ApiConstants.provider = provider.toString();
      if (response.body['data']['status'].toString() == '1' ) {
        authRepo.saveUserToken(response.body['data']['token'].toString());
        authRepo.saveUserprofileid(response.body['data']['id'].toString());
        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      } else {
        // ProfilePage's own route unconditionally reads
        // Get.arguments['phonenumber'] (see route.dart) — calling this
        // without any arguments at all left Get.arguments null, and
        // indexing into that threw NoSuchMethodError the instant the route
        // tried to build. The phone-OTP call site a few hundred lines down
        // already passes this map; this one — the Google-signup path —
        // never did. There genuinely is no phone number to hand over here
        // (Google's identity token doesn't carry one), so this passes an
        // empty string rather than omitting the key: ProfilePage's own
        // phone field is read-only, sourced entirely from this value, so a
        // Google-signup rider currently sees it blank rather than crashing.
        Get.offAllNamed(
          RouteHelper.getprofileScreenRoute(),
          arguments: {'phonenumber': ''},
        );
      }
    } else if (response.statusCode == 500) {
     /// await EasyLoading.dismiss();
  AnimatedTopToast.show(
        context: context,
        message:
             "We're having trouble connecting. Please try again shortly.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
      // Get.snackbar(
      //   '',
      //   response.body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    } else {
      // This branch was entirely empty. Every backend rejection of a social
      // login — an unregistered account, a rejected id_token, a validation
      // error, any 4xx — returned here and did absolutely nothing: no
      // message, no navigation, no state change. The button reset itself and
      // the user was left staring at the same screen with no idea the
      // request had even failed, let alone why.
      final dynamic body = response.body;
      final String? backendMessage =
          body is Map ? body['message']?.toString() : null;
      if (context.mounted) {
        AnimatedTopToast.show(
          context: context,
          message: _sanitizeBackendMessage(
            backendMessage,
            "Couldn't sign in with Google. Please try again or use your "
            "mobile number.",
          ),
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }
      debugPrint(
        'Social login rejected: status=${response.statusCode} body=$body',
      );
    }
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
             _sanitizeBackendMessage(response.body['message'], "Unable to sign in. Please try again."),
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    } else if (response.statusCode == 422) {
     //// EasyLoading.dismiss();
      AnimatedTopToast.show(
        context: context,
        message:
             _sanitizeBackendMessage(response.body['message'], "Please check your details and try again."),
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
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

    try {
      // Step 1 — try a login OTP; if it succeeds the number is registered.
      final loginResp = await authRepo.sendOtpApi(
        phone: phone,
        type: ApiConstants.UserLogin,
        deviceToken: deviceToken ?? '',
        devicetype: deviceType,
      );

      if (loginResp.body != null && loginResp.body['code'] == '200') {
        // Registered user
        RouteHelper.getOtpScreenRoute(
          phone,
          ApiConstants.UserLogin,
        );
        return;
      }

      // Step 2 — distinguish "user not found" errors from real server errors.
      final int statusCode = loginResp.statusCode ?? 0;
      final String msg = (loginResp.body?['message'] ?? '').toString().toLowerCase();

      // A 500 means the server crashed — never a legitimate "not
      // registered" business response, so it must never reach the
      // message-substring checks below. It used to: a backend crash
      // whose exception message happened to contain "not found" (e.g.
      // PHP's "Class \"X\" not found" fatal-error format) was matched by
      // msg.contains('not found') and misread as "user not registered",
      // sending this down the register-OTP path instead of surfacing the
      // real server error.
      final bool isNotFound = statusCode != 500 &&
          (statusCode == 404 ||
              statusCode == 422 ||
              msg.contains('not found') ||
              msg.contains('not register') ||
              msg.contains('does not exist') ||
              msg.contains('no account') ||
              msg.contains('invalid') ||
              (loginResp.body?['code'] != null &&
                  loginResp.body['code'] != '200'));

      if (isNotFound) {
        // Not registered (per the login attempt above) — send a register OTP.
        final regResp = await authRepo.sendOtpApi(
          phone: phone,
          type: ApiConstants.UserRegister,
          deviceToken: deviceToken ?? '',
          devicetype: deviceType,
        );

        if (regResp.body != null && regResp.body['code'] == '200') {
          AnimatedTopToast.show(
            context: context,
            message: "OTP sent successfully.",
            backgroundColor: ColorResources.appColor,
            icon: Icons.check_circle_rounded,
          );
          await Future.delayed(const Duration(milliseconds: 500));
          RouteHelper.getOtpScreenRoute(
            phone,
            ApiConstants.UserRegister,
          );
          return;
        }

        // The "not found" guess above was wrong — the register attempt
        // itself now reports this number as already registered (code 401,
        // "This phone already in use."). Rather than dead-ending on that
        // (it used to surface as a raw "Verification Failed" popup),
        // recover by sending a proper login OTP and proceeding there.
        final String regMsg =
            (regResp.body?['message'] ?? '').toString().toLowerCase();
        final bool isAlreadyRegistered =
            regResp.body?['code']?.toString() == '401' &&
            regMsg.contains('already in use');

        if (isAlreadyRegistered) {
          final retryLoginResp = await authRepo.sendOtpApi(
            phone: phone,
            type: ApiConstants.UserLogin,
            deviceToken: deviceToken ?? '',
            devicetype: deviceType,
          );

          if (retryLoginResp.body != null &&
              retryLoginResp.body['code'] == '200') {
            AnimatedTopToast.show(
              context: context,
              message:
                  "This number is already registered. Sending login OTP instead.",
              backgroundColor: ColorResources.appColor,
              icon: Icons.info_outline,
            );
            await Future.delayed(const Duration(milliseconds: 500));
            RouteHelper.getOtpScreenRoute(
              phone,
              ApiConstants.UserLogin,
            );
            return;
          }

          throw Exception(_userFacingMessage(retryLoginResp));
        }

        throw Exception(_userFacingMessage(regResp));
      }

      // Step 3 — real server error.
      throw Exception(
        'Unable to verify your account at the moment. Please try again.',
      );
    } catch (e) {
      if (e is SocketException) {
        throw Exception('Please check your internet connection and try again.');
      }
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('Failed host lookup')) {
        throw Exception('Please check your internet connection and try again.');
      }
      rethrow;
    }
  }

  /// A response's `message` is only safe to show a user when it's a
  /// deliberate application-level error (backend chose those words for a
  /// human to read). A 500 means the server crashed — its "message" is
  /// whatever an uncaught exception's text happened to be (a PHP class
  /// name, a stack trace fragment, etc.), so that case always falls back
  /// to a generic message instead of leaking raw backend internals into
  /// the UI.
  String _userFacingMessage(Response response) {
    if (response.statusCode == 500) {
      return 'Unable to verify your account at the moment. Please try again.';
    }
    final message = response.body is Map ? response.body['message'] : null;
    return (message == null || message.toString().trim().isEmpty)
        ? 'Unable to verify your account at the moment. Please try again.'
        : message.toString();
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

    // A signup attempt (type: register) on an already-registered number
    // comes back as code 401 "This phone already in use." — rather than
    // dead-ending the user on a raw error, silently retry the exact same
    // request as a login OTP instead. Only applies when we weren't
    // already trying a login (avoids retrying forever if the backend
    // ever reuses this code/message for a genuine login failure).
    final String bodyCode = response.body?["code"]?.toString() ?? '';
    final String bodyMessage =
        (response.body?["message"] ?? '').toString().toLowerCase();
    final bool isPhoneAlreadyInUse = bodyCode == "401" &&
        bodyMessage.contains('already in use') &&
        type != ApiConstants.UserLogin;

    if (isPhoneAlreadyInUse) {
      AnimatedTopToast.show(
        context: context,
        message: "This number is already registered. Sending login OTP instead.",
        backgroundColor: ColorResources.appColor,
        icon: Icons.info_outline,
      );

      response = await authRepo.sendOtpApi(
        phone: mobileNumber,
        type: ApiConstants.UserLogin,
        deviceToken: Get.find<AuthController>().deviceToken!,
        devicetype: deviceType,
      );

      if (response.body?["code"] == "200") {
        await Future.delayed(const Duration(milliseconds: 500));
        RouteHelper.getOtpScreenRoute(
          mobileNumber,
          ApiConstants.UserLogin,
        );
      } else {
        AnimatedTopToast.show(
          context: context,
          message: "Unable to send verification code. Please try again.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.error_outline,
        );
      }

      update();
      return response;
    }

    if (response.body["code"] == "200") {
    ///  await EasyLoading.dismiss();

      AnimatedTopToast.show(
        context: context,
        message: "OTP sent successfully.",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      RouteHelper.getOtpScreenRoute(
        mobileNumber,
        type,
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
           "Unable to send verification code. Please try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    } else {
      // Any other non-200/500 response (e.g. a genuine validation error
      // unrelated to "already in use") — surface it instead of failing
      // silently, mirroring the 500 case above.
      AnimatedTopToast.show(
        context: context,
        message: (response.body is Map
                ? response.body['message']?.toString()
                : null) ??
            "Unable to send verification code. Please try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
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
        message: "OTP resent successfully.",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
    } else if (response.statusCode == 500) {
     // await EasyLoading.dismiss();

      AnimatedTopToast.show(
        context: context,
        message: "Unable to resend OTP. Please try again.",
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
    } else {
      ////await EasyLoading.dismiss();
    }

    update();
    return response;
  }

  Future<void> userLogOut({
    required BuildContext context,
  }) async {
    debugPrint('🟢 [SESSION] MANUAL LOGOUT — user tapped Logout button');
    debugPrint('   Route: ${Get.currentRoute}');

    // Close any open dialogs/bottom sheets first
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    try {
      await authRepo.logOut();
      debugPrint('   Logout API call succeeded');
    } catch (e) {
      debugPrint('   Logout API error (non-blocking): $e');
    }

    logOut();
    Get.offAllNamed(RouteHelper.getLestMyRideStartedScreenRoute());
  }

  /// Mirrors userLogOut's flow above — same session cleanup, same
  /// navigation away from the app — except the backend call is
  /// delete-account instead of logout, since the account itself no longer
  /// exists after this succeeds.
  Future<void> deleteAccount({required BuildContext context}) async {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    try {
      final response = await authRepo.deleteAccount();

      if (response.body is Map && response.body['code']?.toString() == '200') {
        logOut();
        if (context.mounted) AnimatedTopToast.show(
          context: context,
          message: "Your account has been deleted.",
          backgroundColor: ColorResources.appColor,
          icon: Icons.check_circle_rounded,
        );
        Get.offAllNamed(RouteHelper.getLestMyRideStartedScreenRoute());
      } else {
        if (context.mounted) AnimatedTopToast.show(
          context: context,
          message: "Could not delete account. Please try again.",
          backgroundColor: Colors.red,
          icon: Icons.error_rounded,
        );
      }
    } catch (e) {
      debugPrint('Delete account error: $e');
      if (context.mounted) AnimatedTopToast.show(
        context: context,
        message: "Could not delete account. Please try again.",
        backgroundColor: Colors.red,
        icon: Icons.error_rounded,
      );
    }
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
      final data = response.body['data'];
      // The backend now states outright whether this is a first-time user, so
      // the branch is taken from is_new_user rather than from the login-vs-
      // register guess the client used to carry through `type`.
      final bool isNewUser = data?['is_new_user'] == true;

      AnimatedTopToast.show(
        context: context,
        message:
            _sanitizeBackendMessage(response.body['message'], "Verified successfully."),
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );

      if (isNewUser) {
        // No session token yet — a new user is carried by the signup_token
        // until they finish basic info, which is where the real token is
        // issued. Save it and send them to fill their details.
        final String signupToken = data?['signup_token']?.toString() ?? '';
        await authRepo.saveSignupToken(signupToken);

        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(
          RouteHelper.getprofileScreenRoute(),
          arguments: {'phonenumber': mobileNumber.toString()},
        );
      } else {
        // Existing user: verify-otp returns the real token and user record, so
        // save them and go straight into the app.
        final String? token = data?["token"]?.toString();
        final String? userId = data?['user']?['id']?.toString();

        if (token == null || token.isEmpty || token == 'null' ||
            userId == null || userId.isEmpty || userId == 'null') {
          AnimatedTopToast.show(
            context: context,
            message: "Verification failed. Please try again.",
            backgroundColor: ColorResources.textColorBaclColor,
            icon: Icons.error_outline,
          );
          update();
          return response;
        }

        authRepo.saveUserToken(token);
        authRepo.saveUserprofileid(userId);

        await Future.delayed(const Duration(milliseconds: 500));
        Get.toNamed(RouteHelper.getmainNavigationScreen());
      }
    } else {
      AnimatedTopToast.show(
        context: context,
        message:
            _sanitizeBackendMessage(response.body['message'], "Verification failed. Please check your code and try again."),
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    }

    update();
    return response;
  }

  ///// ========= Api  First Sig-Up Api Call  =========
  Future<Response> fillPersonalInfoApi({
    required BuildContext context,
    String? phone,
    String? name,
    String? email,
    String? gender,
    String? dob,
    File? profileimage,
  }) async {
   // EasyLoading.show(status: "Please wait...");
    update();

    Response response = await authRepo.fillPersonalApi(
      phone: phone?.trim(),
      name: name?.trim(),
      // Email and date of birth are optional — trimmed if present, left
      // null (not force-unwrapped) if not, so a genuinely-empty value here
      // reaches fillPersonalApi as null and gets omitted from the request
      // entirely rather than crashing this call outright.
      email: email?.trim(),
      gender: gender?.trim(),
      dob: dob?.trim(),
      profile_image: profileimage,
    );

    if (response.body['code'] == "200") {
      // A new user reaches basic-info with only a signup_token; the real
      // session token is issued here, on completion. Capture token + user id
      // if the response carries them, so the user is properly logged in for
      // every call after this — without it they would land on Home
      // unauthenticated.
      final data = response.body['data'];
      final String? token = data?['token']?.toString();
      final String? userId =
          (data?['user']?['id'] ?? data?['user_id'])?.toString();
      if (token != null && token.isNotEmpty && token != 'null') {
        authRepo.saveUserToken(token);
      }
      if (userId != null && userId.isNotEmpty && userId != 'null') {
        authRepo.saveUserprofileid(userId);
      }

      AnimatedTopToast.show(
        context: context,
        message:
            _sanitizeBackendMessage(response.body['message'], "Profile updated successfully."),
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      Get.toNamed(RouteHelper.getmainNavigationScreen());
    } else if (response.body['data'] == "401") {
      // Was always this same fixed string regardless of what the backend
      // actually said — same fix as the success path three lines up, and
      // the equivalent fix already made on the driver app's basic-info
      // failure handling: a specific, actionable rejection (an account that
      // already exists, a validation error on one field) looked identical
      // to a transient failure, and "Please try again" was the only
      // guidance offered for an error retrying can never fix.
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(
          response.body['message'],
          "Unable to save your details. Please try again.",
        ),
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    } else {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(
          response.body['message'],
          "Unable to save your details. Please try again.",
        ),
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    }
    //await EasyLoading.dismiss();
    update();
    return response;
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
        _sanitizeBackendMessage(response.body['message'], "Verification failed. Please try again."),
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
    debugPrint('🔑 [SESSION] Clearing auth tokens (token + profileid)');
    try {
      _googleSignIn.signOut();
    } catch (e) {
      debugPrint('   Google signOut error: $e');
    }
    authRepo.removeUserToken();
    debugPrint('   Auth tokens removed successfully');
  }
}
