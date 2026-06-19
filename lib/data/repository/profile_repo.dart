import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/utils/apis/api_client.dart';

class ProfiileRepo extends GetxService {
  final ApiClient apiClient;

  ProfiileRepo({required this.apiClient});
  Future<Response> profileRepoApi() async {
    return apiClient.getDataApi(ApiConstants.getUserProfileUrl);
  }

  Future<Response> upatePersonalApi({
    String? name,
    String? email,
    String? gender,
    String? dob,
    String? phonenumber,
    File? profile_image,
    String? old_profile_image,
  }) async {
    debugPrint(
      'updateeeeee ${name} ${email} ${gender}, ${dob}, ${phonenumber}, ${profile_image} , ${old_profile_image}',
    );
    if (profile_image != null) {
      debugPrint(
        'updateeeeee profile ${name} ${email} ${gender}, ${dob}, ${phonenumber}, ${profile_image} , ${old_profile_image}',
      );

      return apiClient
          .postMultipartNewSelectProfile(ApiConstants.editProfileUrl, {
            "name": name ?? "",
            "email": email ?? "",
            "gender": gender ?? "",
            "date_of_birth": dob ?? "",
            "phone": phonenumber ?? "",
          }, profile_image);
    } else {
      debugPrint('updateeeeee 1');
      return apiClient.postMultipartUpdate(ApiConstants.editProfileUrl, {
        "name": name ?? "",
        "email": email ?? "",
        "gender": gender ?? "",
        "date_of_birth": dob ?? "",
        "phone": phonenumber ?? "",
      }, profile_image ?? old_profile_image);
    }
  }

  Future<Response> customerAddAddressapi({
    required String label,
    required String address,
    required double lat,
    required double lng,
  }) async {
    return apiClient.myridepostData(ApiConstants.customeraddAddress, {
      "label": label,
      "address": address,
      "lat": lat,
      "lng": lng,
    });
  }

  Future<Response> getcustomeraddress() async {
    return apiClient.getDataApi(ApiConstants.customeraddAddressListApi);
  }

  Future<Response> customerUpdateAddress({
    required String label,
    required String address,
    required double lat,
    required double lng,
    required dynamic id,
  }) async {
    return apiClient.myridepostData(ApiConstants.customeraddAddressUpdate, {
      "label": label,
      "address": address,
      "lat": lat,
      "lng": lng,
      "address_id": id,
    });
  }

  Future<Response> customerDeleteapi({required dynamic id}) async {
    return apiClient.myridepostData(ApiConstants.customeraddAddresdelete, {
      "address_id": id,
    });
  }

  Future<Response> customerConnectSocial({
    required String provider,
    required String access,
  }) async {
    return apiClient.myridepostData(ApiConstants.customerconnectsocial, {
      "provider": provider,
      "access_token": access,
    });
  }

  Future<Response> customernoticationUpdate({
    required String type,
    required String status,
  }) async {
    return apiClient.myridepostData(ApiConstants.customernotificationupdate, {
      "type": type,
      "status": status,
    });
  }

  Future<Response> customerdisconnectSocial({required String provider}) async {
    return apiClient.myridepostData(ApiConstants.customerdisconnectsocial, {
      "provider": provider,
    });
  }

  Future<Response> customerfqlapi({required type}) async {
    return apiClient.getApi('${ApiConstants.customerfqlurl}${type}');
  }

  Future<Response> customernoticationssetting() async {
    return apiClient.getDataApi(ApiConstants.customernotificationsettings);
  }

  ///customernotificationsettings

  Future<Response> customerpromocard({required cattype}) async {
    return apiClient.getApi('${ApiConstants.promoslist} ${cattype}');
  }

  Future<Response> getprivacypolicy({required slug}) async {
    return apiClient.getApi('${ApiConstants.cmsdetails}${slug}');
  }

  Future<Response> getaboutUs({required slug}) async {
    return apiClient.getApi('${ApiConstants.cmsdetails}${slug}');
  }

  Future<Response> gettermandConditions({required slug}) async {
    return apiClient.getApi('${ApiConstants.cmsdetails}${slug}');
  }

  Future<Response> getsettingDetail() async {
    return apiClient.getApi(ApiConstants.settingDetail);
  }

  Future<Response> getpromoCategorylist() async {
    return apiClient.getApi(ApiConstants.promoscategorylist);
  }

  Future<Response> promoCategorywisedata({required String category}) async {
    return apiClient.myridepostData(ApiConstants.promoslisturl, {
      "category": category,
    });
  }

  Future<Response> promodetails({required String id}) async {
    return apiClient.myridepostData(ApiConstants.promosDetail, {
      "id": id.toString(),
    });
  }

  Future<Response> promoAddCustomerSide({required String promoid}) async {
    return apiClient.myridepostData(ApiConstants.customeraddpromo, {
      "promo_id": promoid.toString(),
    });
  }

  Future<Response> getBookingdata({required String typeSlug}) async {
    return apiClient.getData(
      '${ApiConstants.customerbookingliststatus}${typeSlug}',
    );
  }

  Future<Response> getCustomerWallet() async {
    return apiClient.getDataApi('${ApiConstants.customerWallet}');
  }

  Future<Response> topCreateAmount({required String amount}) async {
    return apiClient.myridepostData(ApiConstants.topCreateAmount, {
      "amount": amount.toString(),
    });
  }

  Future<Response> verifyTopup({
    required String orderId,
    required String paymentId,
    required String signature,
    required String amount,
    required String idempotencyKey,
  }) async {
    return apiClient.myridepostData(ApiConstants.verifyTopup, {
      "razorpay_order_id": orderId,
      "razorpay_payment_id": paymentId,
      "razorpay_signature": signature,
      "amount": amount,
      "idempotency_key": idempotencyKey,
    });
  }

  ///topCreateAmount
  /////// customerWallet
}
