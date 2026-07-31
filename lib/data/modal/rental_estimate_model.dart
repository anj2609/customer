class RentalEstimateModel {
  int? packageId;
  int? vehicleTypeId;
  String? vehicleName;
  String? vehicleImage;
  int? hours;
  String? pricePerHr;
  int? includedKm;
  RentalFareDetails? fareDetails;
  num? price;

  RentalEstimateModel({
    this.packageId,
    this.vehicleTypeId,
    this.vehicleName,
    this.vehicleImage,
    this.hours,
    this.pricePerHr,
    this.includedKm,
    this.fareDetails,
    this.price,
  });

  factory RentalEstimateModel.fromJson(Map<String, dynamic> json) {
    return RentalEstimateModel(
      packageId: json['package_id'],
      vehicleTypeId: json['vehicle_type_id'],
      vehicleName: json['vehicle_name'],
      vehicleImage: json['vehicle_image'],
      hours: json['hours'],
      pricePerHr: json['price_per_hr']?.toString(),
      includedKm: json['included_km'],
      fareDetails: json['fare_details'] != null
          ? RentalFareDetails.fromJson(json['fare_details'])
          : null,
      price: json['price'],
    );
  }
}

class RentalFareDetails {
  num? basePrice;
  num? timeCharge;
  String? platformFee;
  num? surgeMultiplier;
  num? gstPercent;
  num? gstAmount;

  RentalFareDetails({
    this.basePrice,
    this.timeCharge,
    this.platformFee,
    this.surgeMultiplier,
    this.gstPercent,
    this.gstAmount,
  });

  factory RentalFareDetails.fromJson(Map<String, dynamic> json) {
    return RentalFareDetails(
      basePrice: json['base_price'],
      timeCharge: json['time_charge'],
      platformFee: json['platform_fee']?.toString(),
      surgeMultiplier: json['surge_multiplier'],
      gstPercent: json['gst_percent'],
      gstAmount: json['gst_amount'],
    );
  }
}
