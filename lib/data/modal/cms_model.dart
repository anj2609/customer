class CmsModel {
  String? code;
  String? message;
  CmsModelDetails? data;

  CmsModel({this.code, this.message, this.data});

  CmsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null
        ? new CmsModelDetails.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CmsModelDetails {
  String? name;
  String? slug;
  String? details;

  CmsModelDetails({this.name, this.slug, this.details});

  CmsModelDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['details'] = this.details;
    return data;
  }
}
