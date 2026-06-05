class ActivityModels {
  String? code;
  String? message;
  ActivityDataModel? data;

  ActivityModels({this.code, this.message, this.data});

  ActivityModels.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    message = json['message'];

    data = json['data'] != null
        ? ActivityDataModel.fromJson(json['data'])
        : null;
  }
}

class ActivityDataModel {
  int? currentPage;
  List<ActivityDataMainModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  ActivityDataModel({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  ActivityDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    if (json['data'] != null) {
      data = <ActivityDataMainModel>[];
      json['data'].forEach((v) {
        data!.add(ActivityDataMainModel.fromJson(v));
      });
    }

    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];

    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }

    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class ActivityDataMainModel {
  int? id;
  String? pickupAddress;
  String? dropAddress;
  double? pickupLat;
  double? pickupLng;
  double? dropLat;
  double? dropLng;
  String? pickupOtp;
  int? totalFare;
  String? status;
  String? createdAt;
  Driver? driver;
  VehicleType? vehicleType;
  String? image;
  String? paymentType;

  ActivityDataMainModel({
    this.id,
    this.pickupAddress,
    this.dropAddress,
    this.pickupLat,
    this.pickupLng,
    this.dropLat,
    this.dropLng,
    this.pickupOtp,
    this.totalFare,
    this.status,
    this.createdAt,
    this.driver,
    this.vehicleType,
    this.image,
    this.paymentType,
  });

  ActivityDataMainModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];

    pickupLat = json['pickup_lat'] != null
        ? double.tryParse(json['pickup_lat'].toString())
        : 0.0;

    pickupLng = json['pickup_lng'] != null
        ? double.tryParse(json['pickup_lng'].toString())
        : 0.0;

    dropLat = json['drop_lat'] != null
        ? double.tryParse(json['drop_lat'].toString())
        : 0.0;

    dropLng = json['drop_lng'] != null
        ? double.tryParse(json['drop_lng'].toString())
        : 0.0;

    pickupOtp = json['pickup_otp']?.toString();

    totalFare = json['total_fare'] != null
        ? int.tryParse(json['total_fare'].toString())
        : 0;

    status = json['status'];
    createdAt = json['created_at'];

    driver = json['driver'] != null
        ? Driver.fromJson(json['driver'])
        : null;

    vehicleType = json['vehicle_type'] != null
        ? VehicleType.fromJson(json['vehicle_type'])
        : null;

    /// vehicle image
    if (json['vehicle_type'] != null &&
        json['vehicle_type']['image'] != null &&
        json['vehicle_type']['image']
            .toString()
            .trim()
            .isNotEmpty) {
      image = json['vehicle_type']['image'].toString();
    } else {
      image = '';
    }

    paymentType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['pickup_address'] = pickupAddress;
    data['drop_address'] = dropAddress;
    data['pickup_lat'] = pickupLat;
    data['pickup_lng'] = pickupLng;
    data['drop_lat'] = dropLat;
    data['drop_lng'] = dropLng;
    data['pickup_otp'] = pickupOtp;
    data['total_fare'] = totalFare;
    data['status'] = status;
    data['created_at'] = createdAt;

    if (driver != null) {
      data['driver'] = driver!.toJson();
    }

    if (vehicleType != null) {
      data['vehicle_type'] = vehicleType!.toJson();
    }

    data['image'] = image;
    data['payment_type'] = paymentType;

    return data;
  }
}

class Driver {
  String? name;
  String? phone;

  Driver({this.name, this.phone});

  Driver.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['name'] = name;
    data['phone'] = phone;

    return data;
  }
}

class VehicleType {
  int? id;
  String? name;
  String? image;

  VehicleType({
    this.id,
    this.name,
    this.image,
  });

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    name = json['name'];

    if (json['image'] != null &&
        json['image'].toString().trim().isNotEmpty &&
        json['image'].toString().toLowerCase() != 'null') {
      image = json['image'].toString();
    } else {
      image = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['name'] = name;
    data['image'] = image;

    return data;
  }
}

class Links {
  String? url;
  String? label;
  int? page;
  bool? active;

  Links({
    this.url,
    this.label,
    this.page,
    this.active,
  });

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    page = json['page'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['url'] = url;
    data['label'] = label;
    data['page'] = page;
    data['active'] = active;

    return data;
  }
}