class DashboardMatchesResponse {
  final bool? status;
  final DashboardData? data;
  final String? message;

  DashboardMatchesResponse({this.status, this.data, this.message});

  factory DashboardMatchesResponse.fromJson(Map<String, dynamic> json) {
    return DashboardMatchesResponse(
      status: json["status"],
      data: json["data"] != null ? DashboardData.fromJson(json["data"]) : null,
      message: json["message"],
    );
  }
}

class DashboardData {
  final bool? status;
  final List<MatchUserModel>? usersFree;
  final List<MatchUserModel>? usersPremium;

  DashboardData({this.status, this.usersFree, this.usersPremium});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      status: json["status"],
      usersFree: (json["usersFree"] as List? ?? [])
          .map((e) => MatchUserModel.fromJson(e))
          .toList(),
      usersPremium: (json["usersPremium"] as List? ?? [])
          .map((e) => MatchUserModel.fromJson(e))
          .toList(),
    );
  }
}

class MatchUserModel {
  final String? id;
  final String? profileId;
  final String? email;
  final String? mobile;
  final String? otp;
  final String? otpExpireAt;
  final List<String>? hobbies;
  final String? gotra;
  final String? ugDegree;
  final String? pgDegree;
  final List<String>? partnerHobbies;
  final List<String>? partnerMaritalStatus;
  final String? partnerGotra;
  final String? homeRegId;
  final dynamic appStep;
  final String? deviceToken;
  final String? formStatus;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? about;
  final String? birthCity;
  final String? birthState;
  final String? complexion;
  final String? diet;
  final String? dob;
  final String? gender;
  final double? height;
  final String? manglik;
  final String? maritalStatus;
  final String? name;
  final String? profileFor;
  final dynamic step;
  final dynamic weight;
  final String? contactEmail;
  final dynamic contactNo;
  final String? reference;
  final dynamic? interestsentstatus;
  final dynamic? shortliststatus;
  final ProfileSettings? profilesetting;
  bool? photorequestcheck;
  dynamic photorequeststatus;

  final CommonNameModel? caste;
  final CommonNameModel? religion;
  final CommonNameModel? occupation;

  // Location
  final CommonNameModel? locCity;
  final String? locHouseType;
  final String? locNationality;
  final String? locPincode;
  final String? locRelation;
  final String? locRelationEmail;
  final String? locRelationMobile;
  final String? locRelationName;
  final String? locResidenceType;
  final String? locState;
  final String? locTempCity;
  final String? locTempPincode;
  final String? locTempState;

  // Photos
  final String? photo;
  final String? photoBlur;
  final String? photo1;
  final String? photo1Blur;
  final String? photo2;
  final String? photo2Blur;
  final String? photo3;
  final String? photo3Blur;
  final String? photo4;
  final String? photo4Blur;

  // Partner Preferences
  final dynamic partnerAgeFrom;
  final dynamic partnerAgeTo;
  final String? partnerCaste;
  final String? partnerCity;
  final String? partnerComplexion;
  final String? partnerCountry;
  final String? partnerDiet;
  final String? partnerDrinking;
  final String? partnerEducation;
  final String? partnerFamilyType;
  final String? partnerFamilyValue;
  final String? partnerHaveChildren;
  final dynamic partnerHeightFrom;
  final dynamic partnerHeightTo;
  final String? partnerIncomeFrom;
  final String? partnerIncomeTo;
  final String? partnerLanguage;
  final String? partnerManagedBy;
  final String? partnerMotherTongue;
  final String? partnerOccupation;
  final String? partnerProfessionalQualification;
  final String? partnerReligion;
  final String? partnerSmoking;
  final String? partnerState;
  final dynamic partnerWeightFrom;
  final dynamic partnerWeightTo;
  final String? partnerWorkingAs;

  final bool? interestSent;

  final PlanDetail? planDetail;

  MatchUserModel({
    this.id,
    this.profileId,
    this.email,
    this.mobile,
    this.otp,
    this.otpExpireAt,
    this.hobbies,
    this.gotra,
    this.ugDegree,
    this.pgDegree,
    this.partnerHobbies,
    this.partnerMaritalStatus,
    this.partnerGotra,
    this.homeRegId,
    this.appStep,
    this.deviceToken,
    this.formStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.about,
    this.birthCity,
    this.birthState,
    this.complexion,
    this.diet,
    this.profilesetting,
    this.photorequestcheck,
    this.photorequeststatus,
    this.dob,
    this.gender,
    this.height,
    this.manglik,
    this.maritalStatus,
    this.name,
    this.profileFor,
    this.step,
    this.weight,
    this.contactEmail,
    this.contactNo,
    this.reference,
    this.caste,
    this.religion,
    this.occupation,

    this.locCity,
    this.locHouseType,
    this.locNationality,
    this.locPincode,
    this.locRelation,
    this.locRelationEmail,
    this.locRelationMobile,
    this.locRelationName,
    this.locResidenceType,
    this.locState,
    this.locTempCity,
    this.locTempPincode,
    this.locTempState,

    this.photo,
    this.photoBlur,
    this.photo1,
    this.photo1Blur,
    this.photo2,
    this.photo2Blur,
    this.photo3,
    this.photo3Blur,
    this.photo4,
    this.photo4Blur,
    this.interestsentstatus,
    this.shortliststatus,

    this.partnerAgeFrom,
    this.partnerAgeTo,
    this.partnerCaste,
    this.partnerCity,
    this.partnerComplexion,
    this.partnerCountry,
    this.partnerDiet,
    this.partnerDrinking,
    this.partnerEducation,
    this.partnerFamilyType,
    this.partnerFamilyValue,
    this.partnerHaveChildren,
    this.partnerHeightFrom,
    this.partnerHeightTo,
    this.partnerIncomeFrom,
    this.partnerIncomeTo,
    this.partnerLanguage,
    this.partnerManagedBy,
    this.partnerMotherTongue,
    this.partnerOccupation,
    this.partnerProfessionalQualification,
    this.partnerReligion,
    this.partnerSmoking,
    this.partnerState,
    this.partnerWeightFrom,
    this.partnerWeightTo,
    this.partnerWorkingAs,

    this.interestSent,
    this.planDetail,
  });

  factory MatchUserModel.fromJson(Map<String, dynamic> json) {
    return MatchUserModel(
      id: json["_id"],
      profileId: json["profile_id"],
      email: json["email"],
      mobile: json["mobile"],
      otp: json["otp"],
      otpExpireAt: json["otp_expire_at"],
      hobbies: (json["hobbies"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      gotra: json["gotra"],
      ugDegree: json["ug_degree"],
      pgDegree: json["pg_degree"],
      partnerHobbies: (json["partner_hobbies"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      partnerMaritalStatus: (json["partner_marital_status"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      partnerGotra: json["partner_gotra"],
      homeRegId: json["home_reg_id"],
      appStep: json["app_step"],
      deviceToken: json["device_token"],
      formStatus: json["form_status"],
      status: json["status"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      about: json["about"],

      birthCity: json["birth_city"],
      birthState: json["birth_state"],
      complexion: json["complexion"],
      photorequestcheck: json['photo_request_check'],
      photorequeststatus: json['photo_request_status'],
      profilesetting: json['profileSettings'] is Map
          ? ProfileSettings.fromJson(json['profileSettings'])
          : null,
      diet: json["diet"],
      dob: json["dob"],
      gender: json["gender"],
      height: json["height"] != null
          ? double.tryParse(json["height"].toString())
          : null,
      manglik: json["manglik"],
      maritalStatus: json["marital_status"],
      name: json["name"],
      profileFor: json["profile_for"],
      step: json["step"],
      weight: json["weight"],
      contactEmail: json["contact_email"],
      contactNo: json["contact_no"],
      reference: json["reference"],
      interestsentstatus: json['interest_sent_status'] ?? "",
      shortliststatus: json['short_list_status'] ?? "",
      caste: json["caste"] != null
          ? CommonNameModel.fromJson(json["caste"])
          : null,
      religion: json["religion"] != null
          ? CommonNameModel.fromJson(json["religion"])
          : null,
      occupation: json["occupation"] != null
          ? CommonNameModel.fromJson(json["occupation"])
          : null,

      locCity: json["loc_city"] != null
          ? CommonNameModel.fromJson(json["loc_city"])
          : null,
      locHouseType: json["loc_house_type"],
      locNationality: json["loc_nationality"],
      locPincode: json["loc_pincode"],
      locRelation: json["loc_relation"],
      locRelationEmail: json["loc_relation_email"],
      locRelationMobile: json["loc_relation_mobile"],
      locRelationName: json["loc_relation_name"],
      locResidenceType: json["loc_residence_type"],
      locState: json["loc_state"],
      locTempCity: json["loc_temp_city"],
      locTempPincode: json["loc_temp_pincode"],
      locTempState: json["loc_temp_state"],

      photo: json["photo"],
      photoBlur: json["photo_blur"],
      photo1: json["photo1"],
      photo1Blur: json["photo1_blur"],
      photo2: json["photo2"],
      photo2Blur: json["photo2_blur"],
      photo3: json["photo3"],
      photo3Blur: json["photo3_blur"],
      photo4: json["photo4"],
      photo4Blur: json["photo4_blur"],

      partnerAgeFrom: json["partner_age_from"],
      partnerAgeTo: json["partner_age_to"],
      partnerCaste: json["partner_caste"],
      partnerCity: json["partner_city"],
      partnerComplexion: json["partner_complexion"],
      partnerCountry: json["partner_country"],
      partnerDiet: json["partner_diet"],
      partnerDrinking: json["partner_drinking"],
      partnerEducation: json["partner_education"],
      partnerFamilyType: json["partner_family_type"],
      partnerFamilyValue: json["partner_family_value"],
      partnerHaveChildren: json["partner_have_children"],
      partnerHeightFrom: json["partner_height_from"] != null
          ? double.tryParse(json["partner_height_from"].toString())
          : null,
      partnerHeightTo: json["partner_height_to"] != null
          ? double.tryParse(json["partner_height_to"].toString())
          : null,
      partnerIncomeFrom: json["partner_income_from"],
      partnerIncomeTo: json["partner_income_to"],
      partnerLanguage: json["partner_language"],
      partnerManagedBy: json["partner_managed_by"],
      partnerMotherTongue: json["partner_mother_tongue"],
      partnerOccupation: json["partner_occupation"],
      partnerProfessionalQualification:
          json["partner_professional_qualification"],
      partnerReligion: json["partner_religion"],
      partnerSmoking: json["partner_smoking"],
      partnerState: json["partner_state"],
      partnerWeightFrom: json["partner_weight_from"],
      partnerWeightTo: json["partner_weight_to"],
      partnerWorkingAs: json["partner_working_as"],

      interestSent: json["interest_sent"],
      planDetail: json["plan_detail"] != null
          ? PlanDetail.fromJson(json["plan_detail"])
          : null,
    );
  }
}

class CommonNameModel {
  final String? id;
  final String? name;
  final String? status;

  CommonNameModel({this.id, this.name, this.status});

  factory CommonNameModel.fromJson(Map<String, dynamic> json) {
    return CommonNameModel(
      id: json["_id"],
      name: json["name"],
      status: json["status"],
    );
  }
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

class PlanDetail {
  final String? id;
  final String? userId;
  final PlanInfo? planId;
  final int? price;
  final String? startDate;
  final String? expiryDate;
  final String? status;

  PlanDetail({
    this.id,
    this.userId,
    this.planId,
    this.price,
    this.startDate,
    this.expiryDate,
    this.status,
  });

  factory PlanDetail.fromJson(Map<String, dynamic> json) {
    return PlanDetail(
      id: json["_id"],
      userId: json["user_id"],
      planId: json["plan_id"] != null
          ? PlanInfo.fromJson(json["plan_id"])
          : null,
      price: json["price"],
      startDate: json["start_date"],
      expiryDate: json["expiry_date"],
      status: json["status"],
    );
  }
}

class PlanInfo {
  final String? id;
  final String? name;
  final int? price;
  final String? status;

  PlanInfo({this.id, this.name, this.price, this.status});

  factory PlanInfo.fromJson(Map<String, dynamic> json) {
    return PlanInfo(
      id: json["_id"],
      name: json["name"],
      price: json["price"],
      status: json["status"],
    );
  }
}
