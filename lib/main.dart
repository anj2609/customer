// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:vivashri/config/route.dart';
// import 'package:vivashri/config/utils/app_constants.dart';
// import 'package:vivashri/config/utils/colors.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
//   configLoading();
// }

// void configLoading() {
//   EasyLoading.instance
//     ..displayDuration = const Duration(milliseconds: 2000)
//     ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//     ..loadingStyle = EasyLoadingStyle.dark
//     ..indicatorSize = 45.0
//     ..radius = 10.0
//     ..progressColor = Colors.yellow
//     ..backgroundColor = Colors.green
//     ..indicatorColor = Colors.yellow
//     ..textColor = Colors.yellow
//     ..maskColor = Colors.blue.withOpacity(0.5)
//     ..userInteractions = true
//     ..dismissOnTap = false;
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       navigatorKey: Get.key,
//       title: AppConstants.appName,
//       initialRoute: RouteHelper.getSplashRoute(),
//       getPages: RouteHelper.routes,
//       defaultTransition: Transition.topLevel,
//       transitionDuration: Duration(milliseconds: 500),

//       builder: (context, child) {
//         return AnnotatedRegion<SystemUiOverlayStyle>(
//           value: SystemUiOverlayStyle(
//             statusBarColor: ColorResources.primarycolor, // Pink
//             statusBarIconBrightness: Brightness.dark, // Black icons
//             statusBarBrightness: Brightness.light, // Icons white
//           ),
//           child: EasyLoading.init()(context, child),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddVehicleDesign(),
    );
  }
}

class AddVehicleDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double gapBetweenRows = 58; // Top row to bottom row gap (perfect fit)

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE
              Text(
                "Add Vehicle",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),

              SizedBox(height: 8),

              Text(
                "As per notice of Transport Ministry of India, You will have to re-verify your vehicle and driver details",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),

              SizedBox(height: 25),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _button("Click Profile"),
                      SizedBox(width: 5),
                      _straight(30),
                      SizedBox(width: 5),
                      _button("Manage Vehicle"),
                    ],
                  ),

                  Positioned(
                    right: 0,
                    top: 10,
                    child: SizedBox(
                      width: 50,
                      height: gapBetweenRows,
                      child: CustomPaint(
                        painter: PerfectCurvePainter(
                          totalHeight: gapBetweenRows,
                          curveInset: 7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _button("Submit"),
                  SizedBox(width: 5),
                  _straight(20),
                  SizedBox(width: 5),

                  _button("Add details"),
                  SizedBox(width: 5),
                  _straight(20),
                  SizedBox(width: 5),

                  _button("Add Button"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _straight(double width) {
    return SizedBox(
      width: width,
      child: DottedLine(
        dashLength: 4,
        dashGapLength: 4,
        lineThickness: 2,
        dashColor: Colors.grey,
      ),
    );
  }
}

class PerfectCurvePainter extends CustomPainter {
  final double totalHeight;
  final double curveInset;

  PerfectCurvePainter({required this.totalHeight, required this.curveInset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    Path path = Path();

    double startY = 1;
    double endY = totalHeight - 1;
    double radius = (endY - startY) / 2;

    path.moveTo(0, startY);

    path.lineTo(size.width - radius - curveInset, startY);

    path.arcToPoint(
      Offset(size.width - radius - curveInset, endY),
      radius: Radius.circular(radius),
      clockwise: true,
    );

    path.lineTo(0, endY);

    double dash = 6;
    double gap = 4;
    double distance = 0;

    for (var m in path.computeMetrics()) {
      while (distance < m.length) {
        final p1 = m.getTangentForOffset(distance)!.position;
        final p2 = m.getTangentForOffset(distance + dash)!.position;

        canvas.drawLine(p1, p2, paint);

        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
