import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivashri/app/modules/Deshboard/buttom_navigation.dart';
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
import 'package:vivashri/app/modules/profilefrom/reference_details.dart';
import 'package:vivashri/app/modules/profilefrom/upload_image.dart';
import 'package:vivashri/config/utils/colors.dart';
import 'package:vivashri/config/utils/constants.dart';
import 'package:vivashri/config/utils/style.dart';
import 'package:vivashri/data/controller/auth_controller.dart';
import 'package:vivashri/data/controller/userprofile.dart';

class StaperfromController extends GetxController implements GetxService {
  var isLoading = false.obs;

  Future<void> submitBasicProfile({
    required Map<String, dynamic> formData,
    String? mobilenumber,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/basic-profile",
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
      print('bodyyyy${body}');
      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          print('Response:::::::${response.body}');

          EasyLoading.dismiss();

          Get.to(
            ContactDetailsScreen(mobileemail: mobilenumber),
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
        "https://vivashri.com/vivashribackend/api/user/contact-information",
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
        "https://vivashri.com/vivashribackend/api/user/aadhaar-verification",
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
    BuildContext? context,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/religion",
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
          showDialog(
            context: context!,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                insetPadding:
                    EdgeInsets.zero, // ❗ Remove unwanted left-right gap
                backgroundColor: Colors.transparent,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ), // ⭐ Controlled spacing
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image.asset(
                            "assets/images/Frame 79.png",
                            width: double.infinity,
                            height: 260,
                            fit: BoxFit.cover, // IMAGE PERFECT FULL WIDTH
                          ),
                        ),

                        SizedBox(height: 15),

                        Text(
                          "Thank you for Registration",
                          style: opensansBold.copyWith(
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Welcome To Vivashri",
                          style: opensansBold.copyWith(
                            color: ColorResources.primarycolor2,
                            fontSize: 25,
                          ),
                        ),

                        SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.offAll(
                                ReferenceDetailsScreen(),
                                duration: Duration(
                                  milliseconds:
                                      ApiConstants.screenTransitionTime,
                                ),
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFBE266B),
                                    Color(0xFFEB1D7B),
                                  ],
                                ),
                              ),
                              child: Text(
                                "Continue to Complete Profile",
                                style: opensansSemiBold.copyWith(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        GestureDetector(
                          onTap: () {
                            Get.offAll(
                              MainNavigation(),
                              duration: Duration(
                                milliseconds: ApiConstants.screenTransitionTime,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              "Skip",
                              style: opensansSemiBold.copyWith(
                                color: Colors.pink,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
        "https://vivashri.com/vivashribackend/api/user/location-detail",
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
        "https://vivashri.com/vivashribackend/api/user/family-detail",
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
        "https://vivashri.com/vivashribackend/api/user/basic-profile",
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
        "https://vivashri.com/vivashribackend/api/user/partner-qualities",
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
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
      );

      var body = jsonEncode({
        "formData": formData,
        "searchMarital_status": selected,
      });

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
        "https://vivashri.com/vivashribackend/api/user/partner-qualities",
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
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
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
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
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
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
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
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
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
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
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

          Get.offAll(
            MainNavigation(),
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
        "https://vivashri.com/vivashribackend/api/user/location-detail",
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
        "https://vivashri.com/vivashribackend/api/user/education-detail",
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

  //=-=-=-=-=-==-=-=--=--=-=-=-=-=--=-=-=-=-=- Edit From Pgae Api ==-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-==-=-=-==--=-=-
  //-=================-=-=-=-=-=-=--=-=------------------==========================-------------------------------
  Future<void> updatepartnerreligion({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
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
          EasyLoading.dismiss();
          Get.snackbar(
            "Success",
            "Update Successfully",
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
          profileapi();
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

  final usercontroller = Get.put(UserDetailController());

  Future<void> updatepartnerotherdetails({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
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
          EasyLoading.dismiss();
          Get.snackbar(
            "Success",
            "Update Successfully",
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );

          profileapi();
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

  void profileapi() async {
    final prefs = await SharedPreferences.getInstance();

    String? profileid = prefs.getString("profileid");
    usercontroller.fetchUserDetail(profileid.toString());
  }

  Future<void> updatepartnerbasicdetails({
    required Map<String, dynamic> formData,
    List<dynamic>? selected,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/partner-basic-detail",
      );

      var body = jsonEncode({
        "formData": formData,
        "searchMarital_status": selected,
      });

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
          Get.snackbar(
            "Success",
            "Update Successfully",
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
          profileapi();
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

  Future<void> updatehobbies({
    required Map<String, dynamic> formData,
    List<dynamic>? selected,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/basic-profile",
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
          Get.snackbar(
            "Success",
            "Update Successfully",
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
          profileapi();
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

  Future<void> updatelocationdeatilss({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/location-detail",
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

      print("Response: ${body}");

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse["status"] == true) {
          EasyLoading.dismiss();
          Get.snackbar(
            "Success",
            "Update Successfully",
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
          profileapi();
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

  Future<void> updateedcuationdetailss({
    required Map<String, dynamic> formData,
  }) async {
    String? token = Get.find<AuthController>().getAuthToken();

    EasyLoading.show();

    try {
      isLoading.value = true;

      var url = Uri.parse(
        "https://vivashri.com/vivashribackend/api/user/education-detail",
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
          Get.snackbar(
            "Success",
            "Update Successfully",
            colorText: Colors.white,
            backgroundColor: Colors.green,
          );
          profileapi();
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
