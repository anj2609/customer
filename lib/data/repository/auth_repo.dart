import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myrideuser/config/utils/apis/api_client.dart';
import 'package:myrideuser/config/utils/constants.dart';

class AuthRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  /////========== Send  otp Api ======================///////
  Future<Response> sendOtpApi({
    String? phone,
    String? type,
    String? deviceToken,
    String? devicetype,
  }) async {
    log('send   otp number $phone');
    return apiClient.postsignUpData(ApiConstants.sendOtpUrl, {
      "phone": phone!.trim(),
      "user_type": ApiConstants.customer,
      "device_type": devicetype,
      "device_token": deviceToken,
    });
  }

  Future<Response> reSendOtp({String? phone, String? numOtp}) async {
    log('resend  otp number $phone');
    return apiClient.postsignUpData(ApiConstants.reSendOtp, {
      "phone": phone,
      "user_type": ApiConstants.customer,
    });
  }

  Future<Response> logOut() async {
    return apiClient.myridepostData(ApiConstants.logOutUrl, {});
  }

  /////========== verify otp Api ======================///////
  Future<Response> verifyOtpApi({String? phone, String? otp}) async {
    return apiClient.postsignUpData(ApiConstants.verityOtpUrl, {
      "phone": phone,
      "otp": otp,
      "user_type": ApiConstants.customer,
    });
  }

  Future<Response> fillPersonalApi({
    String? phone,
    String? name,
    String? email,
    String? gender,
    String? dob,
    File? profile_image,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userId = prefs.getString(ApiConstants.profileid);
    // A new user has no user_id yet — they are identified by the signup_token
    // verify-otp handed back. Existing-but-incomplete users still have a
    // user_id, so both are sent and the backend uses whichever applies.
    final String signupToken = prefs.getString(ApiConstants.signupToken) ?? "";

    // user_id was always sent, even as an empty string for a brand-new user
    // who has no account yet — signup_token is what identifies them at this
    // point, and a reference request confirmed working against the live
    // backend omits user_id entirely in exactly that case. Only include it
    // when there's a real value (an existing-but-incomplete user resuming
    // basic-info), rather than sending an empty field the backend has to
    // second-guess.
    final String resolvedUserId = ApiConstants.userIdSocial.isNotEmpty
        ? ApiConstants.userIdSocial
        : (userId ?? "");

    final Map<String, String> body = {
      "phone": phone ?? "",
      "user_type": ApiConstants.customer,
      "signup_token": signupToken,
      "name": name ?? "",
      "email": email ?? "",
      "gender": gender ?? "",
      "date_of_birth": dob ?? "",
    };
    if (resolvedUserId.isNotEmpty) {
      body["user_id"] = resolvedUserId;
    }

    // A rider who signed up via Google is identified differently to a
    // phone-OTP one: social-login's response hands back a real session
    // (api_token + id) rather than the signup_token verify-otp gives a new
    // phone-OTP user — and never issues a signup_token at all, so that
    // field is always empty for this case. Sent in addition to, not instead
    // of, everything above — a rider only ever has a real value for one
    // identity path, so this doesn't change what a phone-OTP rider sends.
    if (ApiConstants.userTokenSocial.isNotEmpty) {
      body["api_token"] = ApiConstants.userTokenSocial;
    }
    if (ApiConstants.userIdSocial.isNotEmpty) {
      body["id"] = ApiConstants.userIdSocial;
    }

    return apiClient.postMultipartData(ApiConstants.basicInfo, body, profile_image);
  }

  Future<Response> usersignup({String? evnumber, String? passsowrd}) async {
    return apiClient.postData(ApiConstants.loginapi, {
      "ev_number": evnumber,
      "password": passsowrd,
    });
  }

  Future<Response> otpverifyapi({
    String? useridd,
    String? subscrptionid,
  }) async {
    return apiClient.postData(ApiConstants.otpapi, {
      "user_id": useridd,
      "subscription_id": subscrptionid,
    });
  }

  Future<Response> secoundotpverifyapi({
    String? useridd,
    String? otp,
    String? devicetoken,
  }) async {
    return apiClient.postData(ApiConstants.otpapi, {
      "application": 'true',
      "userId": useridd,
      "otp": otp,
      "device_token": devicetoken,
      "forceLogin": true,
    });
  }

  //////===================== Social Signup - SingIn =================================//////////

  Future<Response> socialSignup({
    required String provider,
    required String idToken,
  }) async {
    return apiClient.postsignUpData(ApiConstants.socialAuth, {
      "provider": provider,
      "id_token": idToken,
      "user_type": ApiConstants.customer,
    });
  }

  //driveraddress
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token.toString();
    // ///apiClient.updateHeader(token.toString());
    return await sharedPreferences.setString(
      ApiConstants.token,
      token.toString(),
    );
  }

  Future<bool> saveSignupToken(String signupToken) async {
    return await sharedPreferences.setString(
      ApiConstants.signupToken,
      signupToken,
    );
  }

  Future<bool> saveUserprofileid(String profileid) async {
    apiClient.profileid = profileid.toString();
    // apiClient.updateHeader(profileid.toString());
    return await sharedPreferences.setString(
      ApiConstants.profileid,
      profileid.toString(),
    );
  }

  void removeUserToken() async {
    await sharedPreferences.remove(ApiConstants.token);
    await sharedPreferences.remove(ApiConstants.profileid);
  }

  String? getUserToken() {
    return sharedPreferences.getString(ApiConstants.token);
  }

  String? getUserprofileid() {
    return sharedPreferences.getString(ApiConstants.profileid);
  }
}
