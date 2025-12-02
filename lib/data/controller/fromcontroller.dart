import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vivashri/app/modules/profilefrom/aadhar_number.dart';
import 'package:vivashri/app/modules/profilefrom/aadhar_otp.dart';
import 'package:vivashri/app/modules/profilefrom/contact_details.dart';
import 'package:vivashri/app/modules/profilefrom/education_details.dart';
import 'package:vivashri/app/modules/profilefrom/family_details.dart';
import 'package:vivashri/app/modules/profilefrom/location_details.dart';
import 'package:vivashri/app/modules/profilefrom/more_details.dart';
import 'package:vivashri/app/modules/profilefrom/partner_basic_details.dart';
import 'package:vivashri/app/modules/profilefrom/partner_basic_details2.dart';
import 'package:vivashri/app/modules/profilefrom/partner_education.dart';
import 'package:vivashri/app/modules/profilefrom/partner_location.dart';
import 'package:vivashri/app/modules/profilefrom/partner_other.dart';
import 'package:vivashri/app/modules/profilefrom/partner_relition.dart';
import 'package:vivashri/app/modules/profilefrom/upload_image.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/data/controller/auth_controller.dart';

class StaperfromController extends GetxController implements GetxService {
  var isLoading = false.obs;

  Future<void> submitBasicProfile({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/basic-profile",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          print('Response:::::::${response.body}');

          EasyLoading.dismiss();

          Get.to(
            ContactDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-=-=-=-=-=-=-=-=-=-=-=-- Contect Details -==-=-=-=--=-=-=-=-=-=-=-=-=-=
  Future<void> conectdetailsProfile({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/contact-information",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            AadharVerificationScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-=-=--=-=-=-=-=-=--=- aadher number-=-=-=-=-=-=-=-=-=-=-=-=-
  Future<void> aadharnumberProfile({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/aadhaar-verification",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            AadharOtpScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //=-==-=-=-=--=--=-=-=-= religion details=-=-=-=-=-=-=-=-=--=-=
  Future<void> religiondeytalsProfile({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/religion",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            AadharOtpScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //=-==-=-=-==-=-=-= reference Datsil=-=-=-=-=-=-=-=-==--=-
  Future<void> referencedProfile({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/location-detail",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            LocationDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =-=-=-=-=-=-=-=-=-=-=-=-= family details -=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Future<void> familydeatilsProfile({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/family-detail",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            MoreDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-==-=-=-=-=-=-=-=-=-- MOre details -==-=-=-=-=-=-=-=-=-=-=--=-=
  Future<void> moredetailsapi({
    required Map<String, dynamic> formData,
    List<dynamic>? selected,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/basic-profile",
      );

      var body = jsonEncode({"formData": formData, "selected": selected ?? []});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            EducationDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //=-==-=-=-=-=-==-=-=-=- PARTNER qualities-=-=-=--==-=-=-=-
  Future<void> partnerqualites({
    required Map<String, dynamic> formData,
    List<dynamic>? selected,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/partner-qualities",
      );

      var body = jsonEncode({"formData": formData, "selected": selected ?? []});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            EducationDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //=-=-=-=-=-=-=-=-=-=-= partner basic detaiuls -=-=-=-=-=-=-=-=-=-=-
  Future<void> partnerbasicdetails({
    required Map<String, dynamic> formData,
    List<dynamic>? selected,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/partner-basic-detail",
      );

      var body = jsonEncode({"formData": formData, "selected": selected ?? []});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            PartnerFamilyDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> partnerqualities({
    required Map<String, dynamic> formData,
    List<dynamic>? selected,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/partner-qualities",
      );

      var body = jsonEncode({"formData": formData, "selected": selected ?? []});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            PartnerBasicDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> partnerfamilydetauls({
    required Map<String, dynamic> formData,
    List<dynamic>? selected,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/partner-basic-detail",
      );

      var body = jsonEncode({"formData": formData, "selected": selected ?? []});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            PartnerLocationDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-==-=-=-=-=-=-=-=-=-= partner location details

  Future<void> partnerlocationdetails({
    required Map<String, dynamic> formData,
    List<dynamic>? selected,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/partner-basic-detail",
      );

      var body = jsonEncode({"formData": formData, "selected": selected ?? []});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            PartnerEducationCareerScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //==-=--=-=-=-=----= partner eductuon career=-==-=-=-=-=-=

  Future<void> partnereductiondetauls({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/partner-basic-detail",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            PartnerReligionCasteScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-=-=-=-=-=-=-=---=-=-- partner educatiuon career=-=-=-=-=-=-=-=-==--=-
  Future<void> partnercasteedetauls({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/partner-basic-detail",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            PartnerOtherDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //=--=-=-=-=-=--=--=-=-=-=- paretner other details =-=-=-=-=-=-=-=-=-==-=
  Future<void> partnerotheredetauls({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/partner-basic-detail",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            PartnerOtherDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //-=-=-=-=-=-=-=-=-=-=-=-- location details -==-=-=-=-=-=-=-=-=-=-=-=
  Future<void> locationdeatilss({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/location-detail",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            FamilyDetailsScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //--=-=-=-=-=-=-==-=-- education details=-=-=-= -=-=-==-=-=--=-=
  Future<void> edcuationdetailss({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://testing.akslearning.in/vivashribackend/api/user/education-detail",
      );

      var body = jsonEncode({"formData": formData});

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();

          Get.to(
            UploadPhotoScreen(),
            duration: Duration(milliseconds: ApiConstants.screenTransitionTime),
            transition: Transition.rightToLeft,
          );
        } else {
          EasyLoading.dismiss();
          Get.snackbar(
            "Error",
            jsonResponse["message"] ?? "Something went wrong",
          );
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar(
          "Server Error",
          jsonResponse["message"] ?? "Something went wrong",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Exception: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
