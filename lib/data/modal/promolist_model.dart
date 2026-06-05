class PromoListModel {
  String? code;
  String? message;
  List<PromoolistDataModel>? data;

  PromoListModel({this.code, this.message, this.data});

  PromoListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PromoolistDataModel>[];
      json['data'].forEach((v) {
        data!.add(new PromoolistDataModel.fromJson(v));
      });
    }
  }
}

class PromoolistDataModel {
  int? id;
  String? category;
  String? name;
  String? title;
  String? priceOff;
  String? code;

  PromoolistDataModel({
    this.id,
    this.category,
    this.name,
    this.title,
    this.priceOff,
    this.code,
  });

  PromoolistDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    name = json['name'];
    title = json['title'];
    priceOff = json['price_off'];
    code = json['code'];
  }
}
