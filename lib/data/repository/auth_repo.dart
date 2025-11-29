import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/config/utils/apis/api_client.dart';
import 'package:vivashri/config/utils/constants.dart';

class AuthRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> usersignup({String? numberemail}) async {
    return apiClient.postData(ApiConstants.loginapi, {
      "mobile_email": numberemail,
    });
  }

  Future<Response> otpverifyapi({
    String? useridd,
    String? otp,
    String? devicetoken,
  }) async {
    return apiClient.postData(ApiConstants.otpapi, {
      "application": 'true',
      "userId": useridd,
      "otp": otp,
      "device_token": devicetoken,
    });
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token.toString();
    apiClient.updateHeader(token.toString());
    return await sharedPreferences.setString(
      ApiConstants.token,
      token.toString(),
    );
  }

  void removeUserToken() async {
    await sharedPreferences.remove(ApiConstants.token);
  }

  String? getUserToken() {
    return sharedPreferences.getString(ApiConstants.token);
  }
}
