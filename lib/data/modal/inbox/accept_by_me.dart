class InboxAcceptedbymeModel {
  bool? status;
  dynamic message;
  List<AcceptedbymeinboxData>? data;

  InboxAcceptedbymeModel({this.status, this.message, this.data});

  factory InboxAcceptedbymeModel.fromJson(Map<String, dynamic> json) {
    return InboxAcceptedbymeModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data:
          (json["data"] as List?)
              ?.map((e) => AcceptedbymeinboxData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AcceptedbymeinboxData {
  dynamic id;
  AcceptedbymeUserModel? memberId;
  AcceptedbymeUserModel? partnerId;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic v;

  AcceptedbymeinboxData({
    this.id,
    this.memberId,
    this.partnerId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AcceptedbymeinboxData.fromJson(Map<String, dynamic> json) {
    return AcceptedbymeinboxData(
      id: json["_id"] ?? "",
      memberId: json["member_id"] != null
          ? AcceptedbymeUserModel.fromJson(json["member_id"])
          : null,
      partnerId: json["partner_id"] != null
          ? AcceptedbymeUserModel.fromJson(json["partner_id"])
          : null,
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }
}

class AcceptedbymeUserModel {
  dynamic id;
  dynamic profileId;
  dynamic email;
  dynamic mobile;
  SubCaste? subCaste;
  dynamic deviceToken;
  dynamic formStatus;

  dynamic birthState;
  dynamic dob;
  dynamic gender;
  dynamic maritalStatus;
  dynamic name;
  dynamic profileFor;

  Caste? caste;

  Religion? religion;

  dynamic locRelation;

  City? locCity;
  dynamic locHouseType;
  dynamic locLandmark;
  dynamic locNationality;

  StateModel? locState;

  double? height;
  dynamic manglik;
  dynamic weight;

  dynamic annualIncome;
  dynamic highestDegree;
  dynamic occupation;

  dynamic photo;
  dynamic photoBlur;
  dynamic photo1;
  dynamic photo1Blur;
  dynamic photo2;
  dynamic photo2Blur;
  dynamic photo3;
  dynamic photo3Blur;
  dynamic photo4;
  dynamic photo4Blur;
  ProfileSettings? profilesetting;
  bool? photorequestcheck;
  dynamic photorequeststatus;
  // Extra plan detail (only in partner_id)
  PlanDetail? planDetail;

  AcceptedbymeUserModel({
    this.id,
    this.profileId,
    this.email,
    this.mobile,
    this.profilesetting,
    this.photorequestcheck,
    this.photorequeststatus,
    this.deviceToken,
    this.formStatus,

    this.birthState,
    this.dob,
    this.gender,
    this.maritalStatus,
    this.name,
    this.profileFor,
    this.subCaste,
    this.caste,

    this.religion,

    this.locRelation,

    this.locCity,
    this.locHouseType,
    this.locLandmark,
    this.locNationality,

    this.locState,

    this.height,
    this.manglik,
    this.weight,
    this.annualIncome,
    this.highestDegree,
    this.occupation,

    this.photo,
    this.photoBlur,
    this.photo1,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photo1Blur,

    this.planDetail,
  });

  factory AcceptedbymeUserModel.fromJson(Map<String, dynamic> json) {
    return AcceptedbymeUserModel(
      id: json["_id"] ?? "",
      profileId: json["profile_id"] ?? "",
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",

      deviceToken: json["device_token"] ?? "",
      formStatus: json["form_status"] ?? "",

      birthState: json["birth_state"] ?? "",
      dob: json["dob"] ?? "",
      gender: json["gender"] ?? "",
      maritalStatus: json["marital_status"] ?? "",
      name: json["name"] ?? "",
      profileFor: json["profile_for"] ?? "",

      caste: json["caste"] != null ? Caste.fromJson(json["caste"]) : null,

      religion: json["religion"] != null
          ? Religion.fromJson(json["religion"])
          : null,

      locRelation: json["loc_relation"] ?? "",

      locCity: json["loc_city"] != null
          ? City.fromJson(json["loc_city"])
          : null,
      locHouseType: json["loc_house_type"] ?? "",
      locLandmark: json["loc_landmark"] ?? "",
      locNationality: json["loc_nationality"] ?? "",

      locState: json["loc_state"] != null
          ? StateModel.fromJson(json["loc_state"])
          : null,
      photorequestcheck: json['photo_request_check'],
      profilesetting: json['profileSettings'] is Map
          ? ProfileSettings.fromJson(json['profileSettings'])
          : null,
      photorequeststatus: json['photo_request_status'],
      height: (json["height"] ?? 0).toDouble(),
      manglik: json["manglik"] ?? "",
      weight: json["weight"] ?? 0,
      subCaste: json["sub_caste"] != null
          ? SubCaste.fromJson(json["sub_caste"])
          : null,
      annualIncome: json["annual_income"] ?? "",
      highestDegree: json["highest_degree"] ?? "",

      occupation: safeMap(json['occupation']) != null
          ? RefData.fromJson(safeMap(json['occupation'])!)
          : null,

      photo: json["photo"] ?? "",
      photo2: json["photo2"] ?? "",
      photo3: json["photo3"] ?? "",
      photo4: json["photo4"] ?? "",
      photoBlur: json["photo_blur"] ?? "",
      photo1: json["photo1"] ?? "",
      photo1Blur: json["photo1_blur"] ?? "",

      planDetail: json["plan_detail"] != null
          ? PlanDetail.fromJson(json["plan_detail"])
          : null,
    );
  }
}

/// -----------------------------
/// SMALL NESTED MODELS
/// -----------------------------

class Gotra {
  dynamic id, name, religionId, status, createdAt, updatedAt;

  Gotra({
    this.id,
    this.name,
    this.religionId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Gotra.fromJson(Map<String, dynamic> json) {
    return Gotra(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      religionId: json["religion_id"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

class Caste {
  dynamic id, name, religionId, status, createdAt, updatedAt;

  Caste({
    this.id,
    this.name,
    this.religionId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Caste.fromJson(Map<String, dynamic> json) {
    return Caste(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      religionId: json["religion_id"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

Map<String, dynamic>? safeMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  return null; // string or null ignore
}

class RefData {
  dynamic id;
  dynamic name;
  dynamic religionId;
  dynamic countryId;
  dynamic stateId;
  dynamic casteId;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic v;

  RefData({
    this.id,
    this.name,
    this.religionId,
    this.countryId,
    this.stateId,
    this.casteId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RefData.fromJson(dynamic json) {
    final map = safeMap(json);

    if (map == null) {
      // If json is String/null, return empty safe object
      return RefData(id: null, name: json?.toString());
    }

    return RefData(
      id: map['_id']?.toString(),
      name: map['name']?.toString(),
      religionId: map['religion_id']?.toString(),
      countryId: map['country_id']?.toString(),
      stateId: map['state_id']?.toString(),
      casteId: map['caste_id']?.toString(),
      status: map['status']?.toString(),
      createdAt: map['createdAt']?.toString(),
      updatedAt: map['updatedAt']?.toString(),
      v: map['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'religion_id': religionId,
    'country_id': countryId,
    'state_id': stateId,
    'caste_id': casteId,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}

class ProfileSettings {
  String? id;
  String? userId;
  int? nameShow;
  int? emailShow;
  int? customerIdShow;
  int? photoShow;
  int? dateOfBirthShow;
  int? workWithShow;
  int? incomeShow;
  String? createdAt;
  String? updatedAt;
  int? v;

  ProfileSettings({
    this.id,
    this.userId,
    this.nameShow,
    this.emailShow,
    this.customerIdShow,
    this.photoShow,
    this.dateOfBirthShow,
    this.workWithShow,
    this.incomeShow,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  /// ---- SAFE PARSING ---- ///
  static int? toIntSafe(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static String? toStringSafe(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  /// ---- FROM JSON ---- ///
  factory ProfileSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileSettings();

    return ProfileSettings(
      id: toStringSafe(json["_id"]),
      userId: toStringSafe(json["user_id"]),

      nameShow: toIntSafe(json["name_show"]),
      emailShow: toIntSafe(json["email_show"]),
      customerIdShow: toIntSafe(json["customer_id_show"]),
      photoShow: toIntSafe(json["photo_show"]),
      dateOfBirthShow: toIntSafe(json["date_of_birth_show"]),
      workWithShow: toIntSafe(json["work_with_show"]),
      incomeShow: toIntSafe(json["income_show"]),

      createdAt: toStringSafe(json["createdAt"]),
      updatedAt: toStringSafe(json["updatedAt"]),
      v: toIntSafe(json["__v"]),
    );
  }

  /// ---- TO JSON ---- ///
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user_id": userId,
      "name_show": nameShow,
      "email_show": emailShow,
      "customer_id_show": customerIdShow,
      "photo_show": photoShow,
      "date_of_birth_show": dateOfBirthShow,
      "work_with_show": workWithShow,
      "income_show": incomeShow,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

class Religion {
  dynamic id, name, status, createdAt, updatedAt;

  Religion({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  factory Religion.fromJson(Map<String, dynamic> json) {
    return Religion(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

class SubCaste {
  dynamic id, name, religionId, casteId, status, createdAt, updatedAt;

  SubCaste({
    this.id,
    this.name,
    this.religionId,
    this.casteId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCaste.fromJson(Map<String, dynamic> json) {
    return SubCaste(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      religionId: json["religion_id"] ?? "",
      casteId: json["caste_id"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

class City {
  dynamic id, name, countryId, stateId, status, createdAt, updatedAt;

  City({
    this.id,
    this.name,
    this.countryId,
    this.stateId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      countryId: json["country_id"] ?? "",
      stateId: json["state_id"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

class StateModel {
  dynamic id, name, countryId, status, createdAt, updatedAt;

  StateModel({
    this.id,
    this.name,
    this.countryId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      countryId: json["country_id"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

class WorkingWith {
  dynamic id, name, status, createdAt, updatedAt;

  WorkingWith({
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkingWith.fromJson(Map<String, dynamic> json) {
    return WorkingWith(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

class PlanDetail {
  dynamic id;
  dynamic userId;
  Plan? planId;
  dynamic price;
  dynamic startDate;
  dynamic expiryDate;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;

  dynamic advanceSearch;
  dynamic chat;
  dynamic matchSuggestions;
  dynamic profileHighlight;
  dynamic profileView;
  dynamic viewContact;
  dynamic voiceVideo;
  dynamic sendInterest;

  PlanDetail({
    this.id,
    this.userId,
    this.planId,
    this.price,
    this.startDate,
    this.expiryDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.advanceSearch,
    this.chat,
    this.matchSuggestions,
    this.profileHighlight,
    this.profileView,
    this.viewContact,
    this.voiceVideo,
    this.sendInterest,
  });

  factory PlanDetail.fromJson(Map<String, dynamic> json) {
    return PlanDetail(
      id: json["_id"] ?? "",
      userId: json["user_id"] ?? "",
      planId: json["plan_id"] != null ? Plan.fromJson(json["plan_id"]) : null,
      price: json["price"] ?? 0,
      startDate: json["start_date"] ?? "",
      expiryDate: json["expiry_date"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      advanceSearch: json["advance_search"] ?? "",
      chat: json["chat"] ?? "",
      matchSuggestions: json["match_suggestions"] ?? "",
      profileHighlight: json["profile_highlight"] ?? "",
      profileView: json["profile_view"] ?? "",
      viewContact: json["view_contact"] ?? "",
      voiceVideo: json["voice_video"] ?? "",
      sendInterest: json["send_interest"] ?? "",
    );
  }
}

class Plan {
  dynamic id, name, status, createdAt, updatedAt;
  dynamic price;

  dynamic advanceSearch;
  dynamic chat;
  dynamic matchSuggestions;
  dynamic profileHighlight;
  dynamic profileView;
  dynamic viewContact;
  dynamic voiceVideo;
  dynamic sendInterest;

  Plan({
    this.id,
    this.name,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.advanceSearch,
    this.chat,
    this.matchSuggestions,
    this.profileHighlight,
    this.profileView,
    this.viewContact,
    this.voiceVideo,
    this.sendInterest,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      price: json["price"] ?? 0,
      status: json["status"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      advanceSearch: json["advance_search"] ?? "",
      chat: json["chat"] ?? "",
      matchSuggestions: json["match_suggestions"] ?? "",
      profileHighlight: json["profile_highlight"] ?? "",
      profileView: json["profile_view"] ?? "",
      viewContact: json["view_contact"] ?? "",
      voiceVideo: json["voice_video"] ?? "",
      sendInterest: json["send_interest"] ?? "",
    );
  }
}
