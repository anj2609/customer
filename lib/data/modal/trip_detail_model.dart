import 'dart:math' as math;

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

  /// The one figure every "Total Fare" display for this booking is meant
  /// to show — single accessor so it can never again drift the way it did
  /// between trip_completed_screen.dart's top figure and this same
  /// object's own breakdown card: that screen read payment.finalAmount
  /// first, falling back to priceBreakdown.finalAmount, while
  /// PriceBreakdownCard's closing "Total Fare" row does the opposite —
  /// showing breakdown.finalAmount whenever a breakdown is present at all,
  /// only falling back to payment when it's genuinely absent. On a
  /// booking where both objects are populated but happen to disagree, the
  /// two screens showed two different numbers for what's supposed to be
  /// the same figure. This matches PriceBreakdownCard's precedence (the
  /// fuller itemised breakdown wins when present — it's the one confirmed
  /// live to include tax/fee components payment's lighter shape doesn't
  /// carry at all) rather than the other way around, since that's the
  /// shape actually shown as the primary receipt whenever it exists.
  double? get displayFare =>
      priceBreakdown?.finalAmount ??
      payment?.finalAmount ??
      priceBreakdown?.totalFare ??
      payment?.totalFare;

  factory TripDetailData.fromJson(Map<String, dynamic> json) {
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
      rideStats: TripRideStats.fromJson(_rideStatsSource(json)),
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

  /// Confirmed live via a captured real /trip-detail response: the actual
  /// keys are `final_distance` (km — see its sibling `distance_unit`) and
  /// `final_duration` (minutes — `duration_unit`), present identically in
  /// both `data.trip_summary` and `data.ride_details.trip`. Every previous
  /// pass at this got the *location* right at some point (nested
  /// ride_details.trip, then trip_summary) but not the key names — kept
  /// guessing `distance`/`duration` or `distance_km`/`estimated_time`,
  /// neither of which this response actually uses. `trip_summary` is
  /// tried first since it's the smaller, purpose-built object; the rest
  /// stay as fallbacks in case some ride types shape this differently.
  /// Whichever candidate map actually carries one of the recognised keys
  /// wins; if none do, both fields simply come back null rather than the
  /// parse guessing further.
  static Map<String, dynamic> _rideStatsSource(Map<String, dynamic> json) {
    final tripSummary = json['trip_summary'];
    final rideDetails = json['ride_details'];
    final nestedTrip = rideDetails is Map ? rideDetails['trip'] : null;
    bool hasStats(dynamic m) {
      if (m is! Map) return false;
      return m['final_distance'] != null ||
          m['final_duration'] != null ||
          m['distance_km'] != null ||
          m['estimated_time'] != null ||
          m['distance'] != null ||
          m['duration'] != null;
    }

    for (final candidate in [tripSummary, nestedTrip, json, rideDetails]) {
      if (hasStats(candidate)) {
        return Map<String, dynamic>.from(candidate as Map);
      }
    }
    return const {};
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
  /// In kilometres. `final_distance` is the confirmed-live key (see
  /// _rideStatsSource) — `distance`/`distance_km` kept only as fallbacks.
  final double? distance;

  /// In minutes. `final_duration` is the confirmed-live key — see above.
  final int? duration;

  TripRideStats({this.distance, this.duration});

  factory TripRideStats.fromJson(Map<String, dynamic> json) {
    final distanceRaw =
        json['final_distance'] ?? json['distance'] ?? json['distance_km'];
    final durationRaw =
        json['final_duration'] ?? json['duration'] ?? json['estimated_time'];
    return TripRideStats(
      distance: _toDouble(distanceRaw),
      duration: durationRaw is int
          ? durationRaw
          : int.tryParse(durationRaw?.toString() ?? ''),
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

/// "18 min" under an hour, "1h 20m" at or above one. Shared by every screen
/// that shows a completed ride's duration — the post-ride rating screen and
/// the "You have arrived!" sheet shown right when the ride ends — so the
/// same [TripRideStats.duration] always reads identically in both places.
String formatTripDuration(int? minutes) {
  if (minutes == null || minutes <= 0) return "-";
  if (minutes < 60) return "$minutes min";
  return "${minutes ~/ 60}h ${minutes % 60}m";
}

/// "4.2 km" — shared the same way as [formatTripDuration].
String formatTripDistance(double? km) {
  if (km == null || km <= 0) return "-";
  return "${km.toStringAsFixed(1)} km";
}

/// Great-circle (Haversine) distance between two coordinates, in
/// kilometres. Used on the rating screen instead of trip-detail's own
/// `final_distance` — a live-captured response returned 2429.43 km for a
/// booking whose pickup and drop were both within India, well outside any
/// plausible road distance for that pair of points, so the backend figure
/// can't be trusted as-is. Pickup/drop coordinates are the one part of a
/// completed booking that can't be wrong in the same way: they're exactly
/// what was booked, straight from `data.pickup`/`data.drop`.
///
/// This is straight-line, not road distance — always somewhat shorter than
/// the real driven route — but a consistent, sane underestimate beats an
/// occasionally-wild backend number.
double? haversineDistanceKm(double? lat1, double? lng1, double? lat2, double? lng2) {
  if (lat1 == null || lng1 == null || lat2 == null || lng2 == null) return null;
  const earthRadiusKm = 6371.0;
  double toRad(double deg) => deg * (math.pi / 180);

  final dLat = toRad(lat2 - lat1);
  final dLng = toRad(lng2 - lng1);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(toRad(lat1)) *
          math.cos(toRad(lat2)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadiusKm * c;
}
