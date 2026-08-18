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

/// The `fare_details` block on each rental estimate row. `base_price`,
/// `platform_fee`, `gst_percent` and `gst_amount` are carried straight back
/// into the create-booking body for a rental ride, so they are parsed as
/// numbers here — `platform_fee` arrives as a string ("30.00") and would
/// otherwise be posted as text.
class RentalFareDetails {
  num? basePrice;
  num? timeCharge;
  num? platformFee;
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
      basePrice: _toNum(json['base_price']),
      timeCharge: _toNum(json['time_charge']),
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
