import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  bool? status;
  dynamic message;
  ProfileData? data;

  ProfileResponse({this.status, this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] as bool?,
      message: json['message'] as dynamic,
      data: json['data'] != null
          ? ProfileData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

class ProfileData {
  MemberData? memberData;
  dynamic expressEntrest;
  dynamic contactLockStatus;
  PartnerPreferences? partnerPreferences;
  dynamic interestsentstatus;
  dynamic shortliststatus;
  dynamic totalmatches;

  ProfileData({
    this.memberData,
    this.expressEntrest,
    this.contactLockStatus,
    this.partnerPreferences,
    this.shortliststatus,
    this.interestsentstatus,
    this.totalmatches,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      memberData: json['memberData'] != null
          ? MemberData.fromJson(json['memberData'] as Map<String, dynamic>)
          : null,
      expressEntrest: json['express_entrest'],
      contactLockStatus: json['contact_lock_status'],
      shortliststatus: json['short_list_status'] ?? "",
      interestsentstatus: json['interest_sent_status'] ?? "",
      partnerPreferences: json['partnerPreferences'] != null
          ? PartnerPreferences.fromJson(
              json['partnerPreferences'] as Map<String, dynamic>,
            )
          : null,
      totalmatches: json['total_matches'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    'memberData': memberData?.toJson(),
    'express_entrest': expressEntrest,
    'contact_lock_status': contactLockStatus,
    'partnerPreferences': partnerPreferences?.toJson(),
    'total_matches': totalmatches,
  };
}

Map<String, dynamic>? safeMap(dynamic json) {
  if (json is Map<String, dynamic>) return json;
  return null; // string or null ignore
}

class MemberData {
  dynamic id;
  dynamic profileId;
  dynamic email;
  dynamic mobile;
  dynamic otp;
  dynamic otpExpireAt;

  List<Hobby>? hobbies;
  RefData? gotra;

  dynamic ugDegree;
  dynamic pgDegree;

  List<String>? partnerHobbies;
  List<dynamic>? partnerMaritalStatus;

  RefData? partnerGotra;
  dynamic homeRegId;
  dynamic appStep;
  dynamic deviceToken;
  dynamic formStatus;
  dynamic status;

  dynamic createdAt;
  dynamic updatedAt;

  dynamic about;

  RefData? birthState;

  dynamic dob;
  dynamic gender;

  RefData? maritalStatus;
  dynamic name;

  RefData? profileFor;

  dynamic step;

  dynamic contactEmail;
  dynamic contactNo;

  dynamic facebook;
  dynamic instagram;

  dynamic reference;
  dynamic referenceOther;

  RefData? caste;
  dynamic dosh;
  dynamic gotraOther;

  RefData? religion;
  RefData? subCaste;

  dynamic locRelation;
  dynamic locRelationEmail;
  dynamic locRelationMobile;
  dynamic locRelationName;

  RefData? locCity;
  dynamic locHouseType;
  dynamic locLandmark;

  RefData? locNationality;
  dynamic locPincode;
  dynamic locResidenceType;

  RefData? locState;

  RefData? locTempCity;
  dynamic locTempLandmark;
  dynamic locTempPincode;
  RefData? locTempState;

  dynamic familyType;
  dynamic familyValue;

  dynamic marriedBrother;
  dynamic marriedSister;
  dynamic noOfBrother;
  dynamic noOfBrotherInLaw;
  dynamic noOfSister;
  dynamic noOfSisterInLaw;

  RefData? birthCity;
  dynamic bloodGroup;

  RefData? complexion;
  RefData? diet;

  dynamic disability;
  dynamic healthInformation;

  double? height;
  dynamic manglik;
  dynamic weight;

  dynamic annualIncome;

  RefData? highestDegree;
  RefData? occupation;

  dynamic organizationName;
  dynamic otherEducation;

  dynamic pgCollegeName;
  dynamic prevWorkingDetail;
  dynamic schoolName;
  dynamic ugCollegeName;

  RefData? workingWith;

  dynamic photo;
  dynamic photo1;
  dynamic photo2;
  dynamic photo3;
  dynamic photo4;
  dynamic photoBlur;
  ProfileSettings? profilesetting;
  bool? photorequestcheck;
  dynamic partnerQualities;
  dynamic photorequeststatus;
  dynamic dobrequesttatus;
  dynamic dobrequestcheck;

  RefData? partnerCaste;
  dynamic partnerDosh;
  RefData? partnerReligion;
  RefData? partnerSubCaste;

  dynamic partnerAgeFrom;
  dynamic partnerAgeTo;

  RefData? partnerCity;
  RefData? partnerComplexion;
  RefData? partnerCountry;

  RefData? partnerDiet;
  dynamic partnerDrinking;

  RefData? partnerEducation;
  dynamic partnerHaveChildren;

  double? partnerHeightFrom;
  double? partnerHeightTo;

  dynamic partnerIncomeFrom;
  dynamic partnerIncomeTo;

  RefData? partnerLanguage;

  dynamic partnerManagedBy;

  RefData? partnerMotherTongue;

  RefData? partnerOccupation;
  RefData? partnerProfessionalQualification;

  dynamic partnerSmoking;

  RefData? partnerState;

  dynamic partnerWeightFrom;
  dynamic partnerWeightTo;
  ProfilePhoneSettingModel? profilePhoneSettingModel;
  RefData? partnerWorkingAs;
  String? selfintroductionvideo;

  MemberData({
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
    this.dobrequestcheck,
    this.dobrequesttatus,
    this.formStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.about,
    this.birthState,
    this.dob,
    this.gender,
    this.maritalStatus,
    this.name,
    this.profileFor,
    this.step,
    this.contactEmail,
    this.contactNo,
    this.facebook,
    this.instagram,
    this.reference,
    this.referenceOther,
    this.caste,
    this.dosh,
    this.photorequestcheck,
    this.gotraOther,
    this.religion,
    this.subCaste,
    this.locRelation,
    this.locRelationEmail,
    this.locRelationMobile,
    this.locRelationName,
    this.locCity,
    this.photorequeststatus,
    this.locHouseType,
    this.locLandmark,
    this.locNationality,
    this.locPincode,
    this.locResidenceType,
    this.locState,
    this.profilesetting,
    this.locTempCity,
    this.locTempLandmark,
    this.locTempPincode,
    this.locTempState,
    this.selfintroductionvideo,
    this.familyType,
    this.familyValue,
    this.marriedBrother,
    this.marriedSister,
    this.noOfBrother,
    this.noOfBrotherInLaw,
    this.noOfSister,
    this.noOfSisterInLaw,
    this.birthCity,
    this.bloodGroup,
    this.complexion,
    this.diet,
    this.disability,
    this.healthInformation,
    this.height,
    this.manglik,
    this.profilePhoneSettingModel,

    this.weight,
    this.annualIncome,
    this.highestDegree,
    this.occupation,
    this.organizationName,
    this.otherEducation,
    this.pgCollegeName,
    this.prevWorkingDetail,
    this.schoolName,
    this.ugCollegeName,
    this.workingWith,
    this.photo,
    this.photo1,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photoBlur,
    this.partnerQualities,
    this.partnerCaste,
    this.partnerDosh,
    this.partnerReligion,
    this.partnerSubCaste,
    this.partnerAgeFrom,
    this.partnerAgeTo,
    this.partnerCity,
    this.partnerComplexion,
    this.partnerCountry,
    this.partnerDiet,
    this.partnerDrinking,
    this.partnerEducation,
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
    this.partnerSmoking,
    this.partnerState,
    this.partnerWeightFrom,
    this.partnerWeightTo,
    this.partnerWorkingAs,
  });

  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      id: json['_id'],
      profileId: json['profile_id'],
      email: json['email'],
      mobile: json['mobile'],
      otp: json['otp'],
      otpExpireAt: json['otp_expire_at'],

      hobbies: (json['hobbies'] as List?)
          ?.map((e) => Hobby.fromJson(e as Map<String, dynamic>))
          .toList(),

      gotra: safeMap(json['gotra']) != null
          ? RefData.fromJson(safeMap(json['gotra'])!)
          : null,

      ugDegree: json['ug_degree'],
      pgDegree: json['pg_degree'],

      partnerHobbies: (json['partner_hobbies'] as List?)
          ?.map((e) => e.toString())
          .toList(),

      partnerMaritalStatus: (json['partner_marital_status'] as List?) ?? [],
      photorequeststatus: json['photo_request_status'],
      partnerGotra: safeMap(json['partner_gotra']) != null
          ? RefData.fromJson(safeMap(json['partner_gotra'])!)
          : null,
      photorequestcheck: json['photo_request_check'],
      homeRegId: json['home_reg_id']?.toString(),
      appStep: json['app_step'],
      deviceToken: json['device_token']?.toString(),
      formStatus: json['form_status'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      about: json['about'],
      dobrequestcheck: json['dob_request_check'],
      dobrequesttatus: json['dob_request_status'],
      birthState: safeMap(json['birth_state']) != null
          ? RefData.fromJson(safeMap(json['birth_state'])!)
          : null,

      dob: json['dob'],
      gender: json['gender'],

      maritalStatus: safeMap(json['marital_status']) != null
          ? RefData.fromJson(safeMap(json['marital_status'])!)
          : null,

      name: json['name'],

      profileFor: safeMap(json['profile_for']) != null
          ? RefData.fromJson(safeMap(json['profile_for'])!)
          : null,

      step: json['step'],
      contactEmail: json['contact_email'],
      contactNo: json['contact_no']?.toString(),
      facebook: json['facebook'],
      instagram: json['instagram'],
      reference: json['reference'],
      referenceOther: json['reference_other'],

      caste: safeMap(json['caste']) != null
          ? RefData.fromJson(safeMap(json['caste'])!)
          : null,
      profilesetting: json['profileSettings'] is Map
          ? ProfileSettings.fromJson(json['profileSettings'])
          : null,
      profilePhoneSettingModel: json['profilePhoneSetting'] is Map
          ? ProfilePhoneSettingModel.fromJson(json['profilePhoneSetting'])
          : null,
      dosh: json['dosh'],
      gotraOther: json['gotra_other'],

      religion: safeMap(json['religion']) != null
          ? RefData.fromJson(safeMap(json['religion'])!)
          : null,

      subCaste: safeMap(json['sub_caste']) != null
          ? RefData.fromJson(safeMap(json['sub_caste'])!)
          : null,
      selfintroductionvideo: json['self_introduction_video'],
      locRelation: json['loc_relation'],
      locRelationEmail: json['loc_relation_email'],
      locRelationMobile: json['loc_relation_mobile'],
      locRelationName: json['loc_relation_name'],

      locCity: safeMap(json['loc_city']) != null
          ? RefData.fromJson(safeMap(json['loc_city'])!)
          : null,

      locHouseType: json['loc_house_type'],
      locLandmark: json['loc_landmark'],

      locNationality: safeMap(json['loc_nationality']) != null
          ? RefData.fromJson(safeMap(json['loc_nationality'])!)
          : null,

      locPincode: json['loc_pincode'],
      locResidenceType: json['loc_residence_type'],

      locState: safeMap(json['loc_state']) != null
          ? RefData.fromJson(safeMap(json['loc_state'])!)
          : null,

      locTempCity: safeMap(json['loc_temp_city']) != null
          ? RefData.fromJson(safeMap(json['loc_temp_city'])!)
          : null,

      locTempLandmark: json['loc_temp_landmark'],
      locTempPincode: json['loc_temp_pincode'],

      locTempState: safeMap(json['loc_temp_state']) != null
          ? RefData.fromJson(safeMap(json['loc_temp_state'])!)
          : null,

      familyType: json['family_type'],
      familyValue: json['family_value'],
      marriedBrother: json['married_brother'],
      marriedSister: json['married_sister'],
      noOfBrother: json['no_of_brother'],
      noOfBrotherInLaw: json['no_of_brother_in_law'],
      noOfSister: json['no_of_sister'],
      noOfSisterInLaw: json['no_of_sister_in_law'],

      birthCity: safeMap(json['birth_city']) != null
          ? RefData.fromJson(safeMap(json['birth_city'])!)
          : null,

      bloodGroup: json['blood_group'],

      complexion: safeMap(json['complexion']) != null
          ? RefData.fromJson(safeMap(json['complexion'])!)
          : null,

      diet: safeMap(json['diet']) != null
          ? RefData.fromJson(safeMap(json['diet'])!)
          : null,

      disability: json['disability'],
      healthInformation: json['health_information'],
      height: parseDouble(json['height']),

      manglik: json['manglik'],
      weight: json['weight'],

      annualIncome: json['annual_income']?.toString(),

      highestDegree: safeMap(json['highest_degree']) != null
          ? RefData.fromJson(safeMap(json['highest_degree'])!)
          : null,

      occupation: safeMap(json['occupation']) != null
          ? RefData.fromJson(safeMap(json['occupation'])!)
          : null,

      organizationName: json['organization_name'],
      otherEducation: json['other_education'],
      pgCollegeName: json['pg_college_name'],
      prevWorkingDetail: json['prev_working_detail'],
      schoolName: json['school_name'],
      ugCollegeName: json['ug_college_name'],

      workingWith: safeMap(json['working_with']) != null
          ? RefData.fromJson(safeMap(json['working_with'])!)
          : null,

      photo: json['photo'],
      photo1: json['photo1'],
      photo2: json['photo2'],
      photo3: json['photo3'],
      photo4: json['photo4'],
      photoBlur: json['photo_blur'],

      partnerQualities: json['partner_qualities'],

      partnerCaste: safeMap(json['partner_caste']) != null
          ? RefData.fromJson(safeMap(json['partner_caste'])!)
          : null,

      partnerDosh: json['partner_dosh'],

      partnerReligion: safeMap(json['partner_religion']) != null
          ? RefData.fromJson(safeMap(json['partner_religion'])!)
          : null,

      partnerSubCaste: safeMap(json['partner_sub_caste']) != null
          ? RefData.fromJson(safeMap(json['partner_sub_caste'])!)
          : null,

      partnerAgeFrom: json['partner_age_from'],
      partnerAgeTo: json['partner_age_to'],

      partnerCity: safeMap(json['partner_city']) != null
          ? RefData.fromJson(safeMap(json['partner_city'])!)
          : null,

      partnerComplexion: safeMap(json['partner_complexion']) != null
          ? RefData.fromJson(safeMap(json['partner_complexion'])!)
          : null,

      partnerCountry: safeMap(json['partner_country']) != null
          ? RefData.fromJson(safeMap(json['partner_country'])!)
          : null,

      partnerDiet: safeMap(json['partner_diet']) != null
          ? RefData.fromJson(safeMap(json['partner_diet'])!)
          : null,

      partnerDrinking: json['partner_drinking'],

      partnerEducation: safeMap(json['partner_education']) != null
          ? RefData.fromJson(safeMap(json['partner_education'])!)
          : null,

      partnerHaveChildren: json['partner_have_children']?.toString(),

      partnerHeightFrom: parseDouble(json['partner_height_from']),
      partnerHeightTo: parseDouble(json['partner_height_to']),

      partnerIncomeFrom: json['partner_income_from']?.toString(),
      partnerIncomeTo: json['partner_income_to']?.toString(),

      partnerLanguage: safeMap(json['partner_language']) != null
          ? RefData.fromJson(safeMap(json['partner_language'])!)
          : null,

      partnerManagedBy: json['partner_managed_by'],

      partnerMotherTongue: safeMap(json['partner_mother_tongue']) != null
          ? RefData.fromJson(safeMap(json['partner_mother_tongue'])!)
          : null,

      partnerOccupation: safeMap(json['partner_occupation']) != null
          ? RefData.fromJson(safeMap(json['partner_occupation'])!)
          : null,

      partnerProfessionalQualification:
          safeMap(json['partner_professional_qualification']) != null
          ? RefData.fromJson(
              safeMap(json['partner_professional_qualification'])!,
            )
          : null,

      partnerSmoking: json['partner_smoking'],

      partnerState: safeMap(json['partner_state']) != null
          ? RefData.fromJson(safeMap(json['partner_state'])!)
          : null,

      partnerWeightFrom: json['partner_weight_from'],
      partnerWeightTo: json['partner_weight_to'],

      partnerWorkingAs: safeMap(json['partner_working_as']) != null
          ? RefData.fromJson(safeMap(json['partner_working_as'])!)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'profile_id': profileId,
    'email': email,
    'mobile': mobile,
    'otp': otp,
    'otp_expire_at': otpExpireAt,
    'hobbies': hobbies?.map((e) => e.toJson()).toList(),
    'gotra': gotra?.toJson(),
    'ug_degree': ugDegree,
    'pg_degree': pgDegree,
    'partner_hobbies': partnerHobbies,
    'partner_marital_status': partnerMaritalStatus,
    'partner_gotra': partnerGotra?.toJson(),
    'home_reg_id': homeRegId,
    'app_step': appStep,
    'device_token': deviceToken,
    'form_status': formStatus,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'about': about,
    'birth_state': birthState?.toJson(),
    'dob': dob,
    'gender': gender,
    'marital_status': maritalStatus?.toJson(),
    'name': name,
    'profile_for': profileFor?.toJson(),
    'step': step,
    'contact_email': contactEmail,
    'contact_no': contactNo,
    'facebook': facebook,
    'instagram': instagram,
    'reference': reference,
    'reference_other': referenceOther,
    'caste': caste?.toJson(),
    'dosh': dosh,
    'gotra_other': gotraOther,
    'religion': religion?.toJson(),
    'sub_caste': subCaste?.toJson(),
    'loc_relation': locRelation,
    'loc_relation_email': locRelationEmail,
    'loc_relation_mobile': locRelationMobile,
    'loc_relation_name': locRelationName,
    'loc_city': locCity?.toJson(),
    'loc_house_type': locHouseType,
    'loc_landmark': locLandmark,
    'loc_nationality': locNationality?.toJson(),
    'loc_pincode': locPincode,
    'loc_residence_type': locResidenceType,
    'loc_state': locState?.toJson(),
    'loc_temp_city': locTempCity?.toJson(),
    'loc_temp_landmark': locTempLandmark,
    'loc_temp_pincode': locTempPincode,
    'loc_temp_state': locTempState?.toJson(),
    'family_type': familyType,
    'family_value': familyValue,
    'married_brother': marriedBrother,
    'married_sister': marriedSister,
    'no_of_brother': noOfBrother,
    'no_of_brother_in_law': noOfBrotherInLaw,
    'no_of_sister': noOfSister,
    'no_of_sister_in_law': noOfSisterInLaw,
    'birth_city': birthCity?.toJson(),
    'blood_group': bloodGroup,
    'complexion': complexion?.toJson(),
    'diet': diet?.toJson(),
    'disability': disability,
    'health_information': healthInformation,
    'height': height,
    'manglik': manglik,
    'weight': weight,
    'annual_income': annualIncome,
    'highest_degree': highestDegree?.toJson(),
    'occupation': occupation?.toJson(),
    'organization_name': organizationName,
    'other_education': otherEducation,
    'pg_college_name': pgCollegeName,
    'prev_working_detail': prevWorkingDetail,
    'school_name': schoolName,
    'ug_college_name': ugCollegeName,
    'working_with': workingWith?.toJson(),
    'photo': photo,
    'photo1': photo1,
    'photo2': photo2,
    'photo3': photo3,
    'photo4': photo4,
    'photo_blur': photoBlur,
    'partner_qualities': partnerQualities,
    'partner_caste': partnerCaste?.toJson(),
    'partner_dosh': partnerDosh,
    'partner_religion': partnerReligion?.toJson(),
    'partner_sub_caste': partnerSubCaste?.toJson(),
    'partner_age_from': partnerAgeFrom,
    'partner_age_to': partnerAgeTo,
    'partner_city': partnerCity?.toJson(),
    'partner_complexion': partnerComplexion?.toJson(),
    'partner_country': partnerCountry?.toJson(),
    'partner_diet': partnerDiet?.toJson(),
    'partner_drinking': partnerDrinking,
    'partner_education': partnerEducation?.toJson(),
    'partner_have_children': partnerHaveChildren,
    'partner_height_from': partnerHeightFrom,
    'partner_height_to': partnerHeightTo,
    'partner_income_from': partnerIncomeFrom,
    'partner_income_to': partnerIncomeTo,
    'partner_language': partnerLanguage?.toJson(),
    'partner_managed_by': partnerManagedBy,
    'partner_mother_tongue': partnerMotherTongue?.toJson(),
    'partner_occupation': partnerOccupation?.toJson(),
    'partner_professional_qualification': partnerProfessionalQualification
        ?.toJson(),
    'partner_smoking': partnerSmoking,
    'partner_state': partnerState?.toJson(),
    'partner_weight_from': partnerWeightFrom,
    'partner_weight_to': partnerWeightTo,
    'partner_working_as': partnerWorkingAs?.toJson(),
  };
}

double? parseDouble(dynamic value) {
  if (value == null) return null;

  if (value is double) return value;

  if (value is int) return value.toDouble();

  if (value is String) {
    if (value.trim().isEmpty) return null;
    return double.tryParse(value);
  }

  return null;
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

class Hobby {
  dynamic icon;
  dynamic id;
  dynamic name;
  dynamic status;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic v;

  Hobby({
    this.icon,
    this.id,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      icon: json['icon'] as dynamic,
      id: json['_id'] as dynamic,
      name: json['name'] as dynamic,
      status: json['status'] as dynamic,
      createdAt: json['createdAt'] as dynamic,
      updatedAt: json['updatedAt'] as dynamic,
      v: json['__v'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
    'icon': icon,
    '_id': id,
    'name': name,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}

/// Generic reference model used for religion, caste, city, state, etc.
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

class ProfilePhoneSettingModel {
  final String? id;
  final String? userId;
  final int? mobileVerified;
  final int? privacySetting;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? viewType;

  ProfilePhoneSettingModel({
    this.id,
    this.userId,
    this.mobileVerified,
    this.privacySetting,
    this.createdAt,
    this.updatedAt,
    this.viewType,
  });

  factory ProfilePhoneSettingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProfilePhoneSettingModel(); // ✅ NULL SAFE
    }

    return ProfilePhoneSettingModel(
      id: json['_id']?.toString(),
      userId: json['user_id']?.toString(),
      mobileVerified: _parseInt(json['mobile_verified']),
      privacySetting: _parseInt(json['privacy_setting']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      viewType: _parseInt(json['view_type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'mobile_verified': mobileVerified,
      'privacy_setting': privacySetting,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'view_type': viewType,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

// ---------------- Partner Preferences ----------------

class PartnerPreferences {
  AgePreference? age;
  HeightPreference? height;
  MaritalStatusPreference? maritalStatus;
  ReligionPreference? religion;
  CastePreference? caste;
  MotherTonguePreference? motherTongue;
  EducationPreference? education;
  OccupationPreference? occupation;
  DietPreference? diet;
  CountryPreference? country;
  StatePreference? state;
  CityPreference? city;
  AnnualIncomePreference? annualIncome;
  DisabilityPreferences? disability;
  GotraPreferences? gotra;

  PartnerPreferences({
    this.age,
    this.height,
    this.maritalStatus,
    this.religion,
    this.caste,
    this.motherTongue,
    this.education,
    this.occupation,
    this.diet,
    this.country,
    this.state,
    this.city,
    this.annualIncome,
    this.disability,
    this.gotra,
  });

  factory PartnerPreferences.fromJson(Map<String, dynamic> json) {
    return PartnerPreferences(
      age: safeMap(json['age']) != null
          ? AgePreference.fromJson(safeMap(json['age'])!)
          : null,

      height: safeMap(json['height']) != null
          ? HeightPreference.fromJson(safeMap(json['height'])!)
          : null,

      maritalStatus: safeMap(json['maritalStatus']) != null
          ? MaritalStatusPreference.fromJson(safeMap(json['maritalStatus'])!)
          : null,

      religion: safeMap(json['religion']) != null
          ? ReligionPreference.fromJson(safeMap(json['religion'])!)
          : null,

      caste: safeMap(json['caste']) != null
          ? CastePreference.fromJson(safeMap(json['caste'])!)
          : null,

      // motherTongue may come as ""
      motherTongue: safeMap(json['motherTongue']) != null
          ? MotherTonguePreference.fromJson(safeMap(json['motherTongue'])!)
          : MotherTonguePreference(
              status: false,
              motherTongue: json['motherTongue']?.toString() ?? "",
            ),

      // education sometimes ""
      education: safeMap(json['education']) != null
          ? EducationPreference.fromJson(safeMap(json['education'])!)
          : EducationPreference(
              status: false,
              education: json['education']?.toString() ?? "",
            ),

      occupation: safeMap(json['occupation']) != null
          ? OccupationPreference.fromJson(safeMap(json['occupation'])!)
          : OccupationPreference(
              status: false,
              occupation: RefData(name: json['occupation']?.toString()),
            ),

      diet: safeMap(json['diet']) != null
          ? DietPreference.fromJson(safeMap(json['diet'])!)
          : null,

      country: safeMap(json['country']) != null
          ? CountryPreference.fromJson(safeMap(json['country'])!)
          : null,

      // state was coming as "Bihar"
      state: safeMap(json['state']) != null
          ? StatePreference.fromJson(safeMap(json['state'])!)
          : StatePreference(status: false, state: json['state']?.toString()),

      city: safeMap(json['city']) != null
          ? CityPreference.fromJson(safeMap(json['city'])!)
          : null,

      // annualIncome sometimes ""
      annualIncome: safeMap(json['annualIncome']) != null
          ? AnnualIncomePreference.fromJson(safeMap(json['annualIncome'])!)
          : AnnualIncomePreference(
              status: false,
              annualIncome: json['annualIncome']?.toString() ?? "",
            ),

      // disability sometimes ""
      disability: safeMap(json['disability']) != null
          ? DisabilityPreferences.fromJson(safeMap(json['disability'])!)
          : DisabilityPreferences(
              status: false,
              disibility: json['disability']?.toString() ?? "",
            ),

      // gotra sometimes ""
      gotra: safeMap(json['gotra']) != null
          ? GotraPreferences.fromJson(safeMap(json['gotra'])!)
          : GotraPreferences(
              status: false,
              gotra: json['gotra']?.toString() ?? "",
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    'age': age?.toJson(),
    'height': height?.toJson(),
    'maritalStatus': maritalStatus?.toJson(),
    'religion': religion?.toJson(),
    'caste': caste?.toJson(),
    'motherTongue': motherTongue?.toJson(),
    'education': education?.toJson(),
    'occupation': occupation?.toJson(),
    'diet': diet?.toJson(),
    'country': country?.toJson(),
    'state': state?.toJson(),
    'city': city?.toJson(),
    'annualIncome': annualIncome?.toJson(),
    'disibility': disability?.toJson(),
    'gotra': gotra?.toJson(),
  };
}

class AgePreference {
  dynamic age;
  bool? status;

  AgePreference({this.age, this.status});

  factory AgePreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return AgePreference(age: json?.toString(), status: false);
    }

    return AgePreference(
      age: map['age']?.toString(),
      status: map['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {'age': age, 'status': status};
}

class HeightPreference {
  double? height;
  bool? status;

  HeightPreference({this.height, this.status});

  factory HeightPreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return HeightPreference(
        height: double.tryParse(json?.toString() ?? ''),
        status: false,
      );
    }

    return HeightPreference(
      height: parseDouble(map['height']),
      status: map['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {'height': height, 'status': status};
}

class AnnualIncomePreference {
  dynamic annualIncome;
  bool? status;

  AnnualIncomePreference({this.annualIncome, this.status});

  factory AnnualIncomePreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return AnnualIncomePreference(
        annualIncome: json?.toString(),
        status: false,
      );
    }

    return AnnualIncomePreference(
      annualIncome: map['annualIncome']?.toString(),
      status: map['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'annualIncome': annualIncome,
    'status': status,
  };
}

class DisabilityPreferences {
  dynamic disibility;
  bool? status;

  DisabilityPreferences({this.disibility, this.status});

  factory DisabilityPreferences.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return DisabilityPreferences(disibility: json?.toString(), status: false);
    }

    return DisabilityPreferences(
      disibility: map['disibility']?.toString(),
      status: map['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {'disibility': disibility, 'status': status};
}

class GotraPreferences {
  dynamic gotra;
  bool? status;

  GotraPreferences({this.gotra, this.status});

  factory GotraPreferences.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return GotraPreferences(gotra: json?.toString(), status: false);
    }

    return GotraPreferences(
      gotra: map['gotra']?.toString(),
      status: map['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {'gotra': gotra, 'status': status};
}

class MaritalStatusPreference {
  bool? status;
  RefData? maritalStatus;

  MaritalStatusPreference({this.status, this.maritalStatus});

  factory MaritalStatusPreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return MaritalStatusPreference(
        status: false,
        maritalStatus: RefData(name: json?.toString()),
      );
    }

    return MaritalStatusPreference(
      status: map['status'] as bool?,
      maritalStatus: safeMap(map['maritalStatus']) != null
          ? RefData.fromJson(map['maritalStatus'])
          : RefData(name: map['maritalStatus']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'maritalStatus': maritalStatus?.toJson(),
  };
}

class ReligionPreference {
  bool? status;
  RefData? religion;

  ReligionPreference({this.status, this.religion});

  factory ReligionPreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return ReligionPreference(
        status: false,
        religion: RefData(name: json?.toString()),
      );
    }

    return ReligionPreference(
      status: map['status'] as bool?,
      religion: safeMap(map['religion']) != null
          ? RefData.fromJson(map['religion'])
          : RefData(name: map['religion']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'religion': religion?.toJson(),
  };
}

class CastePreference {
  bool? status;
  RefData? caste;

  CastePreference({this.status, this.caste});

  factory CastePreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return CastePreference(
        status: false,
        caste: RefData(name: json?.toString()),
      );
    }

    return CastePreference(
      status: map['status'] as bool?,
      caste: safeMap(map['caste']) != null
          ? RefData.fromJson(map['caste'])
          : RefData(name: map['caste']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'caste': caste?.toJson()};
}

class MotherTonguePreference {
  bool? status;
  dynamic motherTongue;

  MotherTonguePreference({this.status, this.motherTongue});

  factory MotherTonguePreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return MotherTonguePreference(
        status: false,
        motherTongue: json?.toString(),
      );
    }

    return MotherTonguePreference(
      status: map['status'] as bool?,
      motherTongue: map['motherTongue']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'motherTongue': motherTongue,
  };
}

class EducationPreference {
  bool? status;
  dynamic education;

  EducationPreference({this.status, this.education});

  factory EducationPreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return EducationPreference(status: false, education: json?.toString());
    }

    return EducationPreference(
      status: map['status'] as bool?,
      education: map['education']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'education': education};
}

class OccupationPreference {
  bool? status;
  RefData? occupation;

  OccupationPreference({this.status, this.occupation});

  factory OccupationPreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return OccupationPreference(
        status: false,
        occupation: RefData(name: json?.toString()),
      );
    }

    return OccupationPreference(
      status: map['status'] as bool?,
      occupation: safeMap(map['occupation']) != null
          ? RefData.fromJson(map['occupation'])
          : RefData(name: map['occupation']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'occupation': occupation?.toJson(),
  };
}

class DietPreference {
  bool? status;
  RefData? diet;

  DietPreference({this.status, this.diet});

  factory DietPreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return DietPreference(
        status: false,
        diet: RefData(name: json?.toString()),
      );
    }

    return DietPreference(
      status: map['status'] as bool?,
      diet: safeMap(map['diet']) != null
          ? RefData.fromJson(map['diet'])
          : RefData(name: map['diet']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'diet': diet?.toJson()};
}

class CountryPreference {
  bool? status;
  RefData? country;

  CountryPreference({this.status, this.country});

  factory CountryPreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return CountryPreference(
        status: false,
        country: RefData(name: json?.toString()),
      );
    }

    return CountryPreference(
      status: map['status'] as bool?,
      country: safeMap(map['country']) != null
          ? RefData.fromJson(map['country'])
          : RefData(name: map['country']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'country': country?.toJson(),
  };
}

class StatePreference {
  bool? status;
  dynamic state;

  StatePreference({this.status, this.state});

  factory StatePreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return StatePreference(status: false, state: json?.toString());
    }

    return StatePreference(
      status: map['status'] as bool?,
      state: map['state']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'state': state};
}

class CityPreference {
  bool? status;
  RefData? city;

  CityPreference({this.status, this.city});

  factory CityPreference.fromJson(dynamic json) {
    final map = safeMap(json);
    if (map == null) {
      return CityPreference(
        status: false,
        city: RefData(name: json?.toString()),
      );
    }

    return CityPreference(
      status: map['status'] as bool?,
      city: safeMap(map['city']) != null
          ? RefData.fromJson(map['city'])
          : RefData(name: map['city']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'city': city?.toJson()};
}
