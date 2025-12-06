

T? safeCast<T>(dynamic value) => value is T ? value : null;

String? safeString(dynamic value) => value == null ? null : value.toString();

int? safeInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? safeDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

DateTime? safeDate(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return null;
  }
}

bool? safeBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  final v = value.toString().toLowerCase();
  return (v == "true" || v == "1");
}

LookupModel? safeLookup(dynamic value) => (value is Map)
    ? LookupModel.fromJson(Map<String, dynamic>.from(value))
    : null;

PlanDetail? safePlan(dynamic value) => (value is Map)
    ? PlanDetail.fromJson(Map<String, dynamic>.from(value))
    : null;

// ---------- Root Model ----------

class UserDetailAllModel {
  final bool status;
  final List<UserData> data;

  UserDetailAllModel({required this.status, required this.data});

  factory UserDetailAllModel.fromJson(Map<String, dynamic> json) {
    return UserDetailAllModel(
      status: safeBool(json['status']) ?? false,
      data: (json['data'] as List? ?? [])
          .map((e) => UserData.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

// ---------- User Data ----------

class UserData {
  String? id;
  String? profileId;
  String? email;
  String? mobile;
  String? otp;
  DateTime? otpExpireAt;
  List<Hobby> hobbies;
  LookupModel? gotra;
  String? ugDegree;
  String? pgDegree;
  List<String> partnerHobbies;
  List<PartnerMaritalStatusItem> partnerMaritalStatus;
  LookupModel? partnerGotra;
  String? homeRegId;
  dynamic appStep;
  String? deviceToken;
  String? formStatus;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic v;
  String? about;
  LookupModel? birthState;
  DateTime? dob;
  String? gender;
  LookupModel? maritalStatus;
  String? name;
  LookupModel? profileFor;
  dynamic step;
  String? contactEmail;
  String? contactNo;
  String? facebook;
  String? instagram;
  String? reference;
  String? referenceOther;
  LookupModel? caste;
  String? dosh;
  String? gotraOther;
  LookupModel? religion;
  LookupModel? subCaste;
  String? locRelation;
  String? locRelationEmail;
  String? locRelationMobile;
  String? locRelationName;
  LookupModel? locCity;
  String? locHouseType;
  String? locLandmark;
  LookupModel? locNationality;
  String? locPincode;
  String? locResidenceType;
  LookupModel? locState;
  LookupModel? locTempCity;
  String? locTempLandmark;
  String? locTempPincode;
  LookupModel? locTempState;
  String? familyType;
  String? familyValue;
  dynamic marriedBrother;
  dynamic marriedSister;
  dynamic noOfBrother;
  dynamic noOfBrotherInLaw;
  dynamic noOfSister;
  dynamic noOfSisterInLaw;
  LookupModel? birthCity;
  String? bloodGroup;
  LookupModel? complexion;
  LookupModel? diet;
  String? disability;
  String? healthInformation;
  dynamic height;
  String? manglik;
  dynamic weight;
  String? annualIncome;
  LookupModel? highestDegree;
  LookupModel? occupation;
  String? organizationName;
  String? otherEducation;
  String? pgCollegeName;
  String? prevWorkingDetail;
  String? schoolName;
  String? ugCollegeName;
  LookupModel? workingWith;
  String? photo;
  String? photoBlur;
  String? photo1;
  String? photo1Blur;
  String? photo2;
  String? photo3;
  String? photo4;
  String? photo2Blur;
  String? partnerQualities;
  dynamic partnerAgeFrom;
  dynamic partnerAgeTo;
  LookupModel? partnerComplexion;
  String? partnerHaveChildren;
  dynamic partnerHeightFrom;
  dynamic partnerHeightTo;
  LookupModel? partnerLanguage;
  LookupModel? partnerMotherTongue;
  dynamic partnerWeightFrom;
  dynamic partnerWeightTo;
  String? partnerFamilyType;
  String? partnerFamilyValue;
  LookupModel? partnerCity;
  LookupModel? partnerCountry;
  LookupModel? partnerState;
  LookupModel? partnerEducation;
  String? partnerIncomeFrom;
  String? partnerIncomeTo;
  LookupModel? partnerOccupation;
  LookupModel? partnerProfessionalQualification;
  LookupModel? partnerWorkingAs;
  LookupModel? partnerCaste;
  String? partnerDosh;
  LookupModel? partnerReligion;
  LookupModel? partnerSubCaste;
  LookupModel? partnerDiet;
  String? partnerDrinking;
  String? partnerManagedBy;
  String? partnerSmoking;
  bool? interestSent;
  PlanDetail? planDetail;
  dynamic interestUser;
  dynamic totalUserView;
  dynamic totalRecentUserView;
  dynamic acceptedInvitation;
  dynamic receivedInvitation;

  UserData({
    this.id,
    this.profileId,
    this.email,
    this.mobile,
    this.otp,
    this.otpExpireAt,
    this.hobbies = const [],
    this.gotra,
    this.ugDegree,
    this.pgDegree,
    this.partnerHobbies = const [],
    this.partnerMaritalStatus = const [],
    this.partnerGotra,
    this.homeRegId,
    this.appStep,
    this.deviceToken,
    this.formStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
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
    this.gotraOther,
    this.religion,
    this.subCaste,
    this.locRelation,
    this.locRelationEmail,
    this.locRelationMobile,
    this.locRelationName,
    this.locCity,
    this.locHouseType,
    this.locLandmark,
    this.locNationality,
    this.locPincode,
    this.locResidenceType,
    this.locState,
    this.locTempCity,
    this.locTempLandmark,
    this.locTempPincode,
    this.locTempState,
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
    this.photoBlur,
    this.photo1,
    this.photo1Blur,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photo2Blur,
    this.partnerQualities,
    this.partnerAgeFrom,
    this.partnerAgeTo,
    this.partnerComplexion,
    this.partnerHaveChildren,
    this.partnerHeightFrom,
    this.partnerHeightTo,
    this.partnerLanguage,
    this.partnerMotherTongue,
    this.partnerWeightFrom,
    this.partnerWeightTo,
    this.partnerFamilyType,
    this.partnerFamilyValue,
    this.partnerCity,
    this.partnerCountry,
    this.partnerState,
    this.partnerEducation,
    this.partnerIncomeFrom,
    this.partnerIncomeTo,
    this.partnerOccupation,
    this.partnerProfessionalQualification,
    this.partnerWorkingAs,
    this.partnerCaste,
    this.partnerDosh,
    this.partnerReligion,
    this.partnerSubCaste,
    this.partnerDiet,
    this.partnerDrinking,
    this.partnerManagedBy,
    this.partnerSmoking,
    this.interestSent,
    this.planDetail,
    this.interestUser,
    this.totalUserView,
    this.totalRecentUserView,
    this.acceptedInvitation,
    this.receivedInvitation,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: safeString(json['_id']) ?? "N/A",
      profileId: safeString(json['profile_id']) ?? "N/A",
      email: safeString(json['email']) ?? "N/A",
      mobile: safeString(json['mobile']) ?? "N/A",
      otp: safeString(json['otp']) ?? "N/A",

      otpExpireAt: safeDate(
        json['otp_expire_at'],
      ), // DateTime hai, isko string me convert karte waqt N/A

      hobbies: (json['hobbies'] as List? ?? [])
          .map((e) => Hobby.fromJson(Map<String, dynamic>.from(e)))
          .toList(),

      gotra: safeLookup(json['gotra']),
      ugDegree: safeString(json['ug_degree']) ?? "N/A",
      pgDegree: safeString(json['pg_degree']) ?? "N/A",

      partnerHobbies: (json['partner_hobbies'] as List? ?? [])
          .map((e) => e?.toString().isEmpty ?? true ? "N/A" : e.toString())
          .toList(),

      partnerMaritalStatus: (json['partner_marital_status'] as List? ?? [])
          .map(
            (e) =>
                PartnerMaritalStatusItem.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),

      partnerGotra: safeLookup(json['partner_gotra']),
      homeRegId: safeString(json['home_reg_id']),
      appStep: safeInt(json['app_step']),
      deviceToken: safeString(json['device_token']),
      formStatus: safeString(json['form_status']),
      status: safeString(json['status']),
      createdAt: safeDate(json['createdAt']),
      updatedAt: safeDate(json['updatedAt']),
      v: safeInt(json['__v']),
      about: safeString(json['about']),

      birthState: safeLookup(json['birth_state']),
      dob: safeDate(json['dob']),
      gender: safeString(json['gender']),
      maritalStatus: safeLookup(json['marital_status']),
      name: safeString(json['name']),
      profileFor: safeLookup(json['profile_for']),
      step: safeInt(json['step']),
      contactEmail: safeString(json['contact_email']),
      contactNo: safeString(json['contact_no']),
      facebook: safeString(json['facebook']),
      instagram: safeString(json['instagram']),
      reference: safeString(json['reference']),
      referenceOther: safeString(json['reference_other']),
      caste: safeLookup(json['caste']),
      dosh: safeString(json['dosh']),
      gotraOther: safeString(json['gotra_other']),
      religion: safeLookup(json['religion']),
      subCaste: safeLookup(json['sub_caste']),

      locRelation: safeString(json['loc_relation']),
      locRelationEmail: safeString(json['loc_relation_email']),
      locRelationMobile: safeString(json['loc_relation_mobile']),
      locRelationName: safeString(json['loc_relation_name']),
      locCity: safeLookup(json['loc_city']),
      locHouseType: safeString(json['loc_house_type']),
      locLandmark: safeString(json['loc_landmark']),
      locNationality: safeLookup(json['loc_nationality']),
      locPincode: safeString(json['loc_pincode']),
      locResidenceType: safeString(json['loc_residence_type']),
      locState: safeLookup(json['loc_state']),
      locTempCity: safeLookup(json['loc_temp_city']),
      locTempLandmark: safeString(json['loc_temp_landmark']),
      locTempPincode: safeString(json['loc_temp_pincode']),
      locTempState: safeLookup(json['loc_temp_state']),

      familyType: safeString(json['family_type']),
      familyValue: safeString(json['family_value']),

      marriedBrother: safeInt(json['married_brother']),
      marriedSister: safeInt(json['married_sister']),
      noOfBrother: safeInt(json['no_of_brother']),
      noOfBrotherInLaw: safeInt(json['no_of_brother_in_law']),
      noOfSister: safeInt(json['no_of_sister']),
      noOfSisterInLaw: safeInt(json['no_of_sister_in_law']),

      birthCity: safeLookup(json['birth_city']),
      bloodGroup: safeString(json['blood_group']),
      complexion: safeLookup(json['complexion']),
      diet: safeLookup(json['diet']),
      disability: safeString(json['disability']),
      healthInformation: safeString(json['health_information']),
      height: safeDouble(json['height']),
      manglik: safeString(json['manglik']),
      weight: safeDouble(json['weight']),

      annualIncome: safeString(json['annual_income']),
      highestDegree: safeLookup(json['highest_degree']),
      occupation: safeLookup(json['occupation']),
      organizationName: safeString(json['organization_name']),
      otherEducation: safeString(json['other_education']),
      pgCollegeName: safeString(json['pg_college_name']),
      prevWorkingDetail: safeString(json['prev_working_detail']),
      schoolName: safeString(json['school_name']),
      ugCollegeName: safeString(json['ug_college_name']),
      workingWith: safeLookup(json['working_with']),

      photo: safeString(json['photo']),
      photoBlur: safeString(json['photo_blur']),
      photo1: safeString(json['photo1']),
      photo1Blur: safeString(json['photo1_blur']),
      photo2: safeString(json['photo2']),
      photo3: safeString(json['photo3']),
      photo4: safeString(json['photo4']),
      photo2Blur: safeString(json['photo2_blur']),

      partnerQualities: safeString(json['partner_qualities']),
      partnerAgeFrom: safeInt(json['partner_age_from']),
      partnerAgeTo: safeInt(json['partner_age_to']),
      partnerComplexion: safeLookup(json['partner_complexion']),
      partnerHaveChildren: safeString(json['partner_have_children']),
      partnerHeightFrom: safeDouble(json['partner_height_from']),
      partnerHeightTo: safeDouble(json['partner_height_to']),
      partnerLanguage: safeLookup(json['partner_language']),
      partnerMotherTongue: safeLookup(json['partner_mother_tongue']),
      partnerWeightFrom: safeInt(json['partner_weight_from']),
      partnerWeightTo: safeInt(json['partner_weight_to']),
      partnerFamilyType: safeString(json['partner_family_type']),
      partnerFamilyValue: safeString(json['partner_family_value']),
      partnerCity: safeLookup(json['partner_city']),
      partnerCountry: safeLookup(json['partner_country']),
      partnerState: safeLookup(json['partner_state']),
      partnerEducation: safeLookup(json['partner_education']),
      partnerIncomeFrom: safeString(json['partner_income_from']),
      partnerIncomeTo: safeString(json['partner_income_to']),
      partnerOccupation: safeLookup(json['partner_occupation']),
      partnerProfessionalQualification: safeLookup(
        json['partner_professional_qualification'],
      ),
      partnerWorkingAs: safeLookup(json['partner_working_as']),
      partnerCaste: safeLookup(json['partner_caste']),
      partnerDosh: safeString(json['partner_dosh']),
      partnerReligion: safeLookup(json['partner_religion']),
      partnerSubCaste: safeLookup(json['partner_sub_caste']),
      partnerDiet: safeLookup(json['partner_diet']),
      partnerDrinking: safeString(json['partner_drinking']),
      partnerManagedBy: safeString(json['partner_managed_by']),
      partnerSmoking: safeString(json['partner_smoking']),

      interestSent: safeBool(json['interest_sent']),
      planDetail: safePlan(json['plan_detail']),

      interestUser: safeInt(json['interest_user']),
      totalUserView: safeInt(json['total_user_view']),
      totalRecentUserView: safeInt(json['totalRecentUserView']),
      acceptedInvitation: safeInt(json['accepted_invitation']),
      receivedInvitation: safeInt(json['receivedInvitation']),
    );
  }
}

// ---------- Hobby ----------

class Hobby {
  String? id;
  String? icon;
  String? name;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Hobby({
    this.id,
    this.icon,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Hobby.fromJson(Map<String, dynamic> json) {
    return Hobby(
      id: safeString(json['_id']),
      icon: safeString(json['icon']),
      name: safeString(json['name']),
      status: safeString(json['status']),
      createdAt: safeDate(json['createdAt']),
      updatedAt: safeDate(json['updatedAt']),
      v: safeInt(json['__v']),
    );
  }
}

// ---------- LookupModel ----------

class LookupModel {
  String? id;
  String? name;
  String? religionId;
  String? casteId;
  String? countryId;
  String? stateId;
  int? educationType;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  LookupModel({
    this.id,
    this.name,
    this.religionId,
    this.casteId,
    this.countryId,
    this.stateId,
    this.educationType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory LookupModel.fromJson(Map<String, dynamic> json) {
    return LookupModel(
      id: safeString(json['_id']),
      name: safeString(json['name']),
      religionId: safeString(json['religion_id']),
      casteId: safeString(json['caste_id']),
      countryId: safeString(json['country_id']),
      stateId: safeString(json['state_id']),
      educationType: safeInt(json['education_type']),
      status: safeString(json['status']),
      createdAt: safeDate(json['createdAt']),
      updatedAt: safeDate(json['updatedAt']),
      v: safeInt(json['__v']),
    );
  }
}

// ---------- PlanDetail ----------

class PlanDetail {
  String? id;
  String? userId;
  PlanId? planId;
  int? price;
  DateTime? startDate;
  DateTime? expiryDate;
  String? status;
  String? advanceSearch;
  String? chat;
  String? matchSuggestions;
  String? profileHighlight;
  String? profileView;
  String? viewContact;
  String? voiceVideo;
  String? sendInterest;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PlanDetail({
    this.id,
    this.userId,
    this.planId,
    this.price,
    this.startDate,
    this.expiryDate,
    this.status,
    this.advanceSearch,
    this.chat,
    this.matchSuggestions,
    this.profileHighlight,
    this.profileView,
    this.viewContact,
    this.voiceVideo,
    this.sendInterest,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory PlanDetail.fromJson(Map<String, dynamic> json) {
    return PlanDetail(
      id: safeString(json['_id']),
      userId: safeString(json['user_id']),
      planId: (json['plan_id'] is Map)
          ? PlanId.fromJson(json['plan_id'])
          : null,
      price: safeInt(json['price']),
      startDate: safeDate(json['start_date']),
      expiryDate: safeDate(json['expiry_date']),
      status: safeString(json['status']),
      advanceSearch: safeString(json['advance_search']),
      chat: safeString(json['chat']),
      matchSuggestions: safeString(json['match_suggestions']),
      profileHighlight: safeString(json['profile_highlight']),
      profileView: safeString(json['profile_view']),
      viewContact: safeString(json['view_contact']),
      voiceVideo: safeString(json['voice_video']),
      sendInterest: safeString(json['send_interest']),
      createdAt: safeDate(json['createdAt']),
      updatedAt: safeDate(json['updatedAt']),
      v: safeInt(json['__v']),
    );
  }
}

// ---------- PlanId ----------

class PlanId {
  String? id;
  String? name;
  int? price;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? advanceSearch;
  String? chat;
  String? matchSuggestions;
  String? profileHighlight;
  String? profileView;
  String? viewContact;
  String? voiceVideo;
  String? sendInterest;

  PlanId({
    this.id,
    this.name,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.advanceSearch,
    this.chat,
    this.matchSuggestions,
    this.profileHighlight,
    this.profileView,
    this.viewContact,
    this.voiceVideo,
    this.sendInterest,
  });

  factory PlanId.fromJson(Map<String, dynamic> json) {
    return PlanId(
      id: safeString(json['_id']),
      name: safeString(json['name']),
      price: safeInt(json['price']),
      status: safeString(json['status']),
      createdAt: safeDate(json['createdAt']),
      updatedAt: safeDate(json['updatedAt']),
      v: safeInt(json['__v']),
      advanceSearch: safeString(json['advance_search']),
      chat: safeString(json['chat']),
      matchSuggestions: safeString(json['match_suggestions']),
      profileHighlight: safeString(json['profile_highlight']),
      profileView: safeString(json['profile_view']),
      viewContact: safeString(json['view_contact']),
      voiceVideo: safeString(json['voice_video']),
      sendInterest: safeString(json['send_interest']),
    );
  }
}

class PartnerMaritalStatusItem {
  final String id;
  final String name;

  PartnerMaritalStatusItem({required this.id, required this.name});

  factory PartnerMaritalStatusItem.fromJson(Map<String, dynamic> json) {
    return PartnerMaritalStatusItem(
      id: json['_id']?.toString() ?? "N/A",
      name: json['name']?.toString() ?? "N/A",
    );
  }
}
