import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vivashri/app/modules/profilefrom/basic_details.dart';
import 'package:vivashri/config/utils/all_images.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  final String? mobileemail;
  final String? userid;
  const OtpScreen({super.key, this.mobileemail, this.userid});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  void checkOtpAndSubmit() {
    String otp = controllers.map((e) => e.text).join();
    if (otp.length == 4) {
      FocusScope.of(context).unfocus(); // hide keyboard
      print("OTP Done: $otp");
      //  hitApi(otp);
    }
  }

  @override
  void initState() {
    super.initState();
    focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorResources.primarycolor,

      body: Stack(
        children: [
          SizedBox(
            height: size.height * 0.45,
            width: double.infinity,
            child: Image.asset(Images.loginscren, fit: BoxFit.cover),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: size.height * 0.35,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset("assets/images/logo2.png", height: 35),
                  ),
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: ColorResources.primarycolor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Login To Your Account",
                      style: opensansSemiBold.copyWith(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Enter the one time password",
                        style: opensansSemiBold.copyWith(
                          fontSize: 16,
                          color: ColorResources.primarycolor3,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Divider(),

                      const SizedBox(height: 5),

                      Text(
                        "A code has been sent to ${widget.mobileemail}",
                        style: opensansMedium.copyWith(
                          color: ColorResources.blackgrey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => Container(
                            height: 55,
                            width: 55,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                              ),

                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 3) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(focusNodes[index + 1]);
                                  }
                                  checkOtpAndSubmit();
                                } else {
                                  if (index > 0) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(focusNodes[index - 1]);

                                    Future.delayed(
                                      Duration(milliseconds: 50),
                                      () {
                                        controllers[index - 1].clear();
                                      },
                                    );
                                  }
                                }
                              },

                              onSubmitted: (_) => checkOtpAndSubmit(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      GestureDetector(
                        onTap: () {
                          Get.find<AuthController>().ortverifyapi(
                            context: context,
                            userid: widget.userid,
                            otp: '1234',
                            devicetoken: '',
                          );
                          // Get.to(
                          //   BasicDetailsScreen(),
                          //   duration: Duration(
                          //     milliseconds: ApiConstants.screenTransitionTime,
                          //   ),
                          //   transition: Transition.rightToLeft,
                          // );
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFBE266B), Color(0xFFEB1D7B)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Submit OTP",
                              style: opensansSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
