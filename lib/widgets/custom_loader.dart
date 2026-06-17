import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myrideuser/config/utils/colors.dart';

///// ================================= Premium Blur Loader ==========================================

class PremiumBlurLoader extends StatelessWidget {
  const PremiumBlurLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SpinKitFadingCircle(
          color: ColorResources.blueeebutton,
          size: 40,
        ),
      ),
    );
  }
}

///// ================================= Full-Screen Blur Overlay ==========================================

class PremiumBlurOverlay extends StatelessWidget {
  const PremiumBlurOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.15),
          child: const PremiumBlurLoader(),
        ),
      ),
    );
  }
}
