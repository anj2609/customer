
class VehicleModel {
  int? vehicleTypeId;
  String? name;
  String? estimatedTime;
  double? distanceKm;
  double? price;

  // Fare breakdown returned under each row's `fare_details` by
  // /estimate-ride-list. create-booking expects these back in its own body, so
  // they are kept per-vehicle here and read again at booking time rather than
  // being recomputed on the client.
  //
  // Note the name change across the two endpoints: what the estimate calls
  // `base_fare` is what create-booking calls `base_price` — the flag-down
  // component only, not the quoted total. The distance/time charges and the
  // surge multiplier are deliberately not carried over; the backend applies
  // those itself.
  num? basePrice;
  num? platformFee;
  num? gstPercent;
  num? gstAmount;

  VehicleModel(
      {this.vehicleTypeId,
      this.name,
      this.estimatedTime,
      this.distanceKm,
      this.price,
      this.basePrice,
      this.platformFee,
      this.gstPercent,
      this.gstAmount});

  VehicleModel.fromJson(Map<String, dynamic> json) {
  vehicleTypeId = json['vehicle_type_id'];
  name = json['name'];
  estimatedTime = json['estimated_time'];
  distanceKm = (json['distance_km'] as num?)?.toDouble();
  price = (json['price'] as num?)?.toDouble();

  final fare = json['fare_details'] is Map
      ? Map<String, dynamic>.from(json['fare_details'])
      : json;

  basePrice = _toNum(fare['base_fare'] ?? fare['base_price']);
  platformFee = _toNum(fare['platform_fee']);
  gstPercent = _toNum(fare['gst_percent']);
  gstAmount = _toNum(fare['gst_amount']);
}

  /// [estimatedTime] reduced to a plain number of minutes, for
  /// create-booking's `estimated_duration`. The estimate sends it formatted
  /// ("2804 mins"), which no numeric field can accept as-is.
  ///
  /// Returns null rather than a guess for anything not expressed purely in
  /// minutes — an hours-and-minutes form ("1 hour 20 mins") would otherwise
  /// parse to its leading number and book a 80-minute ride as 1 minute.
  /// A null simply omits the field and lets the backend derive it.
  num? get estimatedMinutes {
    final raw = estimatedTime?.trim().toLowerCase();
    if (raw == null || raw.isEmpty) return null;

    // "h" catches hour/hr/hrs — none of which this can safely reduce.
    if (raw.contains('h')) return null;

    final match = RegExp(r'^(\d+(?:\.\d+)?)\s*(min|$)').firstMatch(raw);
    return match == null ? null : num.tryParse(match.group(1)!);
  }

  /// The API mixes types within the same object — `base_fare` and
  /// `platform_fee` arrive as strings ("500", "30.00") while `gst_amount` and
  /// `gst_percent` arrive as numbers — so parse both rather than letting a
  /// String land in a num? field.
  static num? _toNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }
}
