class CancelationModel {
  String? code;
  String? message;
  List<CancelationModelData>? data;

  CancelationModel({this.code, this.message, this.data});

  CancelationModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CancelationModelData>[];
      json['data'].forEach((v) {
        data!.add(new CancelationModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CancelationModelData {
  int? id;
  String? name;

  CancelationModelData({this.id, this.name});

  CancelationModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
