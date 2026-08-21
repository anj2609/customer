/// Typed shape for GET /trip-detail. Rebuilt against a real, live-captured
/// response for a completed booking (not just the original example spec),
/// which turned out to differ in two real ways:
///   - the booking number field is "booking_number", not "booking_no"
///     (the old field name silently always parsed as null)
///   - there is no "price_breakdown" object on a normal-ride-type booking
///     at all — only a much lighter "payment" object with
///     {promo_discount, wallet_used, total_fare, final_amount}. The richer
///     breakdown (base_fare, platform_fee, CGST, SGST, distance/time
///     charges) from the original spec was never actually observed live;
///     it's kept here and still parsed in case it does appear for other
///     ride types (rental/outstation) or under other conditions — nothing
///     found so far rules that out, it just isn't confirmed.
///
/// Used wherever a real booking's trip/price detail needs to be shown:
/// Finding Driver screen, the post-ride Completed Ride Sheet, and the
/// Activity ride-detail screen.
class TripDetailModel {
  final String? code;
  final String? message;
  final TripDetailData? data;

  TripDetailModel({this.code, this.message, this.data});

  factory TripDetailModel.fromJson(Map<String, dynamic> json) {
    return TripDetailModel(
      code: json['code']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] != null
          ? TripDetailData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TripDetailData {
  final int? bookingId;
  final String? bookingNumber;
  final String? rideType;
  final String? status;
  final String? pickupOtp;
  final TripLocation? pickup;
  final TripLocation? drop;
  final TripVehicle? vehicle;
  final TripDriver? driver;
  final TripRideStats? rideStats;
  final String? createdAt;

  /// Confirmed present, at least for a completed "normal" ride.
  final TripPayment? payment;

  /// Unconfirmed whether this ever appears live — see file-level note.
  final PriceBreakdown? priceBreakdown;

  TripDetailData({
    this.bookingId,
    this.bookingNumber,
    this.rideType,
    this.status,
    this.pickupOtp,
    this.pickup,
    this.drop,
    this.vehicle,
    this.driver,
    this.rideStats,
    this.createdAt,
    this.payment,
    this.priceBreakdown,
  });

  factory TripDetailData.fromJson(Map<String, dynamic> json) {
    final rideDetails = json['ride_details'];
    final tripStats = rideDetails is Map ? rideDetails['trip'] : null;

    return TripDetailData(
      bookingId: json['booking_id'] is int
          ? json['booking_id'] as int
          : int.tryParse(json['booking_id']?.toString() ?? ''),
      bookingNumber: json['booking_number']?.toString(),
      rideType: json['ride_type']?.toString(),
      status: json['status']?.toString(),
      pickupOtp: json['pickup_otp']?.toString(),
      pickup: json['pickup'] != null
          ? TripLocation.fromJson(json['pickup'] as Map<String, dynamic>)
          : null,
      drop: json['drop'] != null
          ? TripLocation.fromJson(json['drop'] as Map<String, dynamic>)
          : null,
      vehicle: json['vehicle'] != null
          ? TripVehicle.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
      driver: json['driver'] != null
          ? TripDriver.fromJson(json['driver'] as Map<String, dynamic>)
          : null,
      rideStats: tripStats is Map
          ? TripRideStats.fromJson(tripStats as Map<String, dynamic>)
          : null,
      createdAt: json['created_at']?.toString(),
      payment: json['payment'] != null
          ? TripPayment.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
      priceBreakdown: json['price_breakdown'] != null
          ? PriceBreakdown.fromJson(
              json['price_breakdown'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Returns a copy carrying [breakdown], for the common case where
  /// trip-detail itself returned no "price_breakdown" but the real
  /// component figures are known from create-booking's `fare_details` (see
  /// [PriceBreakdown.fromCreateBooking]). Everything else is passed through
  /// untouched — trip-detail stays the source of truth for the ride itself,
  /// this only fills in the fare components it didn't send.
  TripDetailData copyWithPriceBreakdown(PriceBreakdown breakdown) {
    return TripDetailData(
      bookingId: bookingId,
      bookingNumber: bookingNumber,
      rideType: rideType,
      status: status,
      pickupOtp: pickupOtp,
      pickup: pickup,
      drop: drop,
      vehicle: vehicle,
      driver: driver,
      rideStats: rideStats,
      createdAt: createdAt,
      payment: payment,
      priceBreakdown: breakdown,
    );
  }
}

class TripLocation {
  final String? address;
  final double? lat;
  final double? lng;

  TripLocation({this.address, this.lat, this.lng});

  factory TripLocation.fromJson(Map<String, dynamic> json) {
    return TripLocation(
      address: json['address']?.toString(),
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
    );
  }
}

class TripVehicle {
  final int? id;
  final String? name;
  final String? image;

  TripVehicle({this.id, this.name, this.image});

  factory TripVehicle.fromJson(Map<String, dynamic> json) {
    return TripVehicle(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      image: json['image']?.toString(),
    );
  }
}

class TripDriver {
  final int? id;
  final String? name;
  final String? phone;
  final String? image;

  TripDriver({this.id, this.name, this.phone, this.image});

  factory TripDriver.fromJson(Map<String, dynamic> json) {
    return TripDriver(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      image: json['image']?.toString(),
    );
  }
}

class TripRideStats {
  final double? distance;
  final int? duration;

  TripRideStats({this.distance, this.duration});

  factory TripRideStats.fromJson(Map<String, dynamic> json) {
    return TripRideStats(
      distance: _toDouble(json['distance']),
      duration: json['duration'] is int
          ? json['duration'] as int
          : int.tryParse(json['duration']?.toString() ?? ''),
    );
  }
}

/// The real, confirmed-live shape of trip-detail's payment info — much
/// lighter than the original PriceBreakdown spec below.
class TripPayment {
  final double promoDiscount;
  final double walletUsed;
  final double totalFare;
  final double finalAmount;

  TripPayment({
    this.promoDiscount = 0,
    this.walletUsed = 0,
    this.totalFare = 0,
    this.finalAmount = 0,
  });

  factory TripPayment.fromJson(Map<String, dynamic> json) {
    return TripPayment(
      promoDiscount: _toDouble(json['promo_discount']),
      walletUsed: _toDouble(json['wallet_used']),
      totalFare: _toDouble(json['total_fare']),
      finalAmount: _toDouble(json['final_amount']),
    );
  }
}

/// Kept for forward-compatibility (see file-level note) — parsed if the
/// backend ever includes a "price_breakdown" object, but not confirmed to
/// appear on any live booking tested so far.
class PriceBreakdown {
  final double baseFare;
  final double distanceCharge;
  final double timeCharge;
  final double waitingCharge;
  final double waitingAmount;
  final double extraDistanceCharge;
  final double extraDurationCharge;
  final double driverAllowance;
  final double platformFee;
  final double bookingFeePerTrip;
  final double surgeMultiplier;
  final double gstPercent;
  final double gstAmount;
  final double cgstPercent;
  final double cgstAmount;
  final double sgstPercent;
  final double sgstAmount;
  final double promoDiscount;
  final double walletUsed;
  final double totalFare;
  final double finalAmount;

  PriceBreakdown({
    this.baseFare = 0,
    this.distanceCharge = 0,
    this.timeCharge = 0,
    this.waitingCharge = 0,
    this.waitingAmount = 0,
    this.extraDistanceCharge = 0,
    this.extraDurationCharge = 0,
    this.driverAllowance = 0,
    this.platformFee = 0,
    this.bookingFeePerTrip = 0,
    this.surgeMultiplier = 0,
    this.gstPercent = 0,
    this.gstAmount = 0,
    this.cgstPercent = 0,
    this.cgstAmount = 0,
    this.sgstPercent = 0,
    this.sgstAmount = 0,
    this.promoDiscount = 0,
    this.walletUsed = 0,
    this.totalFare = 0,
    this.finalAmount = 0,
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) {
    return PriceBreakdown(
      baseFare: _toDouble(json['base_fare']),
      distanceCharge: _toDouble(json['distance_charge']),
      timeCharge: _toDouble(json['time_charge']),
      waitingCharge: _toDouble(json['waiting_charge']),
      waitingAmount: _toDouble(json['waiting_amount']),
      extraDistanceCharge: _toDouble(json['extra_distance_charge']),
      extraDurationCharge: _toDouble(json['extra_duration_charge']),
      driverAllowance: _toDouble(json['driver_allowance']),
      platformFee: _toDouble(json['platform_fee']),
      bookingFeePerTrip: _toDouble(json['booking_fee_per_trip']),
      surgeMultiplier: _toDouble(json['surge_multiplier']),
      gstPercent: _toDouble(json['gst_percent']),
      gstAmount: _toDouble(json['gst_amount']),
      cgstPercent: _toDouble(json['cgst_percent']),
      cgstAmount: _toDouble(json['cgst_amount']),
      sgstPercent: _toDouble(json['sgst_percent']),
      sgstAmount: _toDouble(json['sgst_amount']),
      promoDiscount: _toDouble(json['promo_discount']),
      walletUsed: _toDouble(json['wallet_used']),
      totalFare: _toDouble(json['total_fare']),
      finalAmount: _toDouble(json['final_amount']),
    );
  }

  /// Builds the breakdown from **create-booking**'s response `data`, which
  /// is where the real component figures actually come from — CONFIRMED
  /// against a live response:
  ///
  ///     "data": {
  ///       "booking_id": 259, "final_amount": 592, "total_fare": 592,
  ///       "promo_discount": 0, "wallet_used": 0,
  ///       "fare_details": {
  ///         "base_fare": 500, "time_charge": 7, "taxable_amount": 507,
  ///         "gst_percent": 5, "gst_amount": 25.35,
  ///         "cgst_percent": 2.5, "cgst_amount": 12.68,
  ///         "sgst_percent": 2.5, "sgst_amount": 12.68,
  ///         "platform_fee": 30, "booking_fee": 30, "total_fare": 592
  ///       }
  ///     }
  ///
  /// Three things differ from [PriceBreakdown.fromJson]'s "price_breakdown"
  /// shape, which is why this can't just reuse it:
  ///   - the components live under `fare_details`, not `price_breakdown`;
  ///   - the booking fee is `booking_fee`, not `booking_fee_per_trip`, so
  ///     the existing key reads null here and that row would print ₹0.00;
  ///   - `final_amount`, `promo_discount` and `wallet_used` sit on the
  ///     parent `data` object rather than inside the fare block.
  factory PriceBreakdown.fromCreateBooking(Map<String, dynamic> data) {
    final fare = data['fare_details'] is Map
        ? Map<String, dynamic>.from(data['fare_details'] as Map)
        : const <String, dynamic>{};

    return PriceBreakdown(
      baseFare: _toDouble(fare['base_fare']),
      distanceCharge: _toDouble(fare['distance_charge']),
      timeCharge: _toDouble(fare['time_charge']),
      platformFee: _toDouble(fare['platform_fee']),
      bookingFeePerTrip: _toDouble(fare['booking_fee']),
      surgeMultiplier: _toDouble(fare['surge_multiplier']),
      gstPercent: _toDouble(fare['gst_percent']),
      gstAmount: _toDouble(fare['gst_amount']),
      cgstPercent: _toDouble(fare['cgst_percent']),
      cgstAmount: _toDouble(fare['cgst_amount']),
      sgstPercent: _toDouble(fare['sgst_percent']),
      sgstAmount: _toDouble(fare['sgst_amount']),
      // Deductions and the payable figure are the booking's, not the fare
      // block's — fare_details.total_fare is the pre-deduction sum.
      promoDiscount: _toDouble(data['promo_discount']),
      walletUsed: _toDouble(data['wallet_used']),
      totalFare: _toDouble(fare['total_fare'] ?? data['total_fare']),
      finalAmount: _toDouble(data['final_amount']),
    );
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
