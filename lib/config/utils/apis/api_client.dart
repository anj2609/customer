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
import 'package:myrideuser/config/route.dart';

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

  ApiClient({required this.sharedPreferences});

  Map<String, String> get _mainHeadersMain => _authHeaders();

  /// Unified auth headers: prefers in-memory social-login credentials,
  /// falls back to SharedPreferences.  Every API method should use this
  /// so that social-login sessions are never ignored.
  Map<String, String> _authHeaders({bool includeContentType = true}) {
    final String profileId = ApiConstants.userIdSocial.isNotEmpty
        ? ApiConstants.userIdSocial
        : (sharedPreferences.getString(ApiConstants.profileid) ?? "");
    final String authToken = ApiConstants.userTokenSocial.isNotEmpty
        ? ApiConstants.userTokenSocial
        : (sharedPreferences.getString(ApiConstants.token) ?? "");

    final headers = <String, String>{
      'Accept': 'application/json',
      'id': profileId,
      'authorizationToken': authToken,
    };
    if (includeContentType) {
      headers['Content-Type'] = 'application/json';
    }
    return headers;
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
      // Use unified auth headers for chat too
      Http.Response _response = await Http.post(
        Uri.parse(ApiConstants.baseUrl + uri),
        body: jsonEncode(body),
        headers: _authHeaders(),
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
      Http.Response httpResponse = await Http.post(
        Uri.parse(ApiConstants.baseUrl + uri),
        body: jsonEncode(body),
        headers: _authHeaders(),
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
      Map<String, String> headers = _authHeaders(includeContentType: false);
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
    } catch (e) {
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

      request.headers.addAll(_authHeaders(includeContentType: false));

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

  Future<Response> getDataApi(String uri) async {
    if (await ApiChecker.isVpnActive()) {
      return Response(statusCode: -1, statusText: 'you are using vpn');
    } else {
      try {
        if (Foundation.kDebugMode) {
          print('====> GetX Call : $uri');
        }

        Http.Response _response = await Http.get(
          Uri.parse(ApiConstants.baseUrl + uri),
          headers: _authHeaders(includeContentType: false),
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
          headers: _authHeaders(),
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

    // Global session expiry handler: redirect to login on 401/402/unauthenticated
    if (_handleSessionExpiry(_response, uri)) {
      return _response;
    }

    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    return _response;
  }

  /// Debounce flag to prevent multiple simultaneous logout redirects.
  bool _isHandlingSessionExpiry = false;

  /// Non-critical endpoints whose 401s should NOT trigger a forced logout.
  /// Essentially every endpoint except the auth endpoints (login, register,
  /// OTP, social, logout) is listed here.  This means the ONLY way a user
  /// gets auto-logged-out is if one of those auth endpoints itself returns 401.
  static const List<String> _nonCriticalEndpoints = [
    // Profile & account
    'get-profile',
    'update-profile',
    'basic-info',
    // Addresses
    'customer-address-list',
    'customer-add-address',
    'customer-address-update',
    'customer-address-delete',
    // Promos
    'promos-list',
    'promos-category-list',
    'promos-details',
    'customer-promo-list',
    'customer-add-promo',
    // Wallet
    'customer-wallet-balance',
    'create-topup-intent',
    // Notifications & social & security
    'customer-notification-settings',
    'customer-notification-settings-update',
    'customer-social-accounts',
    'customer-connect-social',
    'customer-disconnect-social',
    'customer-account-security',
    'customer-account-security-update',
    // Drivers / vehicles
    'driver-availble-list',
    'vehical-type-list',
    'track-driver',
    // Booking flow (CRITICAL — must NOT auto-logout)
    'estimate-ride-list',
    'create-booking',
    'track-ride',
    'trip-detail',
    'cancel-ride',
    'cancellation-type-list',
    'rate-driver',
    'complete-ride',
    'payment-status',
    'generate-qr-payment',
    'customer-booking-active',
    'customer-booking-list',
    // Chat
    'chat/start',
    'chat/send',
    'chat/list',
    'chat/messages',
    'chat/read',
    // Misc content
    'faq-list',
    'cms-details',
    'setting-details',
  ];

  /// Returns true if the response indicates an expired session and navigates to login.
  bool _handleSessionExpiry(Response response, String uri) {
    // ── 1. Skip auth-related endpoints (login, register, OTP, etc.) ──
    if (uri.contains('login') || uri.contains('register') ||
        uri.contains('otp') || uri.contains('social') ||
        uri.contains('logout')) {
      return false;
    }

    // ── 2. Skip non-critical background endpoints ──
    final bool isNonCritical = _nonCriticalEndpoints.any(
      (endpoint) => uri.contains(endpoint),
    );
    if (isNonCritical) {
      if (response.statusCode == 401 || response.statusCode == 402) {
        debugPrint(
          '⚠️ [SESSION] 401 on NON-CRITICAL endpoint "$uri" — '
          'ignoring, user stays logged in.',
        );
      }
      return false;
    }

    // ── 3. Determine if this is a genuine session expiry ──
    bool isExpired = false;
    String reason = '';

    // Check HTTP status code
    if (response.statusCode == 401 || response.statusCode == 402) {
      isExpired = true;
      reason = 'HTTP ${response.statusCode}';
    }

    // Check response body for unauthenticated indicators.
    // Only the message text is used — body 'code' is an application-level
    // error field that the server reuses for non-auth errors (e.g. code=401
    // with message="your request is in process" means active booking exists,
    // not an expired session). Checking body code causes false logouts.
    if (!isExpired && response.body != null && response.body is Map) {
      final code = response.body['code']?.toString() ?? '';
      final message = (response.body['message'] ?? '').toString().toLowerCase();
      if (message.contains('unauthenticated') ||
          message.contains('unauthorized')) {
        isExpired = true;
        reason = 'body code=$code message=$message';
      }
    }

    // ── 4. Ignore "Header User id is required" — this is a missing header,
    //       not an expired token. Happens during app init race conditions. ──
    if (isExpired && response.body != null && response.body is Map) {
      final message = (response.body['message'] ?? '').toString().toLowerCase();
      if (message.contains('header') && message.contains('required')) {
        debugPrint(
          '⚠️ [SESSION] 401 on "$uri" but message is about missing headers '
          '("${response.body['message']}") — ignoring, not a session expiry.',
        );
        return false;
      }
    }

    // ── 5. Fire logout (with debounce) ──
    if (isExpired) {
      if (_isHandlingSessionExpiry) {
        debugPrint(
          '⚠️ [SESSION] Already handling session expiry, skipping duplicate '
          'for "$uri".',
        );
        return true;
      }

      if (Get.currentRoute != RouteHelper.getLestMyRideStartedScreenRoute()) {
        _isHandlingSessionExpiry = true;
        debugPrint(
          '🔴 [SESSION] AUTO-LOGOUT triggered!\n'
          '   Endpoint: $uri\n'
          '   Reason: $reason\n'
          '   Route: ${Get.currentRoute}',
        );
        // Clear stored tokens only (preserves preferences, addresses, etc.)
        sharedPreferences.remove(ApiConstants.token);
        sharedPreferences.remove(ApiConstants.profileid);
        // Navigate to login
        Get.offAllNamed(RouteHelper.getLestMyRideStartedScreenRoute());

        // Reset debounce flag after a short delay so future real expiries
        // are still caught (e.g. user logs back in and token expires again)
        Future.delayed(const Duration(seconds: 3), () {
          _isHandlingSessionExpiry = false;
        });
      }
      return true;
    }

    return false;
  }
}
