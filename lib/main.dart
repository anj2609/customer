import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:vivashri/call_parent/chat/firebase_options.dart';
import 'package:vivashri/config/route.dart';
import 'package:vivashri/config/utils/app_constants.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/helper/get_di.dart' as di;
import 'package:vivashri/config/utils/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  await di.init();
  runApp(MyApp());
  configLoading();
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    log('Notification Channel Result: ');
  } catch (e) {
    log('Error initializing Firebase: $e');
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = ColorResources.primarycolor3
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _deviceToken;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late StreamSubscription connectivityStream;

  @override
  void dispose() {
    connectivityStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getDeviceToken();

    FirebaseMessaging.instance.requestPermission();
    _initializeFlutterLocalNotifications();
    // CallKitService.listenCallKitEvents(navigatorKey);
    // Foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("mesaage =============${message.data['userId']}");
      // if (chatController.currentChatId != message.data['userId']) {
      _showNotification(message);
      // }
      if (message.data['type'] == '1') {
        // CallKitService.showIncomingCall(message.data);
      } else if (message.data['type'] == 'call_end') {
        log("📞 CALL END RECEIVED — closing screen");
        if (Get.isOverlaysOpen) {
          Get.back(); // Close dialogs/sheets
        }
        if (Get.isDialogOpen == true) {
          Get.back(); // Close any dialog
        }
        //  await FlutterCallkitIncoming.endAllCalls();
      }
    });
    connectivityStream = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result.contains(ConnectivityResult.none)) {
        _showNoInternetDialog();
      }
    });
    // App background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("User tapped on the notification: ${message.notification?.title}");
      if (message.data['type'] == '1') {
        // CallKitService.showIncomingCall(message.data);
      } else if (message.data['type'] == 'call_end') {
        log("📞 CALL END RECEIVED — closing screen");
        if (Get.isOverlaysOpen) {
          Get.back(); // Close dialogs/sheets
        }
        if (Get.isDialogOpen == true) {
          Get.back(); // Close any dialog
        }

        // await FlutterCallkitIncoming.endAllCalls();
      }
    });
  }

  Future<void> _getDeviceToken() async {
    // FirebaseMessaging instance  device token
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    setState(() {
      _deviceToken = token;
    });

    // Device token
    print("Device Token: $_deviceToken");
  }

  void _initializeFlutterLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'high_importance_channel', // channel Id
          'High Importance Notifications', // channel Name
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  void _showNoInternetDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: CupertinoAlertDialog(
          title: Column(
            children: [
              Icon(
                CupertinoIcons.wifi_exclamationmark,
                size: 60,
                color: CupertinoColors.destructiveRed,
              ),
              SizedBox(height: 10),
              Text(
                "No Internet Connection",
                style: opensansSemiBold.copyWith(fontSize: 20),
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Please check your network.\nTap refresh to try again.",
              style: opensansSemiBold.copyWith(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                var res = await Connectivity().checkConnectivity();

                if (res.contains(ConnectivityResult.mobile) ||
                    res.contains(ConnectivityResult.wifi)) {
                  Get.back();
                }
              },
              child: Text(
                "Refresh",
                style: opensansSemiBold.copyWith(
                  color: ColorResources.primarycolor2,
                  fontSize: 16,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                exit(0);
              },
              child: Text(
                "Close App",
                style: opensansSemiBold.copyWith(
                  color: ColorResources.primarycolor2,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,

      title: AppConstants.appName,
      initialRoute: RouteHelper.getSplashRoute(),
      getPages: RouteHelper.routes,
      defaultTransition: Transition.topLevel,
      transitionDuration: const Duration(milliseconds: 500),

      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: ColorResources.primarycolor,

            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: EasyLoading.init()(context, child),
        );
      },
    );
  }
}
