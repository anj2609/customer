import 'package:get/get.dart';
import 'package:evfual/app/modules/auth/login_screen.dart';
import 'package:evfual/app/modules/splash/splash_screen.dart';
import 'package:evfual/config/utils/constants.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String onbordingscreen = '/onbordingscreen';
  static const String login = '/login';
  static const String profileScreen = '/profileScreen';
  static const String policyscreen = '/policyscreen';
  static const String forgotpassword = '/forgorpassword';
  static const String referralScreen = '/referralScreen';
  static const String commisionscreeen = '/commisionscreeen';
  static const String dasboard = '/dashboard';
  static const String welcome = '/welcome';
  static const String myInvestmentScreen = '/myInvestmentScreen';
  static const String referAndEarnPage = '/referAndEarnPage';
  static const String referralCommissionPage = '/referralCommissionPage';

  static getSplashRoute() => splash;
  static getOnboardingRoute() => onbordingscreen;
  static getLoginRoute() => login;
  static getRegisterRoute() => myInvestmentScreen;
  static getwelcomesrcRoute() => policyscreen;
  static getCreateAccountRoute() => profileScreen;
  static getotpRoute() => referralScreen;
  static getdasboardRoute() => dasboard;

  static getForgotPasswordScreenRoute() => forgotpassword;
  static getHomeScreenRoute() => commisionscreeen;
  static getWelcomeRoute() => welcome;
  static getchangepassworddRoute() => referAndEarnPage;
  static getReferralCommissionPage() => referralCommissionPage;

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const VivashriIntro()),

 
    GetPage(
        name: login,
        page: () => LoginScreen(),
        transitionDuration:
            const Duration(milliseconds: ApiConstants.screenTransitionTime),
        transition: Transition.rightToLeft),
  ];
}
