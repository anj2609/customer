import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:vivashri/config/route.dart';
import 'package:vivashri/config/utils/app_constants.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/helper/get_di.dart' as di;
import 'package:vivashri/config/utils/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  late StreamSubscription connectivityStream;

  @override
  void initState() {
    super.initState();

    connectivityStream = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result.contains(ConnectivityResult.none)) {
        _showNoInternetDialog();
      }
    });
  }

  @override
  void dispose() {
    connectivityStream.cancel();
    super.dispose();
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
