class DriverAvailableModel {
  String? code;
  String? message;
  List<DriverAvailableDataModel>? data;

  DriverAvailableModel({this.code, this.message, this.data});

  DriverAvailableModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DriverAvailableDataModel>[];
      json['data'].forEach((v) {
        data!.add(new DriverAvailableDataModel.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['code'] = this.code;
  //   data['message'] = this.message;
  //   if (this.data != null) {
  //     data['data'] = this.data!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class DriverAvailableDataModel {
  int? id;
  String? name;
  String? latitude;
  String? longitude;
  double? distance;

  DriverAvailableDataModel({this.id, this.name, this.latitude, this.longitude, this.distance});

  DriverAvailableDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'];
  }


}


