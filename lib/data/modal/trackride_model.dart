class TrackRideModel {
  String? code;
  String? message;
  DatTrackRideDetails? data;

  TrackRideModel({this.code, this.message, this.data});

  TrackRideModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new DatTrackRideDetails.fromJson(json['data']) : null;
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

class DatTrackRideDetails {
  int? bookingId;
  String? status;
  String? otp;
  double? lat;
  double? lng;
  double? dropLat;
  double? dropLng;
  DriverInfo? driverInfo;

  DatTrackRideDetails(
      {this.bookingId,
      this.status,
      this.otp,
      this.lat,
      this.lng,
      this.dropLat,
      this.dropLng,
      this.driverInfo});

  DatTrackRideDetails.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    status = json['status'];
    otp = json['otp'];
    lat = json['lat'];
    lng = json['lng'];
    dropLat = json['drop_lat'];
    dropLng = json['drop_lng'];
    driverInfo = json['driver_info'] != null
        ? new DriverInfo.fromJson(json['driver_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['drop_lat'] = this.dropLat;
    data['drop_lng'] = this.dropLng;
    if (this.driverInfo != null) {
      data['driver_info'] = this.driverInfo!.toJson();
    }
    return data;
  }
}

class DriverInfo {
  int? driverid;
  String? profileImage;
  String? name;
  String? phone;
  String? vehicalName;
  String? vehicalNumber;
  String? vehicalColor;
  String? lat;
  String? lng;

  DriverInfo(
      {
      this.driverid,
      this.profileImage,
      this.name,
      this.phone,
      this.vehicalName,
      this.vehicalNumber,
      this.vehicalColor,
      this.lat,
      this.lng});

  DriverInfo.fromJson(Map<String, dynamic> json) {
    driverid = json['id'];
    profileImage = json['profile_image'];
    name = json['name'];
    phone = json['phone'];
    vehicalName = json['vehical_name'];
    vehicalNumber = json['vehical_number'];
    vehicalColor = json['vehical_color'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.driverid;
    data['profile_image'] = this.profileImage;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['vehical_name'] = this.vehicalName;
    data['vehical_number'] = this.vehicalNumber;
    data['vehical_color'] = this.vehicalColor;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
