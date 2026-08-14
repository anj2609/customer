class TrackRideModel {
  String? code;
  String? message;
  DatTrackRideDetails? data;

  TrackRideModel({this.code, this.message, this.data});

  TrackRideModel.fromJson(Map<String, dynamic> json) {
    // Was `code = json['code'];` — a raw assignment into a String? field.
    // Throws a TypeError if this backend ever sends "code" as a JSON
    // number (200) rather than a string ("200"), which the rest of this
    // app has repeatedly turned out to need to tolerate (see the
    // `?.toString() == '200'` comparisons used elsewhere). toString()
    // makes the assignment itself safe either way.
    code = json['code']?.toString();
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
    // Was a raw dynamic assignment (`lat = json['lat'];`) into a `double?`
    // field — throws a TypeError the instant the backend sends lat/lng as
    // a numeric-looking string (or even a whole-number JSON int, since
    // Dart doesn't implicitly widen int to double on assignment either).
    // TrackRideApi2() — the only live caller, polled every 3s from
    // findingdriver_screen.dart — has no try/catch around this fromJson()
    // call at all, so a throw here became an uncaught exception on every
    // single poll: rideDetails/driverInfo/rideStatus never got updated,
    // which is exactly what leaves the rider's live tracking map/ride
    // status frozen the instant a ride starts.
    lat = double.tryParse(json['lat']?.toString() ?? '');
    lng = double.tryParse(json['lng']?.toString() ?? '');
    dropLat = double.tryParse(json['drop_lat']?.toString() ?? '');
    dropLng = double.tryParse(json['drop_lng']?.toString() ?? '');
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
    // These are declared String? but read via findingdriver_screen.dart's
    // own _coordinate() helper, which already handles either a numeric or
    // string value — so the risk here is purely the *assignment* throwing
    // if the backend sends lat/lng as a JSON number rather than a string
    // (raw `json['lat']` into a String? field throws a TypeError on a
    // non-null num). ?.toString() makes the assignment itself safe
    // regardless of which shape the backend actually sends.
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
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
