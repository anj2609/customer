import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:myrideuser/app/modules/Deshboard/buttom_navigation.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/data/modal/activitt_model.dart';
import 'package:myrideuser/data/modal/activity_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:myrideuser/data/modal/address_Model.dart';
import 'package:myrideuser/data/modal/cms_model.dart';
import 'package:myrideuser/data/modal/contact_model.dart';
import 'package:myrideuser/data/modal/fql_model.dart';
import 'package:myrideuser/data/modal/notificationsetting_model.dart';
import 'package:myrideuser/data/modal/profileModel.dart';
import 'package:myrideuser/data/modal/promocategory_model.dart';
import 'package:myrideuser/data/modal/promodetail_model.dart';
import 'package:myrideuser/data/modal/promolist_model.dart';
import 'package:myrideuser/data/modal/promomodel.dart';
import 'package:myrideuser/data/repository/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:myrideuser/widgets/toaster_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfiileRepo profileRepo;

  ProfileController({required this.profileRepo});
  RxBool isLoading = false.obs;
  Rx<ProfileModels> profile = ProfileModels().obs;

  final evController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();

  Rx<File?> profileImage = Rx<File?>(null);
  String? profileimagee;
  List<AddressModels> addressList = [];
  bool isLoadings = false;
  bool isfqlLoading = false;
  bool isCustomerNotifications = false;
  List<FqlModel> faqList = [];
  List<PromoData> promoList = [];
  List<PromoData> filteredList = [];

  String selectedCategory = "ride";

  List<String> categories = ["ride"];

  bool isPromoDataLoading = false;
  CmsModel? cmsModel;
  bool isCmsLoading = false;
  SettingModel? settingDetail;
  bool isSettingLoading = false;
  PromoCategoryModel? promoCategoryModel;
  List<Data> promoCategoryList = [];
  bool isCategoryLoading = false;
  PromoListModel? promoCategoryListModel;
  List<PromoolistDataModel> promoCategoryListData = [];
  bool isPromoLoading = false;
  PromoDetailsModel? promoDetailsModel;
  bool isPromoDetailsLoading = false;
  bool isActivityLoading = false;

  bool isLoadMore = false;

  int currentPage = 1;
  int lastPage = 1;
  ActivityModel? activityModel;
  ActivityDataModel? activityModeldata;
  List<ActivityDataMainModel>? bookingActivityList = [];
  String? walletbalance;
  bool isCustomerWalletLoading = false;
  bool isTopUpIntentLoading = false;

  late final Razorpay _razorpay;
  String? _pendingOrderId;
  String? _pendingAmount;



  String currentSlug = "pending";
  NotificationSettingsModel? notificationModel;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();

    Future.delayed(Duration.zero, () {
      fetchProfile();
      promoCategoryData(context: Get.context!);
      customerWalletAmount();
    });
  }

  /// Converts raw backend error messages to user-friendly text
  String _sanitizeBackendMessage(String? rawMessage, String fallback) {
    if (rawMessage == null || rawMessage.isEmpty) return fallback;
    final msg = rawMessage.toLowerCase().trim();
    if (msg.contains('data not found') || msg.contains('no data') || msg == 'not found') {
      return fallback;
    }
    if (msg.contains('server') || msg.contains('internal') || msg.contains('exception') || msg.contains('500')) {
      return "We're having trouble connecting. Please try again.";
    }
    if (msg.contains('unauthorized') || msg.contains('unauthenticated')) {
      return "Your session has expired. Please log in again.";
    }
    if (msg.contains('network') || msg.contains('connection') || msg.contains('timeout')) {
      return "Please check your internet connection and try again.";
    }
    // If it's a reasonable sentence, show it
    if (rawMessage.contains(' ') && !rawMessage.contains('_')) {
      return rawMessage;
    }
    return fallback;
  }

  /// Returns true if the backend response message is just 'data not found' — not a real error
  bool _isDataNotFoundResponse(dynamic body) {
    if (body == null || body is! Map) return false;
    final msg = (body['message'] ?? '').toString().toLowerCase().trim();
    return msg.contains('data not found') || msg.contains('no data') || msg == 'not found';
  }
  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchProfile();
  //   promoCategoryData(context: Get.context!);
  //   customerWalletAmount();
  // }

  void fetchProfile() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      isLoading.value = true;

      final response = await profileRepo.profileRepoApi();

      if (response.statusCode == 200) {
        final body = response.body;

        if (body['code'] == "200") {
          profile.value = ProfileModels.fromJson(body);

          final userData = profile.value.data;

          if (userData != null) {
            nameController.text = userData.name ?? "";
            phoneController.text = userData.phone ?? "";
            emailController.text = userData.email ?? "";
            genderController.text = userData.gender ?? "";
            profileimagee = userData.profileImage ?? "";
            dobController.text = userData.dateOfBirth ?? "";

            await sharedPreferences.setString(
              ApiConstants.profile_image,
              userData.profileImage ?? "",
            );

            log(
              "Saved Image: ${sharedPreferences.getString(ApiConstants.profile_image)}",
            );
          }

          log("Name: ${userData!.email}");
          log("Email: ${profileimagee}");
          update();
        }
        // Non-200 'code' (including 'data not found') — background call
        // fired automatically on launch, fail silently like the app's
        // other automatic startup calls.
      }
      // Non-200 status — background call fired automatically on launch,
      // fail silently.
    } catch (e) {
      // /Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage.value = File(image.path);
    }
  }

  void printAllData() {
    debugPrint("EV: ${evController.text}");
    debugPrint("Name: ${nameController.text}");
    debugPrint("Address: ${addressController.text}");
    debugPrint("Phone: ${phoneController.text}");
    debugPrint("Email: ${emailController.text}");
    debugPrint("Profile Image: ${profileImage.value?.path}");
  }

  ///// ========= Api  First Sig-Up Api Call  =========

  Future<Response> updatePersonalInfoApi({
    required BuildContext context,
    String? name,
    String? email,
    String? gender,
    String? dob,
    String? phonebumer,
    File? profileimage,
    String? oldProfile,
  }) async {
    //  EasyLoading.show(status: "Please wait...");
    update();

    Response response;

    try {
      File? finalFile;
      String? oldImageUrl;

      if (profileimage != null) {
        finalFile = profileimage;
      } else if (oldProfile != null && oldProfile.isNotEmpty) {
        oldImageUrl = oldProfile;
      }

      response = await profileRepo.upatePersonalApi(
        name: name?.trim(),
        email: email?.trim(),
        gender: gender?.trim(),
        dob: dob?.trim(),
        phonenumber: phonebumer?.trim(),
        profile_image: finalFile,
        old_profile_image: oldImageUrl,
      );
    } catch (e) {
      /// await EasyLoading.dismiss();
      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
      rethrow;
    }

    final body = response.body;
    ;

    if (body['code'] == '200') {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(response.body['message'], "Updated successfully."),
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Success',
      //   "${response.body['message'] ?? "Updated Successfully"}",
      //   backgroundColor: ColorResources.blueeebutton,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 5),
      // );

      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
      Get.offAndToNamed(RouteHelper.getmainNavigationScreen());
    } else {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(response.body['message'], "Oops! Something went wrong. Please try again."),
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
      // await EasyLoading.dismiss();
      // print('kkkk${response.body}');
      // Get.snackbar(
      //   'Error',
      //   response.body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    }

    update();
    return response;
  }

  ////////// ========  add address  ==============================////////////

  Future<Response> addAddressCustomer({
    required BuildContext context,
    required String label,
    required String address,
    required double lat,
    required double lng,
  }) async {
    // EasyLoading.show(status: "Please wait...");
    update();

    Response response;

    try {
      response = await profileRepo.customerAddAddressapi(
        label: label,
        address: address,
        lat: lat,
        lng: lng,
      );
    } catch (e) {
      ///  await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Error',
      //   "Something went wrong: $e",
      //   backgroundColor: ColorResources.whiteColor,
      //   colorText: ColorResources.textColorRed,
      //   snackPosition: SnackPosition.TOP,
      // );
      rethrow;
    }

    final body = response.body;

    if (body['code'].toString() == '200') {
      //await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Success',
      //   "${body['message'] ?? "Updated Successfully"}",
      //   backgroundColor: ColorResources.blueeebutton,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 5),
      // );
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Updated successfully."),
        backgroundColor: ColorResources.blueeebutton,
        icon: Icons.check_circle_rounded,
      );
      Get.until(
        (route) => route.settings.name == RouteHelper.getsavedAddressScreen(),
      );
      Future.delayed(Duration(seconds: 1), () {
        getAddressCustomer(context: context);
      });
    } else {
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Error',
      //   body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.red,
      //   snackPosition: SnackPosition.TOP,
      // );
    }

    update();
    return response;
  }

  ////////// ========  Update  address  ==============================////////////

  Future<Response> updateAddress({
    required BuildContext context,
    //address_id
    required int address_id,
    required String label,
    required String address,
    required double lat,
    required double lng,
  }) async {
    ///  EasyLoading.show(status: "Please wait...");
    update();

    Response response;

    try {
      response = await profileRepo.customerUpdateAddress(
        label: label,
        address: address,
        lat: lat,
        lng: lng,
        id: address_id,
      );
    } catch (e) {
      /// await EasyLoading.dismiss();
      // Get.snackbar(
      //   '',
      //   "Something went wrong: $e",
      //   backgroundColor: ColorResources.whiteColor,
      //   colorText: ColorResources.textColorRed,
      //   snackPosition: SnackPosition.TOP,
      // );
      rethrow;
    }

    final body = response.body;

    if (body['code'].toString() == '200') {
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Success',
      //   "${body['message'] ?? "Updated Successfully"}",
      //   backgroundColor: ColorResources.blueeebutton,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 5),
      // );
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Updated successfully."),
        backgroundColor: ColorResources.blueeebutton,
        icon: Icons.check_circle_rounded,
      );
      Get.until(
        (route) => route.settings.name == RouteHelper.getsavedAddressScreen(),
      );
      Future.delayed(Duration(seconds: 1), () {
        getAddressCustomer(context: context);
      });
    } else {
      await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Error',
      //   body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.red,
      //   snackPosition: SnackPosition.TOP,
      // );
    }

    update();
    return response;
  }

  ////// =============    Delete  address ================= /////////////

  Future<Response> deleteaddressapi({
    required BuildContext context,
    required int address_id,
    required int index,
  }) async {
    // EasyLoading.show(status: "Please wait...");

    /// BottomSheet close
    Get.back();

    addressList.removeAt(index);
    update();

    Response response;

    try {
      response = await profileRepo.customerDeleteapi(id: address_id);

      final body = response.body;

      if (body['code'].toString() == '200') {
        /// EasyLoading.dismiss();
        getAddressCustomer(context: context);
        AnimatedTopToast.show(
          context: context,
          message: _sanitizeBackendMessage(body['message'], "Deleted successfully."),
          backgroundColor: ColorResources.blueeebutton,
          icon: Icons.check_circle_rounded,
        );
        // Get.snackbar(
        //   '',
        //   body['message'] ?? "Deleted Successfully",
        //   backgroundColor: ColorResources.blueeebutton,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        // );
      } else {
        EasyLoading.dismiss();

        getAddressCustomer(context: context);

        // Get.snackbar(
        //   '',
        //   body['message'] ?? "Something went wrong",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        // );
      }
    } catch (e) {
      EasyLoading.dismiss();

      getAddressCustomer(context: context);

      // Get.snackbar(
      //   '',
      //   "Something went wrong",
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );

      rethrow;
    }

    update();
    return response;
  }

  ////customernoticationssetting

  /// ============================= get customer notification setting ============== ///////

  Future<Response?> getCustomerNotificationsSetting() async {
    try {
      isCustomerNotifications = true;
      update();

      final Response response = await profileRepo.customernoticationssetting();

      print("Notification API Response => ${response.body}");

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['code'].toString() == '200') {
        notificationModel = NotificationSettingsModel.fromJson(
          response.body['data'],
        );
      }

      return response;
    } catch (e) {
      print("getCustomerNotificationsSetting Error => $e");
      return null;
    } finally {
      isCustomerNotifications = false;
      update();
    }
  }
  //// =================== update customer notification ===================== ///////

  Future<Response> updatenotificationsetting({
    required BuildContext context,
    required String type,
    required String status,
  }) async {
    /// EasyLoading.show(status: "Please wait...");

    // Get.back();

    update();

    Response response;

    try {
      response = await profileRepo.customernoticationUpdate(
        type: type.toString(),
        status: status.toString(),
      );

      final body = response.body;

      if (body['code'].toString() == '200') {
        AnimatedTopToast.show(
          context: context,
          message: _sanitizeBackendMessage(body['message'], "Updated successfully."),
          backgroundColor: ColorResources.blueeebutton,
          icon: Icons.check_circle_rounded,
        );
        // EasyLoading.dismiss();
        // Get.snackbar(
        //   '',
        //   body['message'] ?? "Updated Successfully",
        //   backgroundColor: ColorResources.blueeebutton,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        // );
        Get.back();
      } else {
        // EasyLoading.dismiss();
      }
    } catch (e) {
      /// EasyLoading.dismiss();

      rethrow;
    }

    /// EasyLoading.dismiss();
    update();
    return response;
  }

  ///customernoticationUpdate

  Future<Response?> getAddressCustomer({required BuildContext context}) async {
    try {
      isLoadings = true;
      update();

      final Response response = await profileRepo.getcustomeraddress();

      print("Address API Response => ${response.body}");

      if (response.statusCode == 200 && response.body != null) {
        final body = response.body;

        if (body['code'].toString() == '200') {
          if (body['data'] != null &&
              body['data'] is List &&
              (body['data'] as List).isNotEmpty) {
            addressList = (body['data'] as List)
                .map((e) => AddressModels.fromJson(e))
                .where((address) => !address.isNoAddressPlaceholder)
                .toList();
          } else {
            addressList.clear();
          }
        } else {
          addressList.clear();
          // Silently handle; the UI will show "No trips yet" empty state.
        }

        isLoadings = false;
        update();

        return response;
      } else {
        isLoadings = false;
        update();

        // Get.snackbar(
        //   '',
        //   "Server Error",
        //   backgroundColor: ColorResources.textColorRed,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        // );

        return response;
      }
    } catch (e) {
      print("getAddressCustomer Error => $e");

      isLoadings = false;
      addressList.clear();

      update();

      // Get.snackbar(
      //   '',
      //   "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );

      return null;
    }
  }

  ///////customer-booking-list?status=

  ////=========================== Link Account ==================== //////////

  Future<Response> linkAccountConnectCallApi({
    required BuildContext context,
    required String provider,
    required String accesstoken,
  }) async {
    ///   EasyLoading.show(status: "Please wait...");
    update();

    Response response;

    try {
      response = await profileRepo.customerConnectSocial(
        provider: provider.toString(),
        access: accesstoken.toString(),
      );
    } catch (e) {
      //// await EasyLoading.dismiss();
      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textdetailsColor,
        icon: Icons.error_outline,
      );
      rethrow;
    }

    final body = response.body;

    if (body['code'].toString() == '200') {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Updated successfully."),
        backgroundColor: ColorResources.blueeebutton,
        icon: Icons.check_circle_rounded,
      );
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Success',
      //   "${body['message'] ?? "Updated Successfully"}",
      //   backgroundColor: ColorResources.blueeebutton,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 5),
      // );

      Future.delayed(Duration(seconds: 1), () {
        getAddressCustomer(context: context);
      });
      Get.back();
    } else {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Oops! Something went wrong. Please try again."),
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Error',
      //   body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.red,
      //   snackPosition: SnackPosition.TOP,
      // );
    }

    update();
    return response;
  }

  Future<Response> linkAccountDeconnectCallApi({
    required BuildContext context,
    required String provider,
  }) async {
    //EasyLoading.show(status: "Please wait...");
    update();

    Response response;

    try {
      response = await profileRepo.customerdisconnectSocial(
        provider: provider.toString(),
      );
    } catch (e) {
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Error',
      //   "Something went wrong: $e",
      //   backgroundColor: ColorResources.whiteColor,
      //   colorText: ColorResources.textColorRed,
      //   snackPosition: SnackPosition.TOP,
      // );
      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      rethrow;
    }

    final body = response.body;

    if (body['code'].toString() == '200') {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Updated successfully."),
        backgroundColor: ColorResources.blueeebutton,
        icon: Icons.check_circle_rounded,
      );
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Success',
      //   "${body['message'] ?? "Updated Successfully"}",
      //   backgroundColor: ColorResources.blueeebutton,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      //   duration: const Duration(seconds: 5),
      // );
      // Get.until(
      //   (route) => route.settings.name == RouteHelper.getsavedAddressScreen(),
      // );
      Future.delayed(Duration(seconds: 1), () {
        getAddressCustomer(context: context);
      });
      Get.back();
    } else {
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Error',
      //   body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.red,
      //   snackPosition: SnackPosition.TOP,
      // );
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Oops! Something went wrong. Please try again."),
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
    }

    update();
    return response;
  }

  Future<void> getFaqList({
    required BuildContext context,
    required String type,
  }) async {
    isfqlLoading = true;
    update();

    Response response = await profileRepo.customerfqlapi(type: type);

    if (response.body['code'].toString() == "200") {
      FaqModel faqModel = FaqModel.fromJson(response.body);
      faqList = faqModel.data ?? [];
    } else {
      if (!_isDataNotFoundResponse(response.body)) {
        Get.snackbar("Notice", _sanitizeBackendMessage(response.body['message'], "Unable to load FAQs. Please try again."));
      }
    }

    isfqlLoading = false;
    update();
  }

  Future<void> getPromos({String? Cattype}) async {
    isPromoDataLoading = true;
    update();

    Response response = await profileRepo.customerpromocard(
      cattype: Cattype.toString(),
    );

    if (response.body['code'].toString() == "200") {
      PromoModel model = PromoModel.fromJson(response.body);

      promoList = model.data ?? [];
      filteredList = promoList;
    } else {
      if (!_isDataNotFoundResponse(response.body)) {
        Get.snackbar("Notice", _sanitizeBackendMessage(response.body['message'], "Unable to load offers."));
      }
    }

    isPromoDataLoading = false;
    update();
  }

  Future<Response?> privacyPolicy({required BuildContext context}) async {
    isCmsLoading = true;
    update();

    /// EasyLoading.show(status: "Please wait...");

    Response? response;

    try {
      response = await profileRepo.getprivacypolicy(slug: "privacy-policy");
    } catch (e) {
      await EasyLoading.dismiss();
      isCmsLoading = false;
      update();
      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );

      // Get.snackbar(
      //   'Error',
      //   "Something went wrong: $e",
      //   backgroundColor: ColorResources.whiteColor,
      //   colorText: ColorResources.textColorRed,
      //   snackPosition: SnackPosition.TOP,
      // );
      return null;
    }

    /// await EasyLoading.dismiss();

    final body = response.body;

    if (response.statusCode == 200 && body['code'].toString() == "200") {
      cmsModel = CmsModel.fromJson(body);
    } else {
      // Get.snackbar(
      //   'Error',
      //   body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Oops! Something went wrong. Please try again."),
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
    }

    isCmsLoading = false;
    update();

    return response;
  }

  Future<Response?> termandCondition({required BuildContext context}) async {
    isCmsLoading = true;
    update();

    // EasyLoading.show(status: "Please wait...");

    Response? response;

    try {
      response = await profileRepo.gettermandConditions(
        slug: "terms-of-service",
      );
    } catch (e) {
      // await EasyLoading.dismiss();
      isCmsLoading = false;
      update();

      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return null;
    }

    // await EasyLoading.dismiss();

    final body = response.body;

    if (response.statusCode == 200 && body['code'].toString() == "200") {
      cmsModel = CmsModel.fromJson(body);
    } else {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Oops! Something went wrong. Please try again."),
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      // Get.snackbar(
      //   'Error',
      //   body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    }

    isCmsLoading = false;
    update();

    return response;
  }

  Future<Response?> aboutUsApi({required BuildContext context}) async {
    isCmsLoading = true;
    update();

    ///EasyLoading.show(status: "Please wait...");

    Response? response;

    try {
      response = await profileRepo.getaboutUs(slug: "about-us");
    } catch (e) {
    //  await EasyLoading.dismiss();
      isCmsLoading = false;
      update();

      // Get.snackbar(
      //   'Error',
      //   "Something went wrong: $e",
      //   backgroundColor: ColorResources.whiteColor,
      //   colorText: ColorResources.textColorRed,
      //   snackPosition: SnackPosition.TOP,
      // );
       AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return null;
    }

    await EasyLoading.dismiss();

    final body = response.body;

    if (response.statusCode == 200 && body['code'].toString() == "200") {
      cmsModel = CmsModel.fromJson(body);
    } else {
      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      // Get.snackbar(
      //   'Error',
      //   body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    }

    isCmsLoading = false;
    update();

    return response;
  }

  Future<Response?> settingDetails({required BuildContext context}) async {
    isSettingLoading = true;
    update();

   /// EasyLoading.show(status: "Please wait...");

    Response? response;

    try {
      response = await profileRepo.getsettingDetail();
    } catch (e) {
      await EasyLoading.dismiss();
      isSettingLoading = false;
      update();

      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return null;
    }

    await EasyLoading.dismiss();

    final body = response.body;

    if (response.statusCode == 200 && body['code'].toString() == "200") {
      settingDetail = SettingModel.fromJson(body);
    } else {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(body['message'], "Oops! Something went wrong. Please try again."),
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      // Get.snackbar(
      //   'Error',
      //   body['message'] ?? "Something went wrong",
      //   backgroundColor: ColorResources.textColorRed,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
    }

    isSettingLoading = false;
    update();

    return response;
  }

  Future<Response?> promoCategoryData({required BuildContext context}) async {
    isCategoryLoading = true;
    update();

    try {
     /// EasyLoading.show(status: "Please wait...");

      Response? response = await profileRepo.getpromoCategorylist();

      await EasyLoading.dismiss();

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['code'].toString() == "200") {
        promoCategoryModel = PromoCategoryModel.fromJson(response.body);

        promoCategoryList.clear();
        promoCategoryList.addAll(promoCategoryModel?.data ?? []);

        promoCategoryList.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));

        if (promoCategoryList.isNotEmpty) {
          selectedCategory = promoCategoryList.first.name ?? "";
          await getPromoListByCategory(
            category: selectedCategory,
            context: context,
          );
        }

        if (promoCategoryList.isNotEmpty) {
          selectedCategory = promoCategoryList.first.name ?? "";
        }
      } else {
        // Background call fired automatically on launch — fail silently
        // like the other automatic startup calls instead of surfacing an
        // error toast.
        promoCategoryList.clear();
      }
    } catch (e) {
      // Background call fired automatically on launch — fail silently.
    } finally {
      isCategoryLoading = false;
      update();
    }

    return null;
  }

  Future<void> getPromoListByCategory({
    required String category,
    required BuildContext context,
  }) async {
    isPromoLoading = true;
    update();

    try {
     /// EasyLoading.show(status: "Please wait...");

      Response? response = await profileRepo.promoCategorywisedata(
        category: category,
      );

      ///await EasyLoading.dismiss();

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['code'].toString() == "200") {
        PromoListModel promoListModel = PromoListModel.fromJson(response.body);

        promoCategoryListData.clear();
        promoCategoryListData.addAll(promoListModel.data ?? []);
      } else {
        // If API just means "no data", handle silently
        final rawMsg = (response.body?['message'] ?? '').toString().toLowerCase();
        if (rawMsg.contains('data not found') || rawMsg.contains('no data') || rawMsg.contains('not found')) {
          promoCategoryListData.clear();
        } else {
          AnimatedTopToast.show(
            context: context,
            message: _sanitizeBackendMessage(response.body?['message'], "Oops! Something went wrong. Please try again."),
            backgroundColor: ColorResources.textColorRed,
            icon: Icons.error_outline,
          );
        }
      }
    } catch (e) {
      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      // await EasyLoading.dismiss();
      // Get.snackbar(
      //   'Error',
      //   "Something went wrong: $e",
      //   backgroundColor: Colors.white,
      //   colorText: ColorResources.textColorRed,
      //   snackPosition: SnackPosition.TOP,
      // );
    } finally {
      isPromoLoading = false;
      update();
    }
  }

  Future<void> getActivityData({
    required String typeOfSlug,
    required BuildContext context,
  }) async {
    isPromoLoading = true;
    update();

    try {
      ///EasyLoading.show(status: "Please wait...");

      Response? response = await profileRepo.getBookingdata(
        typeSlug: typeOfSlug,
      );

     /// await EasyLoading.dismiss();

      if (response.statusCode == 200 &&
          response.body['code'].toString() == "200") {
        ActivityDataModel model = ActivityDataModel.fromJson(
          response.body['data'],
        );

        // Always clear first, then repopulate with this filter's results —
        // previously this only happened when the response had data, so a
        // tab with zero matching rides (e.g. "no ongoing rides right now")
        // kept showing whatever list was left over from the last tab that
        // was viewed. The "ongoing" slug additionally skipped clearing
        // entirely and just appended, compounding the same bug.
        bookingActivityList ??= [];
        bookingActivityList!.clear();
        if (model.data != null && model.data!.isNotEmpty) {
          bookingActivityList!.addAll(model.data!);
        }

        update();
      }
    } catch (e) {
      await EasyLoading.dismiss();
      print(e.toString());
    } finally {
      isPromoLoading = false;
      update();
    }
  }



  // Future<void> getActivityData({
  //   required String typeOfSlug,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     isPromoLoading = true;
  //     update();

  //     EasyLoading.show(status: "Please wait...");

  //     Response? response = await profileRepo.getBookingdata(
  //       typeSlug: typeOfSlug,
  //     );

  //     await EasyLoading.dismiss();

  //     if (response.statusCode == 200 &&
  //         response.body['code'].toString() == "200") {
  //       ActivityDataModel model = ActivityDataModel.fromJson(
  //         response.body['data'],
  //       );

  //       if (typeOfSlug == "ongoing") {
  //         bookingActivityList!.clear();

  //         if (model.data != null && model.data!.isNotEmpty) {
  //           bookingActivityList!.add(model.data!.first);
  //         }
  //       } else {
  //         bookingActivityList!.addAll(model.data ?? []);
  //       }

  //       update();
  //     }
  //   } catch (e) {
  //     await EasyLoading.dismiss();
  //   //// Get.snackbar("Error", e.toString());
  //   }

  //   isPromoLoading = false;
  //   update();
  // }

  Future<Response?> promodetailCategoryWise({
    required BuildContext context,
    String? id,
  }) async {
    isCategoryLoading = true;
    update();

    try {
     /// EasyLoading.show(status: "Please wait...");

      Response? response = await profileRepo.getpromoCategorylist();

      await EasyLoading.dismiss();

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['code'].toString() == "200") {
        promoCategoryModel = PromoCategoryModel.fromJson(response.body);

        promoCategoryList.clear();
        promoCategoryList.addAll(promoCategoryModel?.data ?? []);

        if (promoCategoryList.isNotEmpty) {
          selectedCategory = promoCategoryList.first.name ?? "";
        }
      } else {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(response.body?['message'], "Oops! Something went wrong. Please try again."),
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      }
    } catch (e) {
     AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
    } finally {
      isCategoryLoading = false;
      update();
    }

    return null;
  }

  ///getCustomerWallet

  Future<void> promoDetials({String? id, required context}) async {
    isPromoDetailsLoading = true;
    update();

    //EasyLoading.show(status: "Please wait...");

    try {
      Response? response = await profileRepo.promodetails(id: id.toString());

     //// await EasyLoading.dismiss();

      if (response.statusCode == 200 &&
          response.body['code'].toString() == "200") {
        promoDetailsModel = PromoDetailsModel.fromJson(response.body);
      } else {
      AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(response.body?['message'], "Oops! Something went wrong. Please try again."),
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      ///  Get.snackbar("Error", response.body['message']);
      }
    } catch (e) {
      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      // await EasyLoading.dismiss();
      // Get.snackbar("Error", e.toString());
    } finally {
      isPromoDetailsLoading = false;
      update();
    }
  }

  ///// ==================== Customer Wallet Amount  =================

  Future<void> customerWalletAmount() async {
    isCustomerWalletLoading = true;
    update();

   /// EasyLoading.show(status: "Please wait...");

    try {
      Response? response = await profileRepo.getCustomerWallet();

    ///  await EasyLoading.dismiss();

      if (response.statusCode == 200 &&
          response.body['code'].toString() == "200") {
        print(' testinggg     ${response.body['data']['balance'].toString()}');

        // walletbalance = response.body['data']['balance'].toString();
        // update();
        var data = response.body['data'];

        if (data != null && data['balance'] != null) {
          walletbalance = data['balance'].toString();
        } else {
          walletbalance = "0";
          print("Balance not found, set to 0");
        }

        print('Wallet Balance: $walletbalance');
        update();
      } else {
        walletbalance = "0";
      }
    } catch (e) {
      await EasyLoading.dismiss();
      walletbalance = "0";
      // Get.snackbar("Error", e.toString());
    } finally {
      isCustomerWalletLoading = false;
      update();
    }
  }

  Future<void> customerPromoAdd({String? promoid, required context}) async {
    isPromoDetailsLoading = true;
    update();

   /// EasyLoading.show(status: "Please wait...");

    try {
      Response? response = await profileRepo.promoAddCustomerSide(
        promoid: promoid.toString(),
      );

    ///  await EasyLoading.dismiss();

      if (response.statusCode == 200 &&
          response.body['code'].toString() == "200") {
            AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(response.body['message'], "OTP sent successfully."),
        backgroundColor: ColorResources.appColor,
        icon: Icons.check_circle_rounded,
      );
        // await EasyLoading.dismiss();
        // Get.snackbar(
        //   'Success',
        //   "${response.body['message']}  ${response.body['data']['otp']}",
        //   backgroundColor: ColorResources.blueeebutton,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.TOP,
        //   duration: const Duration(seconds: 5),
        // );
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      } else {
          AnimatedTopToast.show(
        context: context,
        message: _sanitizeBackendMessage(response.body['message'], "Verification successful."),
        backgroundColor: ColorResources.textdetailsColor,
        icon: Icons.check_circle_rounded,
      );
      //  Get.snackbar("Error", response.body['message']);
      }
    } catch (e) {
        AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
      // await EasyLoading.dismiss();
      // Get.snackbar("Error", e.toString());
    } finally {
      isPromoDetailsLoading = false;
      update();
    }
  }

  Future<void> createTopUpIntent({String? amount, required context}) async {
    isTopUpIntentLoading = true;
    update();

    try {
      final amountStr = amount?.trim() ?? '0';
      final amountValue = double.tryParse(amountStr) ?? 0.0;

      if (amountValue <= 0) {
        AnimatedTopToast.show(
          context: context,
          message: "Please enter a valid amount.",
          backgroundColor: ColorResources.textColorRed,
          icon: Icons.error_outline,
        );
        return;
      }

      // create-topup-intent only creates a Razorpay order server-side — it
      // does NOT credit the wallet. The order_id it returns has to be
      // handed to Razorpay checkout so the payment is tied to it; only
      // then does Razorpay's success response carry a verifiable
      // signature, which verify-topup checks before actually crediting
      // the wallet. (Confirmed against the live API: calling
      // create-topup-intent alone leaves the wallet balance unchanged —
      // that mismatch was why top-ups never showed up on screen.)
      final intentResponse = await profileRepo.topCreateAmount(
        amount: amountStr,
      );

      if (intentResponse.statusCode != 200 ||
          intentResponse.body is! Map ||
          intentResponse.body['code']?.toString() != "200" ||
          intentResponse.body['data']?['order_id'] == null) {
        AnimatedTopToast.show(
          context: context,
          message: "Couldn't start the top-up. Please try again.",
          backgroundColor: ColorResources.textColorRed,
          icon: Icons.error_outline,
        );
        return;
      }

      final orderId = intentResponse.body['data']['order_id'].toString();

      // Store for after Razorpay payment completes
      _pendingAmount = amountStr;
      _pendingOrderId = orderId;

      final options = {
        'key': 'rzp_test_T300vQB506EcW8',
        'order_id': orderId,
        'amount': (amountValue * 100).toInt(), // paise
        'name': 'MyRide',
        'description': 'Wallet Top Up',
        'prefill': {
          'contact': phoneController.text,
          'email': emailController.text,
        },
        'theme': {'color': '#3077D3'},
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint('RAZORPAY OPEN ERROR: $e');
      AnimatedTopToast.show(
        context: context,
        message: "Oops! Something went wrong. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
    } finally {
      isTopUpIntentLoading = false;
      update();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint(
      'RAZORPAY SUCCESS: paymentId=${response.paymentId}  orderId=${response.orderId}  signature=${response.signature}',
    );

    final orderId = response.orderId ?? _pendingOrderId;
    final paymentId = response.paymentId;
    final signature = response.signature;

    if (orderId == null || paymentId == null || signature == null) {
      AnimatedTopToast.show(
        context: Get.context!,
        message: "Payment received but couldn't be verified. Please contact support.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return;
    }

    verifyTopUp(
      orderId: orderId,
      paymentId: paymentId,
      signature: signature,
      amount: _pendingAmount ?? '0',
      idempotencyKey: paymentId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    AnimatedTopToast.show(
      context: Get.context!,
      message: "Payment failed. Please try again.",
      backgroundColor: ColorResources.textColorRed,
      icon: Icons.error_outline,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  Future<void> verifyTopUp({
    required String orderId,
    required String paymentId,
    required String signature,
    required String amount,
    required String idempotencyKey,
  }) async {
    isTopUpIntentLoading = true;
    update();

    try {
      Response? response = await profileRepo.verifyTopup(
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
        amount: amount,
        idempotencyKey: idempotencyKey,
      );

      if (response.statusCode == 200 &&
          response.body['code'].toString() == "200") {
        final data = response.body['data'];
        if (data?['balance'] != null) {
          walletbalance = data['balance'].toString();
        }
        update();
        // Re-fetch from customer-wallet-balance too, regardless of what
        // verify-topup's own response contained — this is the same call
        // every other screen uses to display the balance, so it's the
        // source of truth for what the user will actually see next.
        await customerWalletAmount();

        AnimatedTopToast.show(
          context: Get.context!,
          message: "Wallet credited successfully!",
          backgroundColor: ColorResources.appColor,
          icon: Icons.check_circle_rounded,
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAll(
          MainNavigation(),
          duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
          transition: Transition.rightToLeft,
        );
      } else {
        AnimatedTopToast.show(
          context: Get.context!,
          message: _sanitizeBackendMessage(
            response.body['message'],
            "Payment verification failed. Please contact support.",
          ),
          backgroundColor: ColorResources.textColorRed,
          icon: Icons.error_outline,
        );
      }
    } catch (e) {
      AnimatedTopToast.show(
        context: Get.context!,
        message: "Verification failed. Please try again.",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
    } finally {
      isTopUpIntentLoading = false;
      update();
    }
  }

  ////topCreateAmount
  void changeCategory(BuildContext context, String category) {
    selectedCategory = category;
    print('promo list data suchi |||  $selectedCategory');

    filteredList = promoList.where((e) => e.category == category).toList();
    print('promo list data suchi |||  $filteredList');

    update();
  }

  void changeCategorys(String category, BuildContext context) {
    selectedCategory = category;
    update();

    getPromoListByCategory(category: category, context: context);
  }

  Future<void> callNumber({String? phoneNumber}) async {
    final Uri url = Uri.parse("tel:$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
