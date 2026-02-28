import 'package:evfual/app/modules/auth/login_screen.dart';
import 'package:evfual/app/modules/auth/user_ride_signin_screen.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:evfual/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRideLoginScreen extends StatelessWidget {
  const MyRideLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ColorResources.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splashscreen.png',
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.5,
                color: ColorResources.blueeebutton,
                fit: BoxFit.contain,
              ),
              // Image.asset(
              //   'assets/images/splashscreen.png',
              //   height: 130,
              //   width: 200,
              //   color: ColorResources.blueeebutton,
              // ),

              /// Heading
              Text(
                "Let’s Get Started!",
                style: PoppinsMedium.copyWith(color: ColorResources.blackcolor),
              ),

              const SizedBox(height: 8),

              Text(
                "Let’s dive in into your account",
                style: PoppinsMedium.copyWith(
                  color: ColorResources.TextColorForGrey,
                ),
              ),

              const SizedBox(height: 40),

              /// Social Buttons
              CustomSocialButton(
                text: "Continue with Google",
                images: 'assets/images/google.png',
                // icon: FontAwesomeIcons.google,
                iconColor: Colors.red,

                onTap: () {},
              ),

              CustomSocialButton(
                text: "Continue with Apple",
                images: 'assets/images/apple.png',
                iconColor: Colors.black,
                onTap: () {},
              ),

              CustomSocialButton(
                text: "Continue with Facebook",
                images: 'assets/images/facebook.png',
                iconColor: Colors.blue,
                onTap: () {},
              ),

              CustomSocialButton(
                text: "Continue with X",
                images: 'assets/images/twitter.png',
                // icon: Icons.close, // No official X icon in Material
                iconColor: Colors.black,
                onTap: () {},
              ),

              //const Spacer(),
              const SizedBox(height: 16),

              CustomPrimaryButton(
                text: "Sign up",
                onTap: () {
                  Get.to(
                    UserSignInpScreen(),
                    transition: Transition.leftToRight,
                    duration: Duration(milliseconds: 0),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// Sign In Button
              CustomSecondaryButton(
                text: "Sign in",
                onTap: () {
                  Get.to(
                    LoginScreen(),
                    transition: Transition.leftToRight,
                    duration: Duration(milliseconds: 0),
                  );
                },
              ),

              // const SizedBox(height: 20),
              const Spacer(),

              /// Footer
              Text(
                "Privacy Policy  •  Term of Service",
                style: PoppinsMedium.copyWith(
                  fontSize: 10,

                  color: ColorResources.TextColorForGrey,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
