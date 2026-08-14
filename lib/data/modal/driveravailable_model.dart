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
  // Not confirmed to be sent by this endpoint — driver-availble-list has
  // only ever been observed returning id/name/latitude/longitude/distance.
  // Parsed defensively (same fallback-key approach used for the driver
  // app's customer_image) so a photo shows up for free if the backend does
  // send one under one of these keys; stays null and falls back to an
  // initials avatar otherwise.
  String? profileImage;

  DriverAvailableDataModel({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.distance,
    this.profileImage,
  });

  DriverAvailableDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'];
    profileImage = (json['profile_image'] ??
            json['driver_image'] ??
            json['image'])
        ?.toString();
  }
}


