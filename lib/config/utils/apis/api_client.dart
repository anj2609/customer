import 'dart:convert';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as Http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:evfual/config/utils/apis/api_checker.dart';
import 'package:evfual/config/utils/constants.dart';

class ApiClient extends GetxService {
  String? appBaseUrl = 'https://evfuel.akslearning.in/api/';
  final SharedPreferences sharedPreferences;
  final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String? token;
  String? profileid;
  String? username;
  String? emailid;
  String? pancardno;
  String? passordss;
  //String? userID;
  Map<String, String>? _mainHeaders;

  ApiClient({this.appBaseUrl, required this.sharedPreferences}) {
    //  print(" token.............................................$token");

    _mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${sharedPreferences.getString(ApiConstants.token)}',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // void userId(String userID) {
  //   _mainHeaders = {};
  // }

  Future<Response> postData(String uri, dynamic body) async {
    // if (await ApiChecker.isVpnActive()) {
    //   return Response(statusCode: -1, statusText: 'you are using vpn');
    // }
    {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Base URL: $appBaseUrl');
          print('====> GetX Call: $uri');
          print('====> GetX Body: $body');
        }
        print('====> GetX Basebodyy: $body');
        Http.Response _response = await Http.post(
          Uri.parse(
            'https://evfuel.akslearning.in/api/' + uri,
          ),
          body: jsonEncode(body),
          headers: _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        print("++++++++++++>>>=====");
        Response response = handleResponse(_response, uri);

        if (Foundation.kDebugMode) {
          print(
            '====> API Response: [${response.statusCode}] $uri\n${response.body}',
          );
        }
        print('====>  respnosee : ${response.body}');
        return response;
      } catch (e) {
        return Response(statusCode: 1, statusText: noInternetMessage);
      }
    }
  }

  Future<Response> postDataMap(String uri, dynamic body) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    }
    {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Base URL: $appBaseUrl');
          print('====> GetX Call: $uri');
          print('====> GetX Body: $body');
        }
        print('====> GetX Basebodyy: $body');
        Http.Response _response = await Http.post(
          Uri.parse(appBaseUrl! + uri),
          body: body,
          headers: _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        print("++++++++++++>>>=====");
        Response response = handleResponse(_response, uri);

        if (Foundation.kDebugMode) {
          print(
            '====> API Response: [${response.statusCode}] $uri\n${response.body}',
          );
        }
        print('====>  respnosee : ${response.body}');
        return response;
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
        debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
        print(' Majannaha headers $_mainHeaders');
        print(' url $uri');
        Http.Response _response = await Http.get(
          Uri.parse(appBaseUrl! + uri),
          headers: _mainHeaders,
        ).timeout(Duration(seconds: timeoutInSeconds));
        print(' Majannah headers $_mainHeaders');
        debugPrint('====> API  Fund : - response data v${_response.body}');
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
    debugPrint(
      '====> API Response: [${_response.statusCode}] $uri\n${_response.body}',
    );
    return _response;
  }
}
