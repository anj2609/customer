
class VehicleModel {
  int? vehicleTypeId;
  String? name;
  String? estimatedTime;
  double? distanceKm;
  double? price;

  VehicleModel(
      {this.vehicleTypeId,
      this.name,
      this.estimatedTime,
      this.distanceKm,
      this.price});

  VehicleModel.fromJson(Map<String, dynamic> json) {
  vehicleTypeId = json['vehicle_type_id'];
  name = json['name'];
  estimatedTime = json['estimated_time'];
  distanceKm = (json['distance_km'] as num?)?.toDouble();
  price = (json['price'] as num?)?.toDouble();
}

  
}