import 'dart:async';
import 'dart:developer';

import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/data/controller/auth_controller.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  String? type;
  String? phoneNumber;
  OtpScreen({super.key, this.type, this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  int _secondsRemaining = 28;
  Timer? _timer;
  bool _enableResend = false;
  bool _isResending = false;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForCode();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _secondsRemaining = 28;
      _enableResend = false; // disable button
    });

    _timer?.cancel(); // pehle wala timer cancel karo

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();

        setState(() {
          _enableResend = true; // enable button
        });
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
    Get.find<AuthController>().verifyOtpApi(
      mobileNumber: widget.phoneNumber.toString(),
      numOfOtp: _otpController.text.trim(),

      context: context,
    );
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
            Get.back();
            // Navigator.pop(context);
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
                "Check your messages! We’ve sent a one-time ${widget.phoneNumber} . Enter the code \nbelow to verify your account and continue",

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
                  onCompleted: (pin) async {
                    Get.find<AuthController>().verifyOtpApi(
                      mobileNumber: widget.phoneNumber.toString(),
                      numOfOtp: pin,
                      context: context,
                    );
                  
                  },
                ),
              ),

              const SizedBox(height: 30),
              Center(
                child: CustomOtpButton(
                  text: _enableResend
                      ? "Resend OTP"
                      : "Resend in $_secondsRemaining sec",
                  isLoading: _isResending,
                  onTap: (_enableResend && !_isResending)
                      ? () async {
                          log('resend otp clicked |||||');

                          setState(() {
                            _isResending = true;
                          });

                          await Get.find<AuthController>().reSendOtp(
                            mobileNumber: "${widget.phoneNumber.toString()}",
                            otpNumber: _otpController.text.trim(),
                            context: context,
                          );
                          _otpController.clear();

                          setState(() {
                            _isResending = false;
                          });

                          startTimer();
                        }
                      : null,
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
