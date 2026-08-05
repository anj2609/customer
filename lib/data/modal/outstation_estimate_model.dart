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

class OutstationFareDetails {
  String? basePrice;
  String? baseDistanceKm;
  num? extraDistance;
  String? perKmCharge;
  num? driverAllowance;
  String? platformFee;
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
      basePrice: json['base_price']?.toString(),
      baseDistanceKm: json['base_distance_km']?.toString(),
      extraDistance: json['extra_distance'],
      perKmCharge: json['per_km_charge']?.toString(),
      driverAllowance: json['driver_allowance'],
      platformFee: json['platform_fee']?.toString(),
      surgeMultiplier: json['surge_multiplier'],
      gstPercent: json['gst_percent'],
      gstAmount: json['gst_amount'],
    );
  }
}
