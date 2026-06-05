class PromoModel {
  String? code;
  String? message;
  List<PromoData>? data;

  PromoModel({this.code, this.message, this.data});

  PromoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PromoData>[];
      json['data'].forEach((v) {
        data!.add(PromoData.fromJson(v));
      });
    }
  }
}

class PromoData {
  int? id;
  String? category;
  String? name;
  String? title;
  String? priceOff;
  String? code;

  PromoData({
    this.id,
    this.category,
    this.name,
    this.title,
    this.priceOff,
    this.code,
  });

  PromoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    name = json['name'];
    title = json['title'];
    priceOff = json['price_off'];
    code = json['code'];
  }
}