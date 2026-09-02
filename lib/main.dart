import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/app_constants.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/helper/get_di.dart' as di;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';

/// Channel id shared with the manifest's
/// com.google.firebase.messaging.default_notification_channel_id, so a
/// message shown by FCM in the background and one shown by [_showNotification]
/// in the foreground land on the same channel with the same importance.
const String _fcmChannelId = 'high_importance_channel';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = ColorResources.appColor
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = ColorResources.appColor
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _setupMessaging();
    WidgetsBinding.instance.addObserver(this);
    // The app is on-screen and running the moment this widget exists —
    // matches the "resumed" case below, so the backend's very first read of
    // this rider is "not killed" rather than whatever it was left at from a
    // previous session.
    _updateAppKilledStatus(isAppKilled: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Flutter has no callback for the app's OS process actually being
  /// killed — by the time that happens, the Dart VM (and this code with it)
  /// has already stopped running, so there is nothing left to send a
  /// request from. [AppLifecycleState] is the closest available signal:
  /// `resumed` genuinely means running and on-screen; `paused`/`detached`
  /// mean the app has left the foreground and, on Android, is now eligible
  /// to be killed by the OS at any point with no further warning to this
  /// code. Reporting "killed" as soon as backgrounding starts — rather than
  /// waiting for confirmation that never comes — is the standard
  /// simplification every app taking this approach makes.
  ///
  /// `inactive` (a brief transitional state — e.g. a system dialog or the
  /// app switcher overlaying it) is deliberately not treated as killed:
  /// the app is still fully running underneath, and toggling the backend's
  /// flag on every such transient overlay would be noise, not signal.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _updateAppKilledStatus(isAppKilled: false);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _updateAppKilledStatus(isAppKilled: true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _updateAppKilledStatus({required bool isAppKilled}) async {
    try {
      // AuthController may not be registered yet if this fires before
      // get_di's setup completes, or the rider may not be logged in at all
      // (no id/authorizationToken to send) — either way, this is a
      // best-effort background signal, never something worth surfacing an
      // error for.
      await Get.find<AuthController>().authRepo.updateAppKilledStatus(
            isAppKilled: isAppKilled,
          );
    } catch (e) {
      debugPrint('[AppKilledStatus] update failed: $e');
    }
  }

  /// Notifications were arriving from FCM but never appearing. Two reasons,
  /// both fixed here and in the manifest:
  ///
  ///  - POST_NOTIFICATIONS wasn't declared at all (see AndroidManifest), so
  ///    from Android 13 on, the OS dropped every notification and the
  ///    requestPermission() call below had nothing it could grant.
  ///  - Nothing handled foreground messages. FCM only auto-posts to the
  ///    system tray while the app is backgrounded; with the app open it
  ///    hands the message to onMessage and shows nothing itself. This app
  ///    had no onMessage listener and never initialised
  ///    flutter_local_notifications (it was a dependency, unused anywhere in
  ///    lib/), so anything arriving while the rider was actually using the
  ///    app — which is most of a booking — was silently discarded.
  Future<void> _setupMessaging() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await flutterLocalNotificationsPlugin.initialize(
      settings: const InitializationSettings(android: androidInit),
    );

    // Created explicitly rather than left to first-post creation: FCM's
    // background notifications reference this channel by id from the
    // manifest, and if it doesn't exist yet when one arrives, Android falls
    // back to a low-importance default that shows silently.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _fcmChannelId,
            'High Importance Notifications',
            description: 'Ride updates, driver assignment and trip alerts.',
            importance: Importance.high,
          ),
        );

    // Now that the permission is actually declared, this can genuinely
    // grant it on Android 13+.
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _handleFcmMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleFcmMessage);

    FirebaseMessaging.onMessage.listen(_showNotification);
  }

  void _handleFcmMessage(RemoteMessage message) {
    debugPrint('[FCM] Notification Tapped: ${message.data}');
  }

  void _showNotification(RemoteMessage message) {
    final notification = message.notification;
    // Data-only messages have no title/body to render — those are for the
    // app to act on, not to show, so posting an empty notification for one
    // would just be noise.
    if (notification == null) return;

    flutterLocalNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _fcmChannelId,
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
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
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: EasyLoading.init()(context, child),
        );
      },
    );
  }
}
