import 'dart:async';
import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/app/modules/profile/profile.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  String? type;
  OtpScreen({super.key, this.type});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  int _secondsRemaining = 28;
  Timer? _timer;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForCode();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 28;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void codeUpdated() {
    _otpController.text = code ?? "";

    if (_otpController.text.length == 4) {
      goToNextScreen();
    }
  }

  void goToNextScreen() {
    // if (widget.type == "Sign in") {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => MainNavigation()),
    //   );
    // } else {
    Get.to(
                            Get.to(ProfilePage()),
                            transition: Transition.leftToRight,
                            duration: Duration(milliseconds: 0),
                          );
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => ProfilePage()),
    // );
    // }
  }

  @override
  void dispose() {
    cancel();
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorResources.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: Icon(Icons.arrow_back, color: ColorResources.blackcolor11),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              const SizedBox(height: 10),

              Text(
                "Enter OTP Code 🔐",
                style: PoppinsSemiBold.copyWith(
                  color: ColorResources.blackcolor11,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Check your messages! We’ve sent a one-time +91 987 654 3210 . Enter the code \nbelow to verify your account and continue",

                style: PoppinsMedium.copyWith(
                  color: ColorResources.TextColorForGrey,
                ),
              ),

              const SizedBox(height: 30),

              /// Pinput Field
              Center(
                child: Pinput(
                  controller: _otpController,
                  length: 4,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (pin) {
                    goToNextScreen();
                  },
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: _secondsRemaining > 0
                    ? Text(
                        "You can resend the code in $_secondsRemaining seconds",
                        style: PoppinsSemiBold.copyWith(
                          fontSize: 13,

                          color: ColorResources.blackcolor11,
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          startTimer();
                        },
                        child: const Text("Resend code"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "OTP Verified ✅",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
