// class UserDetailAllModel {
//   final bool? status;
//   final List<UserData>? data;

//   UserDetailAllModel({this.status, this.data});

//   factory UserDetailAllModel.fromJson(Map<String, dynamic> json) {
//     return UserDetailAllModel(
//       status: json["status"],
//       data: json["data"] == null
//           ? []
//           : List<UserData>.from(json["data"].map((x) => UserData.fromJson(x))),
//     );
//   }
// }

// class UserData {
//   final String? id;
//   final String? email;
//   final String? mobile;
//   final String? name;
//   final String? otp;
//   final String? otpExpireAt;
//   final List<dynamic>? hobbies;
//   final dynamic gotra;
//   final dynamic ugDegree;
//   final dynamic pgDegree;
//   final List<dynamic>? partnerHobbies;
//   final List<dynamic>? partnerMaritalStatus;
//   final dynamic partnerGotra;
//   final dynamic homeRegId;
//   final dynamic appStep;
//   final String? deviceToken;
//   final String? formStatus;
//   final String? status;
//   final String? createdAt;
//   final String? updatedAt;
//   final bool? interestSent;
//   final bool? planDetail;
//   final dynamic interestUser;
//   final dynamic totalUserView;
//   final int? totalRecentUserView;
//   final dynamic receivedInvitation;
//   final dynamic acceptedinvitation;
//   final dynamic interestuser;

//   UserData({
//     this.id,
//     this.email,
//     this.mobile,
//     this.otp,
//     this.name,
//     this.otpExpireAt,
//     this.hobbies,
//     this.gotra,
//     this.ugDegree,
//     this.pgDegree,
//     this.partnerHobbies,
//     this.partnerMaritalStatus,
//     this.partnerGotra,
//     this.homeRegId,
//     this.appStep,
//     this.deviceToken,
//     this.formStatus,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.interestSent,
//     this.planDetail,
//     this.interestUser,
//     this.totalUserView,
//     this.totalRecentUserView,
//     this.receivedInvitation,
//     this.acceptedinvitation,
//     this.interestuser,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) {
//     return UserData(
//       id: json["_id"],
//       email: json["email"] ?? "",
//       mobile: json["mobile"] ?? "",
//       name: json['name'] ?? "",
//       otp: json["otp"],
//       otpExpireAt: json["otp_expire_at"],
//       hobbies: json["hobbies"] ?? [],
//       gotra: json["gotra"],
//       ugDegree: json["ug_degree"],
//       pgDegree: json["pg_degree"],
//       partnerHobbies: json["partner_hobbies"] ?? [],
//       partnerMaritalStatus: json["partner_marital_status"] ?? [],
//       partnerGotra: json["partner_gotra"],
//       homeRegId: json["home_reg_id"],
//       appStep: json["app_step"],
//       deviceToken: json["device_token"],
//       formStatus: json["form_status"],
//       status: json["status"],
//       createdAt: json["createdAt"],
//       updatedAt: json["updatedAt"],
//       interestSent: json["interest_sent"],
//       planDetail: json["plan_detail"],
//       interestUser: json["interest_user"],
//       totalUserView: json["total_user_view"],
//       totalRecentUserView: json["totalRecentUserView"],
//       receivedInvitation: json['receivedInvitation'] ?? 0,
//       acceptedinvitation: json['accepted_invitation'] ?? 0,
//       interestuser: json['interest_user'] ?? 0,
//     );
//   }
// }
// profile_response_model.dart

/// Top-level response model
class UserDetailAllModel {
  final bool status;
  final List<UserData> data;

  UserDetailAllModel({required this.status, required this.data});

  factory UserDetailAllModel.fromJson(Map<String, dynamic> json) {
    return UserDetailAllModel(
      status: _parseBool(json['status']) ?? false,
      data: (json['data'] as List? ?? [])
          .map((e) => UserData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.map((e) => e.toJson()).toList()};
  }
}

/// Main profile data model
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
  List<String> partnerMaritalStatus;
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
  double? height;
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
      id: json['_id']?.toString(),
      profileId: json['profile_id']?.toString(),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
      otp: json['otp']?.toString(),
      otpExpireAt: _parseDateTime(json['otp_expire_at']),
      hobbies: (json['hobbies'] as List? ?? [])
          .map((e) => Hobby.fromJson(e as Map<String, dynamic>))
          .toList(),
      gotra: json['gotra'] != null
          ? LookupModel.fromJson(json['gotra'] as Map<String, dynamic>)
          : null,
      ugDegree: json['ug_degree']?.toString(),
      pgDegree: json['pg_degree']?.toString(),
      partnerHobbies: (json['partner_hobbies'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      partnerMaritalStatus: (json['partner_marital_status'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      partnerGotra: json['partner_gotra'] != null
          ? LookupModel.fromJson(json['partner_gotra'] as Map<String, dynamic>)
          : null,
      homeRegId: json['home_reg_id']?.toString(),
      appStep: _parseInt(json['app_step']),
      deviceToken: json['device_token']?.toString(),
      formStatus: json['form_status']?.toString(),
      status: json['status']?.toString(),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      v: _parseInt(json['__v']),
      about: json['about']?.toString(),
      birthState: json['birth_state'] != null
          ? LookupModel.fromJson(json['birth_state'] as Map<String, dynamic>)
          : null,
      dob: _parseDateTime(json['dob']),
      gender: json['gender']?.toString(),
      maritalStatus: json['marital_status'] != null
          ? LookupModel.fromJson(json['marital_status'] as Map<String, dynamic>)
          : null,
      name: json['name']?.toString(),
      profileFor: json['profile_for'] != null
          ? LookupModel.fromJson(json['profile_for'] as Map<String, dynamic>)
          : null,
      step: _parseInt(json['step']),
      contactEmail: json['contact_email']?.toString(),
      contactNo: json['contact_no']?.toString(),
      facebook: json['facebook']?.toString(),
      instagram: json['instagram']?.toString(),
      reference: json['reference']?.toString(),
      referenceOther: json['reference_other']?.toString(),
      caste: json['caste'] != null
          ? LookupModel.fromJson(json['caste'] as Map<String, dynamic>)
          : null,
      dosh: json['dosh']?.toString(),
      gotraOther: json['gotra_other']?.toString(),
      religion: json['religion'] != null
          ? LookupModel.fromJson(json['religion'] as Map<String, dynamic>)
          : null,
      subCaste: json['sub_caste'] != null
          ? LookupModel.fromJson(json['sub_caste'] as Map<String, dynamic>)
          : null,
      locRelation: json['loc_relation']?.toString(),
      locRelationEmail: json['loc_relation_email']?.toString(),
      locRelationMobile: json['loc_relation_mobile']?.toString(),
      locRelationName: json['loc_relation_name']?.toString(),
      locCity: json['loc_city'] != null
          ? LookupModel.fromJson(json['loc_city'] as Map<String, dynamic>)
          : null,
      locHouseType: json['loc_house_type']?.toString(),
      locLandmark: json['loc_landmark']?.toString(),
      locNationality: json['loc_nationality'] != null
          ? LookupModel.fromJson(
              json['loc_nationality'] as Map<String, dynamic>,
            )
          : null,
      locPincode: json['loc_pincode']?.toString(),
      locResidenceType: json['loc_residence_type']?.toString(),
      locState: json['loc_state'] != null
          ? LookupModel.fromJson(json['loc_state'] as Map<String, dynamic>)
          : null,
      locTempCity: json['loc_temp_city'] != null
          ? LookupModel.fromJson(json['loc_temp_city'] as Map<String, dynamic>)
          : null,
      locTempLandmark: json['loc_temp_landmark']?.toString(),
      locTempPincode: json['loc_temp_pincode']?.toString(),
      locTempState: json['loc_temp_state'] != null
          ? LookupModel.fromJson(json['loc_temp_state'] as Map<String, dynamic>)
          : null,
      familyType: json['family_type']?.toString(),
      familyValue: json['family_value']?.toString(),
      marriedBrother: _parseInt(json['married_brother']),
      marriedSister: _parseInt(json['married_sister']),
      noOfBrother: _parseInt(json['no_of_brother']),
      noOfBrotherInLaw: _parseInt(json['no_of_brother_in_law']),
      noOfSister: _parseInt(json['no_of_sister']),
      noOfSisterInLaw: _parseInt(json['no_of_sister_in_law']),
      birthCity: json['birth_city'] != null
          ? LookupModel.fromJson(json['birth_city'] as Map<String, dynamic>)
          : null,
      bloodGroup: json['blood_group']?.toString(),
      complexion: json['complexion'] != null
          ? LookupModel.fromJson(json['complexion'] as Map<String, dynamic>)
          : null,
      diet: json['diet'] != null
          ? LookupModel.fromJson(json['diet'] as Map<String, dynamic>)
          : null,
      disability: json['disability']?.toString(),
      healthInformation: json['health_information']?.toString(),
      height: _parseDouble(json['height']),
      manglik: json['manglik']?.toString(),
      weight: json['weight'] is num
          ? (json['weight'] as num)
          : _parseInt(json['weight']),
      annualIncome: json['annual_income']?.toString(),
      highestDegree: json['highest_degree'] != null
          ? LookupModel.fromJson(json['highest_degree'] as Map<String, dynamic>)
          : null,
      occupation: json['occupation'] != null
          ? LookupModel.fromJson(json['occupation'] as Map<String, dynamic>)
          : null,
      organizationName: json['organization_name']?.toString(),
      otherEducation: json['other_education']?.toString(),
      pgCollegeName: json['pg_college_name']?.toString(),
      prevWorkingDetail: json['prev_working_detail']?.toString(),
      schoolName: json['school_name']?.toString(),
      ugCollegeName: json['ug_college_name']?.toString(),
      workingWith: json['working_with'] != null
          ? LookupModel.fromJson(json['working_with'] as Map<String, dynamic>)
          : null,
      photo: json['photo']?.toString(),
      photoBlur: json['photo_blur']?.toString(),
      photo1: json['photo1']?.toString(),
      photo1Blur: json['photo1_blur']?.toString(),
      photo2: json['photo2']?.toString(),
      photo3: json['photo3']?.toString(),
      photo4: json['photo4']?.toString(),
      photo2Blur: json['photo2_blur']?.toString(),
      partnerQualities: json['partner_qualities']?.toString(),
      partnerAgeFrom: _parseInt(json['partner_age_from']),
      partnerAgeTo: _parseInt(json['partner_age_to']),
      partnerComplexion: json['partner_complexion'] != null
          ? LookupModel.fromJson(
              json['partner_complexion'] as Map<String, dynamic>,
            )
          : null,
      partnerHaveChildren: json['partner_have_children']?.toString(),
      partnerHeightFrom: _parseDouble(json['partner_height_from']),
      partnerHeightTo: _parseDouble(json['partner_height_to']),
      partnerLanguage: json['partner_language'] != null
          ? LookupModel.fromJson(
              json['partner_language'] as Map<String, dynamic>,
            )
          : null,
      partnerMotherTongue: json['partner_mother_tongue'] != null
          ? LookupModel.fromJson(
              json['partner_mother_tongue'] as Map<String, dynamic>,
            )
          : null,
      partnerWeightFrom: _parseInt(json['partner_weight_from']),
      partnerWeightTo: _parseInt(json['partner_weight_to']),
      partnerFamilyType: json['partner_family_type']?.toString(),
      partnerFamilyValue: json['partner_family_value']?.toString(),
      partnerCity: json['partner_city'] != null
          ? LookupModel.fromJson(json['partner_city'] as Map<String, dynamic>)
          : null,
      partnerCountry: json['partner_country'] != null
          ? LookupModel.fromJson(
              json['partner_country'] as Map<String, dynamic>,
            )
          : null,
      partnerState: json['partner_state'] != null
          ? LookupModel.fromJson(json['partner_state'] as Map<String, dynamic>)
          : null,
      partnerEducation: json['partner_education'] != null
          ? LookupModel.fromJson(
              json['partner_education'] as Map<String, dynamic>,
            )
          : null,
      partnerIncomeFrom: json['partner_income_from']?.toString(),
      partnerIncomeTo: json['partner_income_to']?.toString(),
      partnerOccupation: json['partner_occupation'] != null
          ? LookupModel.fromJson(
              json['partner_occupation'] as Map<String, dynamic>,
            )
          : null,
      partnerProfessionalQualification:
          json['partner_professional_qualification'] != null
          ? LookupModel.fromJson(
              json['partner_professional_qualification']
                  as Map<String, dynamic>,
            )
          : null,
      partnerWorkingAs: json['partner_working_as'] != null
          ? LookupModel.fromJson(
              json['partner_working_as'] as Map<String, dynamic>,
            )
          : null,
      partnerCaste: json['partner_caste'] != null
          ? LookupModel.fromJson(json['partner_caste'] as Map<String, dynamic>)
          : null,
      partnerDosh: json['partner_dosh']?.toString(),
      partnerReligion: json['partner_religion'] != null
          ? LookupModel.fromJson(
              json['partner_religion'] as Map<String, dynamic>,
            )
          : null,
      partnerSubCaste: json['partner_sub_caste'] != null
          ? LookupModel.fromJson(
              json['partner_sub_caste'] as Map<String, dynamic>,
            )
          : null,
      partnerDiet: json['partner_diet'] != null
          ? LookupModel.fromJson(json['partner_diet'] as Map<String, dynamic>)
          : null,
      partnerDrinking: json['partner_drinking']?.toString(),
      partnerManagedBy: json['partner_managed_by']?.toString(),
      partnerSmoking: json['partner_smoking']?.toString(),
      interestSent: _parseBool(json['interest_sent']),
      planDetail: json['plan_detail'] != null
          ? PlanDetail.fromJson(json['plan_detail'])
          : null,

      interestUser: _parseInt(json['interest_user']),
      totalUserView: _parseInt(json['total_user_view']),
      totalRecentUserView: _parseInt(json['totalRecentUserView']),
      acceptedInvitation: _parseInt(json['accepted_invitation']),
      receivedInvitation: _parseInt(json['receivedInvitation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'profile_id': profileId,
      'email': email,
      'mobile': mobile,
      'otp': otp,
      'otp_expire_at': otpExpireAt?.toIso8601String(),
      'hobbies': hobbies.map((e) => e.toJson()).toList(),
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'about': about,
      'birth_state': birthState?.toJson(),
      'dob': dob?.toIso8601String(),
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
      'photo_blur': photoBlur,
      'photo1': photo1,
      'photo1_blur': photo1Blur,
      'photo2': photo2,
      'photo2_blur': photo2Blur,
      'partner_qualities': partnerQualities,
      'partner_age_from': partnerAgeFrom,
      'partner_age_to': partnerAgeTo,
      'partner_complexion': partnerComplexion?.toJson(),
      'partner_have_children': partnerHaveChildren,
      'partner_height_from': partnerHeightFrom,
      'partner_height_to': partnerHeightTo,
      'partner_language': partnerLanguage?.toJson(),
      'partner_mother_tongue': partnerMotherTongue?.toJson(),
      'partner_weight_from': partnerWeightFrom,
      'partner_weight_to': partnerWeightTo,
      'partner_family_type': partnerFamilyType,
      'partner_family_value': partnerFamilyValue,
      'partner_city': partnerCity?.toJson(),
      'partner_country': partnerCountry?.toJson(),
      'partner_state': partnerState?.toJson(),
      'partner_education': partnerEducation?.toJson(),
      'partner_income_from': partnerIncomeFrom,
      'partner_income_to': partnerIncomeTo,
      'partner_occupation': partnerOccupation?.toJson(),
      'partner_professional_qualification': partnerProfessionalQualification
          ?.toJson(),
      'partner_working_as': partnerWorkingAs?.toJson(),
      'partner_caste': partnerCaste?.toJson(),
      'partner_dosh': partnerDosh,
      'partner_religion': partnerReligion?.toJson(),
      'partner_sub_caste': partnerSubCaste?.toJson(),
      'partner_diet': partnerDiet?.toJson(),
      'partner_drinking': partnerDrinking,
      'partner_managed_by': partnerManagedBy,
      'partner_smoking': partnerSmoking,
      'interest_sent': interestSent,
      'plan_detail': planDetail,
      'interest_user': interestUser,
      'total_user_view': totalUserView,
      'totalRecentUserView': totalRecentUserView,
      'accepted_invitation': acceptedInvitation,
      'receivedInvitation': receivedInvitation,
    };
  }
}

/// Hobby model
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
      id: json['_id']?.toString(),
      icon: json['icon']?.toString(),
      name: json['name']?.toString(),
      status: json['status']?.toString(),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      v: _parseInt(json['__v']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'icon': icon,
      'name': name,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

/// Generic lookup model used for:
/// gotra, religion, caste, city, state, country, education, occupation, etc.
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
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      religionId: json['religion_id']?.toString(),
      casteId: json['caste_id']?.toString(),
      countryId: json['country_id']?.toString(),
      stateId: json['state_id']?.toString(),
      educationType: _parseInt(json['education_type']),
      status: json['status']?.toString(),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      v: _parseInt(json['__v']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'religion_id': religionId,
      'caste_id': casteId,
      'country_id': countryId,
      'state_id': stateId,
      'education_type': educationType,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

/// ---------- Helper functions for null-safe parsing ----------

bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  final s = value.toString().toLowerCase();
  if (s == 'true' || s == '1') return true;
  if (s == 'false' || s == '0') return false;
  return null;
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return null;
  }
}

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
      id: json['_id']?.toString(),
      userId: json['user_id']?.toString(),
      planId: json['plan_id'] != null ? PlanId.fromJson(json['plan_id']) : null,

      price: _parseInt(json['price']),
      startDate: _parseDateTime(json['start_date']),
      expiryDate: _parseDateTime(json['expiry_date']),

      status: json['status']?.toString(),

      advanceSearch: json['advance_search']?.toString(),
      chat: json['chat']?.toString(),
      matchSuggestions: json['match_suggestions']?.toString(),
      profileHighlight: json['profile_highlight']?.toString(),
      profileView: json['profile_view']?.toString(),
      viewContact: json['view_contact']?.toString(),
      voiceVideo: json['voice_video']?.toString(),
      sendInterest: json['send_interest']?.toString(),

      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      v: _parseInt(json['__v']),
    );
  }
}

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
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      price: _parseInt(json['price']),
      status: json['status']?.toString(),

      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      v: _parseInt(json['__v']),

      advanceSearch: json['advance_search']?.toString(),
      chat: json['chat']?.toString(),
      matchSuggestions: json['match_suggestions']?.toString(),
      profileHighlight: json['profile_highlight']?.toString(),
      profileView: json['profile_view']?.toString(),
      viewContact: json['view_contact']?.toString(),
      voiceVideo: json['voice_video']?.toString(),
      sendInterest: json['send_interest']?.toString(),
    );
  }
}
