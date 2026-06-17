import 'package:myrideuser/app/modules/Deshboard/buttom_navigation.dart';
import 'package:myrideuser/app/modules/Deshboard/cancel_ride_screen.dart';
import 'package:myrideuser/app/modules/Deshboard/driverrating_screen.dart';
import 'package:myrideuser/app/modules/Deshboard/findingdriver_screen.dart';
import 'package:myrideuser/app/modules/Deshboard/promovoucher_screen.dart';
import 'package:myrideuser/app/modules/Deshboard/ridesearch_screen.dart';
import 'package:myrideuser/app/modules/Deshboard/search_scren.dart';
import 'package:myrideuser/app/modules/Promos/promocode_screen.dart';
import 'package:myrideuser/app/modules/Promos/promosdetail_screen.dart';
import 'package:myrideuser/app/modules/acoount/addaddress_screen.dart';
import 'package:myrideuser/app/modules/acoount/contactus_screen.dart';
import 'package:myrideuser/app/modules/acoount/faq_screen.dart';
import 'package:myrideuser/app/modules/acoount/privacypolicy_screen.dart';
import 'package:myrideuser/app/modules/acoount/saveaddress_screen.dart';
import 'package:myrideuser/app/modules/acoount/terms_services_screen.dart';
import 'package:myrideuser/app/modules/acoount/aboutus_model.dart';
import 'package:myrideuser/app/modules/acoount/update/addressupdate_screen.dart';
import 'package:myrideuser/app/modules/activity/canceled_screen.dart';
import 'package:myrideuser/app/modules/auth/otp_screen.dart';
import 'package:myrideuser/app/modules/auth/phone_check_screen.dart';
import 'package:myrideuser/app/modules/auth/sign_up_screen.dart';
import 'package:myrideuser/app/modules/auth/user_ride_signin_screen.dart';
import 'package:myrideuser/app/modules/chats/chat_screen.dart';
import 'package:myrideuser/app/modules/profile/edit_profile.dart';
import 'package:myrideuser/app/modules/profile/profile.dart';
import 'package:myrideuser/app/modules/splash/onbording_screen.dart';
import 'package:get/get.dart';
import 'package:myrideuser/app/modules/auth/login_screen.dart';
import 'package:myrideuser/app/modules/splash/splash_screen.dart';
import 'package:myrideuser/config/utils/constants.dart';

class RouteHelper {
  static const String splash = '/splash';
  static const String onbordingscreen = '/onbordingscreen';
  static const String lestStartedScreen = '/lestStartedScreen';
  static const String userSignunpScreen = '/userSignunpScreen';
  static const String phoneCheckScreen = '/phoneCheckScreen';
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
  static const String editProfileScreen = '/editProfileScreen';
  static const String rideOptionScreen = '/rideOptionScreen';
  static const String promoVoucherScreen = '/promoVoucherScreen';
  static const String findingDriverUI = '/findingDriverUI';
  static const String canceledScreen = '/canceledScreen';
  static const String driverRatingScreen = '/driverRatingScreen';
  static const String cancelRideScreen = '/cancelRideScreen';
  static const String addAddressScreens = '/addAddressScreens';
  static const String savedAddressScreen = '/savedAddressScreen';
  static const String addressUpdateScreen = '/addressUpdateScreen';
  static const String privacyPolicyScreen = '/privacyPolicyScreen';
  static const String contactSupportScreen = '/contactSupportScreen';
  static const String termsOfServiceScreen = '/termsOfServiceScreen';
  static const String faqScreen = '/faqScreen';
  static const String aboutusScreen = '/aboutusScreen';
  static const String promoDetailsScreen = '/promoDetailsScreen';
  static const String promoCodeScreen = '/promoCodeScreen';
  static const String customerChatScreen = '/customerChatScreen';
  static const String searchLocationScreen = '/searchLocationScreen';
  //SearchLocationScreen
  static getSplashRoute() => splash;
  static getOnboardingRoute() => onbordingscreen;
  static getOtpScreenRoute(String? phoneNumber, String? type) {
    Get.toNamed(
      otpScreen,
      arguments: {
        "phone": phoneNumber ?? "",
        "type": type ?? "",
      },
    );
  }

  // =>
  // otpScreen; cancelRideScreen
  static getLestMyRideStartedScreenRoute() => lestStartedScreen;
  static getuserSignunpScreenRoute() => userSignunpScreen;
  static getphoneCheckScreenRoute() => phoneCheckScreen;
  static getLoginRoute() => login;
  static getRegisterRoute() => myInvestmentScreen;
  static getwelcomesrcRoute() => policyscreen;
  static getprofileScreenRoute() => profileScreen;
  // static getprofileScreenRoute(String? mobileNumber) {
  //   Get.toNamed(profileScreen, arguments: mobileNumber);
  // }

  static getmainNavigationScreen() => mainNavigationScreen;
  static geteditProfileScreen() => editProfileScreen;
  static getrideOptionScreen() => rideOptionScreen;
  static getpromoVoucherScreen() => promoVoucherScreen;
  static getfindingDriverUI() => findingDriverUI;
  static getcanceledScreen() => canceledScreen;
  static getdriverRatingScreen() => driverRatingScreen;
  static getcancelRideScreen() => cancelRideScreen;
  static getaddAddressScreens() => addAddressScreens;
  static getsavedAddressScreen() => savedAddressScreen;
  static getaddressUpdateScreen() => addressUpdateScreen;
  static getprivacyPolicyScreen() => privacyPolicyScreen;
  static getcontactSupportScreen() => contactSupportScreen;
  static gettermsOfServiceScreen() => termsOfServiceScreen;
  static getaboutusScreen() => aboutusScreen;
  static getfaqScreen() => faqScreen;
  static getpromoDetailsScreen() => promoDetailsScreen;
  static getpromoCodeScreen() => promoCodeScreen;
  static getchatScreenScreen() => customerChatScreen;
  static getsearchLocationScreen() => searchLocationScreen;
  //    //SearchLocationScreen

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    ///// ===== Route  the  main  screen =====
    GetPage(
      name: otpScreen,
      page: () {
        final args = Get.arguments as Map<String, String>? ?? {};
        return OtpScreen(
          phoneNumber: args["phone"] ?? "",
          type: args["type"] ?? "",
        );
      },
      //page: () => OtpScreen(phoneNumber: Get.arguments),
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
      name: phoneCheckScreen,
      page: () => PhoneCheckScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: profileScreen,
      page: () => ProfilePage(phonenumber: Get.arguments['phonenumber']),
      // arguments: {"phonenumber": Get.arguments},
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
    GetPage(
      name: editProfileScreen,
      page: () => EditProfileScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: rideOptionScreen,
      page: () => RideOptionScreen(
        pickup_lat: Get.arguments['pickup_lat'],
        pickup_lng: Get.arguments['pickup_lng'],
        drop_lat: Get.arguments['drop_lat'],
        drop_lng: Get.arguments['drop_lng'],
      ),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: promoVoucherScreen,
      page: () => PromoVoucherScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: findingDriverUI,
      page: () => FindingDriverUI(booking_id: Get.arguments['booking_id']),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: canceledScreen,
      page: () => CanceledScreen(
        //booking_id: Get.arguments['booking_id']
      ),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: driverRatingScreen,
      page: () => DriverRatingScreen(
        bookingid: Get.arguments['booking_id'],
        drivername: Get.arguments['drivername'],
        details: Get.arguments['details'],
        estimatetime: Get.arguments['estimatetime'],
        distance: Get.arguments['distance'],
        distancekillo: Get.arguments['distancekillo'],
        basefare: Get.arguments['base_fare'],
        discount: Get.arguments['discount'],
        total: Get.arguments['total'],
        profile: Get.arguments['profile'],
      ),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: cancelRideScreen,
      page: () => CancelRideScreen(bookingId: Get.arguments['booking_id']),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: addAddressScreens,
      page: () => AddAddresScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: savedAddressScreen,
      page: () => SavedAddressScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: addressUpdateScreen,
      page: () => AddressUpdateScreen(
        isEdit: Get.arguments['isEdit'],
        index: Get.arguments['index'],
        address: Get.arguments['address'],
      ),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: privacyPolicyScreen,
      page: () => PrivacyPolicyScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: contactSupportScreen,
      page: () => ContactSupportScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: termsOfServiceScreen,
      page: () => TermsOfServiceScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: aboutusScreen,
      page: () => AboutUsScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: faqScreen,
      page: () => FaqScreen(),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: promoDetailsScreen,
      page: () => PromoDetailsScreen(id: Get.arguments['id']),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: promoCodeScreen,
      page: () => PromoCodeScreen(
        promo_id: Get.arguments['promo_id'],

        ///promo_id
      ),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: customerChatScreen,
      page: () => CustomerChatScreen(
        acceptData: Get.arguments['acceptData'],
        bookingId: Get.arguments['bookingId'],
      ),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: searchLocationScreen,
      page: () =>
          SearchLocationScreen(addressdata: Get.arguments['addressdata']),
      transitionDuration: const Duration(
        milliseconds: ApiConstants.screenTransitionTime,
      ),
      transition: Transition.rightToLeft,
    ),
    ///// SearchLocationScreen
  ];
}
