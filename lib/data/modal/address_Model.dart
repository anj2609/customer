

class AddressModels {
  int? id;
  int? userId;
  String? label;
  String? address;
  String? lat;
  String? lng;
  int? isDefault;
  String? createdAt;
  String? updatedAt;

  AddressModels(
      {this.id,
      this.userId,
      this.label,
      this.address,
      this.lat,
      this.lng,
      this.isDefault,
      this.createdAt,
      this.updatedAt});

  AddressModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    label = json['label'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  
}
