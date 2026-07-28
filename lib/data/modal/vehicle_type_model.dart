class VehicleTypeModel {
  int? id;
  String? name;
  String? baseFare;
  String? perKmRate;
  String? image;
  String? status;
  String? remark;
  String? createdAt;
  String? updatedAt;

  VehicleTypeModel({
    this.id,
    this.name,
    this.baseFare,
    this.perKmRate,
    this.image,
    this.status,
    this.remark,
    this.createdAt,
    this.updatedAt,
  });

  VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    baseFare = json['base_fare']?.toString();
    perKmRate = json['per_km_rate']?.toString();
    image = json['image'];
    status = json['status'];
    remark = json['remark'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
