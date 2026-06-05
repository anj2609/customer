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
      "type": type.toString(),
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
    String? name,
    String? email,
    String? gender,
    String? dob,
    File? profile_image,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userId = prefs.getString(ApiConstants.profileid);

    return apiClient.postMultipartData(ApiConstants.basicInfo, {
      "name": name ?? "",
      "email": email ?? "",
      "gender": gender ?? "",
      "date_of_birth": dob ?? "",
      "user_id": ApiConstants.userIdSocial.isNotEmpty
          ? ApiConstants.userIdSocial
          : userId ?? "",
    }, profile_image);
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
