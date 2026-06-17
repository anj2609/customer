import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as Http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:myrideuser/config/utils/apis/api_checker.dart';
import 'package:myrideuser/config/utils/constants.dart';

class ApiClient extends GetxService {
  final SharedPreferences sharedPreferences;
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 60;

  String? token;
  String? profileid;
  String? username;
  String? emailid;
  String? pancardno;
  String? passordss;

  //Map<String, String>? _mainHeadersMain;

  ApiClient({required this.sharedPreferences}) {
    // _mainHeadersMain = {
    //   'Accept': 'application/json',
    //   'id': '${sharedPreferences.getString(ApiConstants.profileid)}',
    //   'authorizationToken':
    //       '${sharedPreferences.getString(ApiConstants.token)}',
    // };
  }

  Map<String, String> get _mainHeadersMain {
    return {
      'Accept': 'application/json',
      "Content-Type": "application/json",
      'id': sharedPreferences.getString(ApiConstants.profileid) ?? "",
      'authorizationToken':
          "${sharedPreferences.getString(ApiConstants.token) ?? ""}",
    };
  }

  Future<Response> postsignUpData(String uri, dynamic body) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Call: $uri');
        }
        Http.Response _response = await Http.post(
          Uri.parse(ApiConstants.baseUrl + uri),
          body: jsonEncode(body),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          //_mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        Response response = handleResponse(_response, uri);

        if (Foundation.kDebugMode) {
          print(
            '====> API Response: [${response.statusCode}] $uri',
          );
        }
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Call: $uri');
        }
        Http.Response _response = await Http.post(
          Uri.parse(ApiConstants.baseUrl + uri),
          body: jsonEncode(body),
          headers: _mainHeadersMain,
          //_mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        Response response = handleResponse(_response, uri);

        if (Foundation.kDebugMode) {
          print(
            '====> API Response: [${response.statusCode}] $uri',
          );
        }
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> postChatData(String uri, dynamic body) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    }

    try {
      if (Foundation.kDebugMode) {
        print('====> GetX Base URL: $ApiConstants.baseUrl');
        print('====> GetX Call: $uri');
        print('====> GetX Body: ${jsonEncode(body)}');
      }
      Map<String, String> headerschat = {
        'id': '${sharedPreferences.getString(ApiConstants.profileid)}',
        "authorizationToken":
            "${sharedPreferences.getString(ApiConstants.token)}",
      };
      Http.Response _response = await Http.post(
        Uri.parse(ApiConstants.baseUrl + uri),
        body: jsonEncode(body),
        headers: {...headerschat, "Content-Type": "application/json"},
      ).timeout(Duration(seconds: timeoutInSeconds));

      Response response = handleResponse(_response, uri);

      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> myridepostData(String uri, dynamic body) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'You are using VPN');
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      String? profileId = prefs.getString(ApiConstants.profileid);
      String? token = prefs.getString(ApiConstants.token);

      Http.Response httpResponse = await Http.post(
        Uri.parse(ApiConstants.baseUrl + uri),
        body: jsonEncode(body),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'id': profileId ?? "",
          'authorizationToken': token ?? "",
        },
      ).timeout(Duration(seconds: timeoutInSeconds));

      if (Foundation.kDebugMode) {
        print("STATUS: ${httpResponse.statusCode}");
      }

      return handleResponse(httpResponse, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
    String uri,
    Map<String, String> body,
    File? imageFile,
  ) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    }

    log('testing   $body');
    try {
      Map<String, String> headers = {'Accept': 'application/json'};

      var request = Http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.baseUrl + uri),
      );

      request.headers.addAll(headers);

      request.fields.addAll(body);

      if (imageFile != null) {
        request.files.add(
          await Http.MultipartFile.fromPath('profile_image', imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await Http.Response.fromStream(streamedResponse);

      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartNewSelectProfile(
    String uri,
    Map<String, String> body,
    File? imageFile,
  ) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    }
   

    log('testing   $body');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
         'id': ApiConstants.userIdSocial.isNotEmpty
          ? ApiConstants.userIdSocial
          : (sharedPreferences.getString(ApiConstants.profileid) ?? ""),

      'authorizationToken': ApiConstants.userTokenSocial.isNotEmpty
          ? ApiConstants.userTokenSocial
          : (sharedPreferences.getString(ApiConstants.token) ?? ""),
        
      };
 debugPrint('user testing $headers');
      var request = Http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.baseUrl + uri),
      );

      request.headers.addAll(headers);

      request.fields.addAll(body);

      if (imageFile != null) {
        request.files.add(
          await Http.MultipartFile.fromPath('profile_image', imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await Http.Response.fromStream(streamedResponse);

      return handleResponse(response, uri);
    } catch (e) {// 'id': userId,
        // 'authorizationToken':
        //     '${sharedPreferences.getString(ApiConstants.token)}',
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartUpdate(
    String uri,
    Map<String, String> body,
    dynamic imageFile,
  ) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'You are using VPN');
    }

    try {
      log('POST body server image: $body');

      

      var request = Http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.baseUrl + uri),
      );
       debugPrint(' testing edit profile ${body}');

      request.headers.addAll({
        'Accept': 'application/json',
         'id': ApiConstants.userIdSocial.isNotEmpty
          ? ApiConstants.userIdSocial
          : (sharedPreferences.getString(ApiConstants.profileid) ?? ""),

      'authorizationToken': ApiConstants.userTokenSocial.isNotEmpty
          ? ApiConstants.userTokenSocial
          : (sharedPreferences.getString(ApiConstants.token) ?? ""),
        // 'id': userId,
        // 'authorizationToken':
        //     '${sharedPreferences.getString(ApiConstants.token)}',
      });

      request.fields.addAll(body);

      if (imageFile != null) {
        if (imageFile is File && await imageFile.exists()) {
          request.files.add(
            await Http.MultipartFile.fromPath('profile_image', imageFile.path),
          );
          log('Uploading file: ${imageFile.path}');
        } else if (imageFile is String) {
          request.fields['old_profile_image'] = imageFile;
          log('Sending old image URL as string: $imageFile');
        }
      }

      var streamedResponse = await request.send();
      var response = await Http.Response.fromStream(streamedResponse);

      log('Multipart response: ${response.statusCode}, body: ${response.body}');

      return handleResponse(response, uri);
    } catch (e, st) {
      log('Multipart upload error: $e\n$st');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postDataMap(String uri, dynamic body) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Call: $uri');
        }
        Http.Response _response = await Http.post(
          Uri.parse(ApiConstants.baseUrl + uri),
          body: body,
          headers: _mainHeadersMain,

          /// _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        Response response = handleResponse(_response, uri);

        if (Foundation.kDebugMode) {
          print(
            '====> API Response: [${response.statusCode}] $uri',
          );
        }
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  ///_mainHeadersMain
  ///
  ///

  Future<Response> getDataApi(String uri) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    } else {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Call : $uri');
        }

        Map<String, String> headers = {
          'Accept': 'application/json',
          'id': '${sharedPreferences.getString(ApiConstants.profileid)}',
          'authorizationToken':
              '${sharedPreferences.getString(ApiConstants.token)}',
        };
        Http.Response _response = await Http.get(
          Uri.parse(ApiConstants.baseUrl + uri),
          headers: headers,

          /// _mainHeadersMain,
        ).timeout(Duration(seconds: timeoutInSeconds));
        return handleResponse(_response, uri);
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> getApi(String uri) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    } else {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Call : $uri');
        }
        Http.Response _response = await Http.get(
          Uri.parse(ApiConstants.baseUrl + uri),
          headers: {"Accept": 'application/json'},
        ).timeout(Duration(seconds: timeoutInSeconds));

        return handleResponse(_response, uri);
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> getData(String uri) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    } else {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Call : $uri');
        }
        Http.Response _response = await Http.get(
          Uri.parse(ApiConstants.baseUrl + uri),
          headers: _mainHeadersMain,
          // _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        return handleResponse(_response, uri);
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } catch (e) {}
    Response _response = Response(
      body: _body != null ? _body : response.body,
      bodyString: response.body.toString(),
      request: Request(
        headers: response.request!.headers,
        method: response.request!.method,
        url: response.request!.url,
      ),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
      // if (_response.body.toString().startsWith('{errors: [{code:')) {
      //   ErrorResponse errorResponse = ErrorResponse.fromJson(_response.body);
      //   _response = Response(
      //       statusCode: _response.statusCode,
      //       body: _response.body,
      //       statusText: errorResponse.errors[0].message);
      // } else if (_response.body.toString().startsWith('{message')) {
      //   _response = Response(
      //       statusCode: _response.statusCode,
      //       body: _response.body,
      //       statusText: _response.body['message']);
      // }
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    return _response;
  }
}
