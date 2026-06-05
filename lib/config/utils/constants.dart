class ApiConstants {
  //==== base url =====

  static const String baseUrl = 'https://myride.infinititechsolution.com/api/';

  ////========= api End Point ==================================
  static const String sendOtpUrl = 'send-otp';
  static const String verityOtpUrl = 'verify-otp';
  static const String reSendOtp = 're-send';
  static const String loginapi = 'login';
  static const String basicInfo = 'basic-info';
  static const String getUserProfileUrl = 'get-profile';
  static const String editProfileUrl = 'update-profile';
  static const String logOutUrl = 'logout';
  static const String socialAuth = 'social-auth';
  static const String estimateUrl = 'estimate-ride-list';
  static const String trackRide = 'track-ride';
  static const String createBooking = 'create-booking';
  static const String tripdetail = 'trip-detail';
  static const String cancellation = 'cancellation-type-list?type=$customer';
  static const String cancelRide = 'cancel-ride';
  static const String rateDriver = 'rate-driver';
  static const String customeraddAddress = 'customer-add-address';
  static const String customeraddAddressListApi = 'customer-address-list';
  static const String customeraddAddressUpdate = 'customer-address-update';
  static const String customeraddAddresdelete = 'customer-address-delete';
  static const String customernotificationsettings =
      'customer-notification-settings';
  static const String customernotificationupdate =
      'customer-notification-settings-update';
  static const String customeraccountsecurity = 'customer-account-security';
  static const String customeraccountsecurityupdate =
      'customer-account-security-update';
  static const String customersocialaccounts = 'customer-social-accounts';
  static const String customerconnectsocial = 'customer-connect-social';
  static const String customerdisconnectsocial = 'customer-disconnect-social';
  static const String customeraddpromo = 'customer-add-promo';
  static const String customerpromolist = 'customer-promo-list';
  static const String driverTracke = 'track-driver'; ////// remaining /////
  static const String customerfqlurl = 'faq-list?type=';
  static const String promoslist = 'promos-list?category=';
  static const String cmsdetails = 'cms-details?slug=';
  static const String settingDetail = 'setting-details';
  static const String promoscategorylist = 'promos-category-list';
  static const String promoslisturl = 'promos-list';
  static const String promosDetail = 'promos-details';
  static const String activeBookingCustomer = 'customer-booking-active';
  static const String customerbookingliststatus =
      'customer-booking-list?status=';
  static const String driverAvailbleList = 'driver-availble-list';
  static const String chatStartUrl = 'chat/start';
  static const String chatSendUrl = 'chat/send';
  static const String chatMessages = 'chat/messages?';
  static const String messageList = 'chat/list';
  static const String chatRead = 'chat/read';
  static const String customerWallet = 'customer-wallet-balance';
   static const String topCreateAmount = 'create-topup-intent';
     static const String vehicalTypeList = 'vehical-type-list';
   /////vehical-type-list




///create-topup-intent
  ///////========= local store data ====================================//////////

  static const String otpapi = 'subscription-add';
  static const int screenTransitionTime = 0;
  static const String theme = 'theme';
  static const String token = 'token';
  static const String usertoken = 'apitoken';
  static const String profileid = 'id';
  static const String name = 'FirstName';

  //////======================  User  Static Data ==================================
  static const String userType = 'driver';
  static const String customer = 'customer';
  static const String pendingBooking = 'pending';
  static const String ongoingBooking = 'ongoing';
  static const String completedBooking = 'completed';
  static const String cancelledBooking = 'cancelled';
  static const String scheduledBooking = 'scheduled';

  static const String UserLogin = 'login';
  static const String UserRegister = 'register';
  static const String profile_image = 'profile_image';
   static const String bookingid = 'bookingid';
   static String userIdSocial = "";
  static String userTokenSocial = "";
  static String provider = "";
  static String usernames = "";
  static String emailAddress= "";
    static String profileImage = "";

  //// usernames / profileImage 
  //
  static const String imageurl = 'https://myride.infinititechsolution.com/';
}

dynamic? customerId;
