import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:myrideuser/app/modules/auth/terms_and_conditions_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String? type;
  final String? phoneNumber;
  const OtpScreen({super.key, this.type, this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int _secondsRemaining = 28;
  Timer? _timer;
  bool _enableResend = false;
  bool _isResending = false;
  bool _isVerifying = false;
  bool _termsAccepted = false;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
  void dispose() {
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
                "Enter OTP Code",
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
                    if (!_termsAccepted) {
                      AnimatedTopToast.show(
                        context: context,
                        message: "Please accept the Terms & Conditions to continue.",
                        backgroundColor: ColorResources.textColorBaclColor,
                        icon: Icons.info_outline,
                      );
                      _otpController.clear();
                      return;
                    }

                    if (_isVerifying) return;
                    setState(() => _isVerifying = true);

                    try {
                      await Get.find<AuthController>().verifyOtpApi(
                        mobileNumber: widget.phoneNumber.toString(),
                        numOfOtp: pin,
                        type: widget.type?.trim() ?? "",
                        context: context,
                      );
                    } catch (e) {
                      AnimatedTopToast.show(
                        context: context,
                        message: "Verification failed. Please try again.",
                        backgroundColor: ColorResources.textColorBaclColor,
                        icon: Icons.error_outline,
                      );
                    } finally {
                      if (mounted) setState(() => _isVerifying = false);
                    }
                    // Get.find<AuthController>().verifyOtpApi(
                    //   mobileNumber: widget.phoneNumber.toString(),
                    //   numOfOtp: pin,
                    //   type: widget.type!.trim() ?? "",
                    //   context: context,
                    // );
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// Terms & Conditions checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (v) =>
                        setState(() => _termsAccepted = v ?? false),
                    activeColor: ColorResources.blueeebutton,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "I agree to My Ride ",
                        style: PoppinsMedium.copyWith(
                          fontSize: 13,
                          color: ColorResources.blackcolor11,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms & Conditions",
                            style: PoppinsMedium.copyWith(
                              fontSize: 13,
                              color: ColorResources.blueeebutton,
                              decoration: TextDecoration.underline,
                              decorationColor: ColorResources.blueeebutton,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(
                                    () => const TermsAndConditionsScreen(),
                                    transition: Transition.rightToLeft,
                                    duration:
                                        const Duration(milliseconds: 300),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (_isVerifying)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),

              const SizedBox(height: 16),
              Center(
                child: CustomOtpButton(
                  text: _enableResend
                      ? "Resend OTP"
                      : "Resend in $_secondsRemaining sec",
                  isLoading: _isResending,
                  onTap: (_enableResend && !_isResending)
                      ? () async {
                          log('resend otp clicked |||||');
                          setState(() => _isResending = true);

                          try {
                            await Get.find<AuthController>().reSendOtp(
                              mobileNumber: widget.phoneNumber.toString(),
                              otpNumber: _otpController.text.trim(),
                              context: context,
                            );

                            _otpController.clear();
                            startTimer();
                          } catch (e) {
                            AnimatedTopToast.show(
                              context: context,
                              message: "Failed to resend OTP. Please try again.",
                              backgroundColor: ColorResources.textColorBaclColor,
                              icon: Icons.error_outline,
                            );
                          } finally {
                            if (mounted) setState(() => _isResending = false);
                          }

                          // setState(() {
                          //   _isResending = true;
                          // });

                          // await Get.find<AuthController>().reSendOtp(
                          //   mobileNumber: "${widget.phoneNumber.toString()}",
                          //   otpNumber: _otpController.text.trim(),
                          //   context: context,
                          // );
                          // _otpController.clear();

                          // setState(() {
                          //   _isResending = false;
                          // });

                          // startTimer();
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
