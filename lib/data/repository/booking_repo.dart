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
  }) async {
    return apiClient.myridepostData(ApiConstants.createBooking, {
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
    });
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
  }) async {
    return apiClient.myridepostData(ApiConstants.createBooking, {
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
    });
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
  }) async {
    log(' booking $pickup_lat');
    return apiClient.myridepostData(ApiConstants.createBooking, {
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
    });
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


  Future<Response> rateDriver({ required String bookingid, required String rateId}) async {
    log(' resean idddd ||||||||||||||  $rateId');
    return apiClient.myridepostData(ApiConstants.rateDriver, {
      "booking_id": bookingid,
      "rating": rateId,
    });
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
