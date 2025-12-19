import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vivashri/call_parent/chat/api/notification_access_token.dart';

class NotificationService {
  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    String myToken = "";
    await fMessaging.getToken().then((t) {
      if (t != null) {
        myToken = t;
        print("push token $t");
        log('Push Token: $t');
      }
    });

    // for handling foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message data: ${message.data}');
        log(
          'Message also contained a notification: ${message.notification!.title}',
        );
      }
    });
  }

  static Future<void> sendCallPushNotification({
    required String receiverToken,
    required String name,
    required String senderToken,
    required String userId,
    required String msg,
    required String channelId,
    required String type,
  }) async {
    try {
      final body = {
        "message": {
          "token": receiverToken,
          "notification": {"title": name, "body": msg},
          "data": {
            'caller_name': name,
            'type': type,
            'avatar': 'https://i.pravatar.cc/100',
            'userId': userId,
            'token': senderToken,
            "channelId": channelId,
          },
        },
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'vivashri-fbc37';

      // get firebase admin token
      final bearerToken = await NotificationAccessToken.getToken;
      log('bearerToken: $bearerToken');

      // handle null token
      if (bearerToken == null) return;

      var res = await post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectID/messages:send',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );

      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  static Future<void> sendCallEndedNotification(
    String token,
    String channelId,
  ) async {
    try {
      final body = {
        "message": {
          "token": token,
          "notification": {
            "title": "Call end", //our name should be send
            "body": "Call end ............",
          },
          "data": {
            'type': "call_end",
            'avatar': 'https://i.pravatar.cc/100',
            "channelId": channelId,
          },
        },
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'vivashri-fbc37';

      // get firebase admin token
      final bearerToken = await NotificationAccessToken.getToken;
      log('bearerToken: $bearerToken');

      // handle null token
      if (bearerToken == null) return;

      var res = await post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectID/messages:send',
        ),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );

      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }
}
