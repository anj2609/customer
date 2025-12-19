// import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/android_params.dart';
// import 'package:flutter_callkit_incoming/entities/call_event.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/entities/ios_params.dart';
// import 'package:flutter_callkit_incoming/entities/notification_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:get/get.dart';
// import 'package:vivashri/call_parent/video_call/screen/video_call.dart';

// class CallKitService {
//   // Show incoming call
//   static Future<void> showIncomingCall(Map<String, dynamic> data) async {
//     // final callId = Uuid().v4();
//     final callId = data['channelId'] ?? 'Unknown';
//     final params = CallKitParams(
//       id: callId,
//       nameCaller: data['caller_name'] ?? 'Unknown',
//       appName: 'CallKit',
//       avatar: data['avatar'] ?? '',
//       handle: data['userId'] ?? '000000',
//       type: int.parse(data['type'] ?? '0'),
//       textAccept: 'Accept',
//       textDecline: 'Decline',
//       duration: 30000,
//       extra: data,

//       headers: {'platform': 'flutter'},
//       missedCallNotification: NotificationParams(
//         showNotification: true,
//         isShowCallback: true,
//         subtitle: 'Missed call',
//         callbackText: 'Call back',
//       ),
//       callingNotification: const NotificationParams(
//         showNotification: true,
//         isShowCallback: true,
//         subtitle: 'Calling...',
//         callbackText: 'Hang Up',
//       ),
//       android: const AndroidParams(
//         isCustomNotification: true,
//         isShowLogo: false,
//         ringtonePath: 'system_ringtone_default',
//         actionColor: '#4CAF50',
//         textColor: '#ffffff',
//         incomingCallNotificationChannelName: 'Incoming Call',
//         missedCallNotificationChannelName: 'Missed Call',
//         isShowCallID: false,
//       ),
//       ios: const IOSParams(
//         iconName: 'CallKitLogo',
//         handleType: 'generic',
//         supportsVideo: true,
//         audioSessionActive: true,
//         ringtonePath: 'system_ringtone_default',
//       ),
//     );

//     await FlutterCallkitIncoming.showCallkitIncoming(params);
//   }

//   // Show missed call notification
//   static Future<void> showMissCallNotification(
//     Map<String, dynamic> data,
//   ) async {
//     // final callId = Uuid().v4();
//     final callId = data['channelId'] ?? 'Unknown';
//     final params = CallKitParams(
//       id: callId,
//       nameCaller: data['caller_name'] ?? 'Unknown',
//       handle: data['caller_number'] ?? '000000',
//       type: int.parse(data['type'] ?? '0'),
//       extra: data,
//       android: const AndroidParams(
//         isCustomNotification: true,
//         isShowCallID: true,
//       ),
//       missedCallNotification: const NotificationParams(
//         showNotification: true,
//         isShowCallback: true,
//         subtitle: 'Missed call',
//         callbackText: 'Call back',
//       ),
//     );
//     await FlutterCallkitIncoming.showMissCallNotification(params);
//   }

//   // Listen to CallKit events
//   static void listenCallKitEvents(GlobalKey<NavigatorState> navigatorKey) {
//     FlutterCallkitIncoming.onEvent.listen((event) {
//       if (event == null) return;

//       // FIX: safely parse body
//       Map<String, dynamic> body = {};

//       if (event.body != null) {
//         body = Map<String, dynamic>.from(event.body);
//       }

//       switch (event.event) {
//         case Event.actionCallIncoming:
//           print("Incoming call received: ${event.body}");
//           break;

//         case Event.actionCallStart:
//           print("Outgoing call started: ${event.body}");
//           break;

//         case Event.actionCallAccept:
//           print("Call accepted: ${event.body}");
//           final callId = body["id"];
//           final type = body["type"];
//           final extra = body["extra"] ?? {};
//           final token = extra["token"];
//           print("Call accepted id = $callId");
//           if (type == 1) {
//             Get.to(VideoCall(channelId: callId, fcmToken: token));
//           } else {
//             // Get.to(VoiceCall(channelId: callId));
//           }

//           // if (callId != null && callId is String && callId.isNotEmpty) {
//           //   navigatorKey.currentState?.push(
//           //     MaterialPageRoute(
//           //       builder: (_) => MyHomePage(channelId: callId),
//           //     ),
//           //   );
//           // }

//           break;

//         case Event.actionCallDecline:
//           print("Call declined: ${event.body}");
//           break;

//         case Event.actionCallEnded:
//           print("Call ended: ${event.body}");
//           break;

//         case Event.actionCallTimeout:
//           print("Missed call: ${event.body}");
//           break;

//         case Event.actionCallCallback:
//           print("Call back tapped: ${event.body}");
//           break;

//         case Event.actionCallConnected:
//           print("Call connected: ${event.body}");
//           break;

//         // iOS only
//         case Event.actionCallToggleHold:
//         case Event.actionCallToggleMute:
//         case Event.actionCallToggleDmtf:
//         case Event.actionCallToggleGroup:
//         case Event.actionCallToggleAudioSession:
//         case Event.actionDidUpdateDevicePushTokenVoip:
//         case Event.actionCallCustom:
//           print("iOS or custom event: ${event.event}");
//           break;

//         default:
//           print("Unhandled Event: ${event.event}");
//       }
//     });
//   }
// }
