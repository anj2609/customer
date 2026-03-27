import 'package:evfual/app/modules/Deshboard/buttom_navigation.dart';
import 'package:evfual/app/modules/auth/otp_screen.dart';
import 'package:evfual/app/modules/auth/sign_up_screen.dart';
import 'package:evfual/app/modules/auth/user_ride_signin_screen.dart';
import 'package:evfual/app/modules/profile/profile.dart';
import 'package:evfual/app/modules/splash/onbording_screen.dart';
import 'package:get/get.dart';
import 'package:evfual/app/modules/auth/login_screen.dart';
import 'package:evfual/app/modules/splash/splash_screen.dart';
import 'package:evfual/config/utils/constants.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String onbordingscreen = '/onbordingscreen';
  static const String lestStartedScreen = '/lestStartedScreen';
  static const String userSignunpScreen = '/userSignunpScreen';
  static const String otpScreen = '/otpScreen';
  static const String login = '/login';
  static const String profileScreen = '/profileScreen';
  static const String mainNavigationScreen = '/mainNavigationScreen';
  static const String policyscreen = '/policyscreen';
  static const String forgotpassword = '/forgorpassword';
  static const String referralScreen = '/referralScreen';
  static const String commisionscreeen = '/commisionscreeen';
  static const String dasboard = '/dashboard';
  static const String welcome = '/welcome';
  static const String myInvestmentScreen = '/myInvestmentScreen';
  static const String referAndEarnPage = '/referAndEarnPage';
  static const String referralCommissionPage = '/referralCommissionPage';

  ///mainNavigation
  static getSplashRoute() => splash;
  static getOnboardingRoute() => onbordingscreen;
  static getotpScreenRoute(String? phoneNumber) {
    Get.toNamed(otpScreen, arguments: phoneNumber.toString());
  }

  // =>
  // otpScreen;
  static getLestMyRideStartedScreenRoute() => lestStartedScreen;
  static getuserSignunpScreenRoute() => userSignunpScreen;
  static getLoginRoute() => login;
  static getRegisterRoute() => myInvestmentScreen;
  static getwelcomesrcRoute() => policyscreen;
  static getprofileScreenRoute(String? mobileNumber) {
    Get.toNamed(profileScreen, arguments: mobileNumber);
  }

  static getmainNavigationScreen() => mainNavigationScreen;

  ///() => profileScreen;
  static getotpRoute() => referralScreen;
  static getdasboardRoute() => dasboard;
  static getForgotPasswordScreenRoute() => forgotpassword;
  static getHomeScreenRoute() => commisionscreeen;
  static getWelcomeRoute() => welcome;
  static getchangepassworddRoute() => referAndEarnPage;
  static getReferralCommissionPage() => referralCommissionPage;

  ///mainNavigation
  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    ///// ===== Route  the  main  screen =====
    GetPage(
      name: otpScreen,
      page: () => OtpScreen(phoneNumber: Get.arguments),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    /////OtpScreen
    GetPage(
      name: login,
      page: () => LoginScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: onbordingscreen,
      page: () => OnBoardingSCreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: lestStartedScreen,
      page: () => LatestMyRideLoginScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: userSignunpScreen,
      page: () => UserSignInpScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profileScreen,
      page: () => ProfilePage(phonenumber: Get.arguments),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: mainNavigationScreen,
      page: () => MainNavigation(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),

    ///// ProfilePage MainNavigation
  ];
}
