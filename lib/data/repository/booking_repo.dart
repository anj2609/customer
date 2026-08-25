import 'dart:developer';

import 'package:myrideuser/config/utils/constants.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/utils/apis/api_client.dart';

class BookingRepo extends GetxService {
  final ApiClient apiClient;

  BookingRepo({required this.apiClient});

  /////==========  call estimateUrl api  ======================///////
  Future<Response> bookingestimateListUrl({
    dynamic pickup_lat,
    dynamic pickup_lng,
    dynamic drop_lat,
    dynamic drop_lng,
  }) async {
    log(' booking $pickup_lat');
    return apiClient.myridepostData(ApiConstants.estimateUrl, {
      "pickup_lat": pickup_lat,
      "pickup_lng": pickup_lng,
      "drop_lat": drop_lat,
      "drop_lng": drop_lng,
    });
  }

  /////==========  call home banner api  ======================///////
  Future<Response> getBannerApi() async {
    return apiClient.getData(ApiConstants.getBanner);
  }

  /////==========  call vehicle type list api  ======================///////
  Future<Response> vehicleTypeListApi() async {
    return apiClient.getData(ApiConstants.vehicalTypeList);
  }

  /////==========  call rental estimate api (vehicles + price for N hours)  ======================///////
  Future<Response> rentalEstimateApi({required int hours}) async {
    return apiClient.myridepostData(ApiConstants.rentalEstimate, {
      "hours": hours,
    });
  }

  /////==========  call create booking api for rentals  ======================///////
  Future<Response> createRentalBookingApi({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    required num estimatedPrice,
    required int vehicleTypeId,
    required String pickupAddress,
    required String dropAddress,
    required int packageId,
    required int finalHour,
    num? finalDistance,
    num? basePrice,
    num? platformFee,
    num? gstPercent,
    num? gstAmount,
  }) async {
    final Map<String, dynamic> body = {
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "drop_lat": dropLat,
      "drop_lng": dropLng,
      "estimated_price": estimatedPrice,
      "vehicle_type_id": vehicleTypeId,
      "pickup_address": pickupAddress,
      "drop_address": dropAddress,
      "is_schedule": 0,
      "schedule_date_time": "",
      "is_wallet": 0,
      "promo_code": "",
      "ride_type": "rental",
      "package_id": packageId,
      "final_hour": finalHour,
    };

    // Fare breakdown carried over from /rental/estimate — same omit-when-null
    // rule as createBookingApi: a missing value must not become a zero that
    // overwrites the backend's own pricing.
    if (finalDistance != null) body["final_distance"] = finalDistance;
    if (basePrice != null) body["base_price"] = basePrice;
    if (platformFee != null) body["platform_fee"] = platformFee;
    if (gstPercent != null) body["gst_percent"] = gstPercent;
    if (gstAmount != null) body["gst_amount"] = gstAmount;

    return apiClient.myridepostData(ApiConstants.createBooking, body);
  }

  /////==========  call outstation estimate api (vehicles + price for a trip)  ======================///////
  Future<Response> outstationEstimateApi({
    required String tripType,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    return apiClient.myridepostData(ApiConstants.outstationEstimate, {
      "trip_type": tripType,
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "drop_lat": dropLat,
      "drop_lng": dropLng,
    });
  }

  /////==========  call create booking api for outstation  ======================///////
  Future<Response> createOutstationBookingApi({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    required num estimatedPrice,
    required int vehicleTypeId,
    required String pickupAddress,
    required String dropAddress,
    required int isSchedule,
    required String scheduleDateTime,
    required int outstationPricingId,
    required String tripType,
    required num estimatedDistance,
    required num estimatedDuration,
    required num billableDistance,
    required int estimatedDays,
    required num driverAllowance,
    num? basePrice,
    num? platformFee,
    num? gstPercent,
    num? gstAmount,
  }) async {
    final Map<String, dynamic> body = {
      "pickup_lat": pickupLat,
      "pickup_lng": pickupLng,
      "drop_lat": dropLat,
      "drop_lng": dropLng,
      "estimated_price": estimatedPrice,
      "vehicle_type_id": vehicleTypeId,
      "pickup_address": pickupAddress,
      "drop_address": dropAddress,
      "is_schedule": isSchedule,
      "schedule_date_time": scheduleDateTime,
      "is_wallet": 0,
      "promo_code": "",
      "ride_type": "outstation",
      "outstation_pricing_id": outstationPricingId,
      "trip_type": tripType,
      "estimated_distance": estimatedDistance,
      "estimated_duration": estimatedDuration,
      "billable_distance": billableDistance,
      "estimated_days": estimatedDays,
      "driver_allowance": driverAllowance,
    };

    // Fare breakdown carried over from /outstation/estimate — same
    // omit-when-null rule as the city-ride and rental bookings.
    if (basePrice != null) body["base_price"] = basePrice;
    if (platformFee != null) body["platform_fee"] = platformFee;
    if (gstPercent != null) body["gst_percent"] = gstPercent;
    if (gstAmount != null) body["gst_amount"] = gstAmount;

    return apiClient.myridepostData(ApiConstants.createBooking, body);
  }

  /////==========  call create booking  api  ======================///////
  Future<Response> createBookingApi({
    required double pickup_lat,
    required double pickup_lng,
    required double drop_lat,
    required double drop_lng,
    required String estimated_price,
    required String vehicle_type_id,
    required String pickup_address,
    required String drop_address,
    required String is_schedule,
    required String schedule_date_time,
    num? estimated_distance,
    num? estimated_duration,
    num? base_price,
    num? platform_fee,
    num? gst_percent,
    num? gst_amount,
  }) async {
    log(' booking $pickup_lat');

    final Map<String, dynamic> body = {
      "pickup_lat": pickup_lat,
      "pickup_lng": pickup_lng,
      "drop_lat": drop_lat,
      "drop_lng": drop_lng,
      "estimated_price": estimated_price,
      "vehicle_type_id": vehicle_type_id,
      "pickup_address": pickup_address,
      "drop_address": drop_address,
      "status": "pending",
      "is_schedule": is_schedule,
      "schedule_date_time": schedule_date_time,
      "is_wallet": 0,
      "promo_code": "",
    };

    // Trip size, carried over from the same estimate. A city booking used to
    // send neither, while outstation sent both — so anything downstream
    // showing a normal ride's distance or duration (the driver app's ride
    // details, the receipt) had nothing to read and fell back to 0 or a
    // blank. The estimate has had both values all along.
    if (estimated_distance != null) {
      body["estimated_distance"] = estimated_distance;
    }
    if (estimated_duration != null) {
      body["estimated_duration"] = estimated_duration;
    }

    // Fare breakdown carried over from /estimate-ride-list. Only sent when the
    // estimate actually supplied it — an empty string here reads as 0 server
    // side, which would silently zero out the platform fee / GST on the
    // booking rather than letting the backend fall back to its own pricing.
    if (base_price != null) body["base_price"] = base_price;
    if (platform_fee != null) body["platform_fee"] = platform_fee;
    if (gst_percent != null) body["gst_percent"] = gst_percent;
    if (gst_amount != null) body["gst_amount"] = gst_amount;

    return apiClient.myridepostData(ApiConstants.createBooking, body);
  }

  /////==========  call track Ride api  ======================///////
  Future<Response> trackRideApi({required String bookingId}) async {
    log(' booking $bookingId');
    return apiClient.myridepostData(ApiConstants.trackRide, {
      "booking_id": bookingId,
    });
  }

  ////// =================== Trip Ride Dteails ==================

  Future<Response> tripDetailsRideApi({required String bookingId}) async {
    log(' booking $bookingId');
    return apiClient.myridepostData(ApiConstants.tripdetail, {
      "booking_id": bookingId,
    });
  }

  Future<Response> cancelationlist() async {
   // log(' booking $bookingId');
    return apiClient.getData(ApiConstants.cancellation);
  }



Future<Response> cancelRideApi({ required String bookingid, required String reseonId}) async {
    log(' resean idddd ||||||||||||||  $reseonId');
    return apiClient.myridepostData(ApiConstants.cancelRide, {
      
      "cancellation_type_id":reseonId,
      "booking_id": bookingid,
    });
  }


  /// CONFIRMED live: POST /rate-driver as multipart form-data (not JSON) —
  /// {booking_id, rating, review (optional)} — returns {code, message} with
  /// no data payload.
  ///
  /// Switched from myridepostData (JSON body) to the authenticated multipart
  /// helper so the wire format matches what's actually verified working
  /// against the backend, rather than relying on Laravel's usually-but-not-
  /// guaranteed leniency about accepting JSON on a form-data-documented
  /// endpoint. review is optional on the backend; only sent when non-empty
  /// so a driver rated with no comment doesn't post a stray empty field.
  Future<Response> rateDriver({
    required String bookingid,
    required String rateId,
    String review = '',
  }) async {
    log(' resean idddd ||||||||||||||  $rateId');
    return apiClient.postMultipartNewSelectProfile(
      ApiConstants.rateDriver,
      {
        "booking_id": bookingid,
        "rating": rateId,
        if (review.isNotEmpty) "review": review,
      },
      null,
    );
  }



  Future<Response> driverAvailbledata({ required double latitude, required double longitude}) async {
    log(' resean idddd ||||||||||||||  $latitude');
    return apiClient.myridepostData(ApiConstants.driverAvailbleList, {
      "latitude": latitude,
      "longitude": longitude,
    });
  }





  Future<Response> getPaymentStatus({required String bookingId}) async {
    return apiClient.getDataApi('${ApiConstants.paymentStatus}/$bookingId');
  }

  Future<Response> generateQrPayment({required String bookingId}) async {
    return apiClient.myridepostData(ApiConstants.generateQrPayment, {
      'booking_id': bookingId,
    });
  }

  Future<Response> completeRide({required String bookingId}) async {
    return apiClient.myridepostData(ApiConstants.completeRide, {
      'booking_id': bookingId,
    });
  }

  Future<Response> checkActiveBookingRepo() async {
    return apiClient.getData(ApiConstants.activeBookingCustomer);
  }
}
