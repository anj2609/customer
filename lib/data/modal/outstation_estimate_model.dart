class OutstationEstimateModel {
  int? outstationPricingId;
  int? vehicleTypeId;
  String? vehicleName;
  String? vehicleImage;
  String? tripType;
  num? distance;
  num? duration;
  num? billableDistance;
  OutstationFareDetails? fareDetails;
  num? price;

  OutstationEstimateModel({
    this.outstationPricingId,
    this.vehicleTypeId,
    this.vehicleName,
    this.vehicleImage,
    this.tripType,
    this.distance,
    this.duration,
    this.billableDistance,
    this.fareDetails,
    this.price,
  });

  factory OutstationEstimateModel.fromJson(Map<String, dynamic> json) {
    return OutstationEstimateModel(
      outstationPricingId: json['outstation_pricing_id'],
      vehicleTypeId: json['vehicle_type_id'],
      vehicleName: json['vehicle_name'],
      vehicleImage: json['vehicle_image'],
      tripType: json['trip_type'],
      distance: json['distance'],
      duration: json['duration'],
      billableDistance: json['billable_distance'],
      fareDetails: json['fare_details'] != null
          ? OutstationFareDetails.fromJson(json['fare_details'])
          : null,
      price: json['price'],
    );
  }
}

/// The `fare_details` block on each outstation estimate row. `base_price`,
/// `platform_fee`, `gst_percent` and `gst_amount` go straight back into the
/// create-booking body for an outstation ride, so they are parsed as numbers
/// — `base_price` ("2449.00") and `platform_fee` ("20.00") arrive as strings
/// and would otherwise be posted as text.
class OutstationFareDetails {
  num? basePrice;
  num? baseDistanceKm;
  num? extraDistance;
  num? perKmCharge;
  num? driverAllowance;
  num? platformFee;
  num? surgeMultiplier;
  num? gstPercent;
  num? gstAmount;

  OutstationFareDetails({
    this.basePrice,
    this.baseDistanceKm,
    this.extraDistance,
    this.perKmCharge,
    this.driverAllowance,
    this.platformFee,
    this.surgeMultiplier,
    this.gstPercent,
    this.gstAmount,
  });

  factory OutstationFareDetails.fromJson(Map<String, dynamic> json) {
    return OutstationFareDetails(
      basePrice: _toNum(json['base_price']),
      baseDistanceKm: _toNum(json['base_distance_km']),
      extraDistance: _toNum(json['extra_distance']),
      perKmCharge: _toNum(json['per_km_charge']),
      driverAllowance: _toNum(json['driver_allowance']),
      platformFee: _toNum(json['platform_fee']),
      surgeMultiplier: _toNum(json['surge_multiplier']),
      gstPercent: _toNum(json['gst_percent']),
      gstAmount: _toNum(json['gst_amount']),
    );
  }
}

/// Fee fields come back as a mix of numbers and numeric strings within the
/// same object, so normalise before anything reads them as num.
num? _toNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString());
}
