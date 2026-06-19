

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
    label = _cleanAddressValue(json['label']);
    address = _cleanAddressValue(json['address']);
    lat = json['lat'];
    lng = json['lng'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  bool get isNoAddressPlaceholder =>
      _isNoAddressValue(label) || _isNoAddressValue(address);

  static String? _cleanAddressValue(dynamic value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty || _isNoAddressValue(text)) {
      return null;
    }
    return text;
  }

  static bool _isNoAddressValue(String? value) {
    final normalized = value
        ?.toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '');
    return normalized == 'noaddress' || normalized == 'noaddressfound';
  }
}
