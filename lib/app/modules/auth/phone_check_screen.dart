import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myrideuser/app/modules/auth/terms_and_conditions_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/auth_controller.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

class PhoneCheckScreen extends StatefulWidget {
  const PhoneCheckScreen({Key? key}) : super(key: key);

  @override
  State<PhoneCheckScreen> createState() => _PhoneCheckScreenState();
}

class _PhoneCheckScreenState extends State<PhoneCheckScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _termsAccepted = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() => _errorMessage = 'Please enter your phone number.');
      return;
    }
    if (phone.length != 10) {
      setState(() => _errorMessage = 'Please enter a valid 10-digit number.');
      return;
    }
    if (!_termsAccepted) {
      AnimatedTopToast.show(
        context: context,
        message: 'Please accept the Terms & Conditions to continue.',
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.info_outline,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Get.find<AuthController>().checkPhoneAndNavigate(
        context: context,
        phone: phone,
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      _showRetryDialog(msg.isNotEmpty ? msg : 'Unable to verify your account at the moment. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showRetryDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400),
            const SizedBox(width: 8),
            const Text('Verification Failed'),
          ],
        ),
        content: Text(message, style: PoppinsReguler),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorResources.blueeebutton,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Get.back();
              _onContinue();
            },
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorResources.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorResources.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorResources.blackcolor11),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.04),

                    Text(
                      'Enter your phone number',
                      style: PoppinsSemiBold.copyWith(
                        fontSize: Dimensions.spacingSize20,
                        color: ColorResources.blackcolor11,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'We will check if you have an account or help you create one.',
                      style: PoppinsMedium.copyWith(
                        color: ColorResources.TextColorForGrey,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    Text(
                      'Phone Number',
                      style: PoppinsMedium.copyWith(
                        color: ColorResources.blackcolor11,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _errorMessage != null
                              ? Colors.red.shade300
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Image.network(
                                  'https://flagcdn.com/w40/in.png',
                                  height: 20,
                                  width: 30,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.flag, size: 20),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '+91',
                                  style: PoppinsMedium.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 25, color: Colors.grey.shade300),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              onChanged: (v) {
                                if (_errorMessage != null) {
                                  setState(() => _errorMessage = null);
                                }
                                if (v.length == 10) FocusScope.of(context).unfocus();
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: Colors.red.shade400),
                          const SizedBox(width: 4),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: size.height * 0.04),

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

                    SizedBox(height: size.height * 0.03),

                    CustomPrimaryButton(
                      text: 'Continue',
                      onTap: _onContinue,
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: Text(
                        'We will check if your number is registered.\nIf not, we will help you create an account.',
                        textAlign: TextAlign.center,
                        style: PoppinsReguler.copyWith(
                          fontSize: 12,
                          color: ColorResources.TextColorForGrey,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
