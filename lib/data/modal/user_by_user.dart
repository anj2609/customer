// import 'dart:convert';

// UserFullDetailResponse userFullDetailResponseFromJson(String str) =>
//     UserFullDetailResponse.fromJson(json.decode(str));

// class UserFullDetailResponse {
//   bool? status;
//   dynamic message;
//   UserFullData? data;

//   UserFullDetailResponse({this.status, this.message, this.data});

//   factory UserFullDetailResponse.fromJson(Map<String, dynamic> json) =>
//       UserFullDetailResponse(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? null : UserFullData.fromJson(json["data"]),
//       );
// }

// class UserFullData {
//   MemberData? memberData;
//   dynamic expressEntrest;
//   dynamic contactLockStatus;
//   PartnerPreferences? partnerPreferences;

//   UserFullData({
//     this.memberData,
//     this.expressEntrest,
//     this.contactLockStatus,
//     this.partnerPreferences,
//   });

//   factory UserFullData.fromJson(Map<String, dynamic> json) => UserFullData(
//     memberData: json["memberData"] == null
//         ? null
//         : MemberData.fromJson(json["memberData"]),
//     expressEntrest: json["express_entrest"],
//     contactLockStatus: json["contact_lock_status"],
//     partnerPreferences: json["partnerPreferences"] == null
//         ? null
//         : PartnerPreferences.fromJson(json["partnerPreferences"]),
//   );
// }

// ////////////////////////////////////////////////////////////////////////////////
// //                                MEMBER DATA                                //
// ////////////////////////////////////////////////////////////////////////////////

// class MemberData {
//   dynamic id;
//   dynamic profileId;
//   dynamic email;
//   dynamic mobile;
//   dynamic otp;
//   dynamic otpExpireAt;

//   List<CommonDataWithIcon>? hobbies;
//   CommonData? gotra;

//   dynamic ugDegree;
//   dynamic pgDegree;

//   List<String>? partnerHobbies;
//   List<dynamic>? partnerMaritalStatus;
//   CommonData? partnerGotra;

//   dynamic appStep;
//   dynamic deviceToken;
//   dynamic formStatus;
//   dynamic status;
//   dynamic createdAt;
//   dynamic updatedAt;

//   dynamic about;

//   CommonData? birthState;
//   dynamic dob;
//   dynamic gender;
//   CommonData? maritalStatus;

//   dynamic name;
//   CommonData? profileFor;

//   dynamic step;

//   dynamic contactEmail;
//   dynamic contactNo;
//   dynamic facebook;
//   dynamic instagram;

//   dynamic reference;
//   dynamic referenceOther;

//   CommonData? caste;
//   dynamic dosh;
//   dynamic gotraOther;
//   CommonData? religion;
//   CommonData? subCaste;

//   dynamic locRelation;
//   dynamic locRelationEmail;
//   dynamic locRelationMobile;
//   dynamic locRelationName;

//   CommonData? locCity;
//   dynamic locHouseType;
//   dynamic locLandmark;
//   CommonData? locNationality;
//   dynamic locPincode;
//   dynamic locResidenceType;

//   CommonData? locState;
//   CommonData? locTempCity;
//   dynamic locTempLandmark;
//   dynamic locTempPincode;
//   CommonData? locTempState;

//   dynamic familyType;
//   dynamic familyValue;

//   dynamic marriedBrother;
//   dynamic marriedSister;
//   dynamic noOfBrother;
//   dynamic noOfBrotherInLaw;
//   dynamic noOfSister;
//   dynamic noOfSisterInLaw;

//   CommonData? birthCity;

//   dynamic bloodGroup;
//   CommonData? complexion;
//   CommonData? diet;

//   dynamic disability;
//   dynamic healthInformation;

//   double? height;
//   dynamic manglik;
//   dynamic weight;
//   dynamic annualIncome;

//   Education? highestDegree;

//   CommonData? occupation;
//   dynamic organizationName;
//   dynamic otherEducation;
//   dynamic pgCollegeName;
//   dynamic prevWorkingDetail;
//   dynamic schoolName;
//   dynamic ugCollegeName;

//   CommonData? workingWith;

//   dynamic photo;
//   dynamic photo1;
//   dynamic photo2;
//   dynamic photo3;
//   dynamic photo4;
//   dynamic photoBlur;

//   dynamic partnerQualities;

//   CommonData? partnerCaste;
//   dynamic partnerDosh;

//   CommonData? partnerReligion;
//   CommonData? partnerSubCaste;

//   dynamic partnerAgeFrom;
//   dynamic partnerAgeTo;

//   CommonData? partnerCity;
//   CommonData? partnerComplexion;
//   CommonData? partnerCountry;

//   CommonData? partnerDiet;
//   dynamic partnerDrinking;

//   Education? partnerEducation;

//   dynamic partnerHaveChildren;

//   double? partnerHeightFrom;
//   double? partnerHeightTo;

//   dynamic partnerIncomeFrom;
//   dynamic partnerIncomeTo;

//   CommonData? partnerLanguage;

//   dynamic partnerManagedBy;

//   CommonData? partnerMotherTongue;

//   CommonData? partnerOccupation;

//   CommonData? partnerProfessionalQualification;

//   dynamic partnerSmoking;

//   CommonData? partnerState;

//   dynamic partnerWeightFrom;
//   dynamic partnerWeightTo;

//   CommonData? partnerWorkingAs;

//   MemberData({
//     this.id,
//     this.profileId,
//     this.email,
//     this.mobile,
//     this.otp,
//     this.otpExpireAt,
//     this.hobbies,
//     this.gotra,
//     this.ugDegree,
//     this.pgDegree,
//     this.partnerHobbies,
//     this.partnerMaritalStatus,
//     this.partnerGotra,
//     this.appStep,
//     this.deviceToken,
//     this.formStatus,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.about,
//     this.birthState,
//     this.dob,
//     this.gender,
//     this.maritalStatus,
//     this.name,
//     this.profileFor,
//     this.step,
//     this.contactEmail,
//     this.contactNo,
//     this.facebook,
//     this.instagram,
//     this.reference,
//     this.referenceOther,
//     this.caste,
//     this.dosh,
//     this.gotraOther,
//     this.religion,
//     this.subCaste,
//     this.locRelation,
//     this.locRelationEmail,
//     this.locRelationMobile,
//     this.locRelationName,
//     this.locCity,
//     this.locHouseType,
//     this.locLandmark,
//     this.locNationality,
//     this.locPincode,
//     this.locResidenceType,
//     this.locState,
//     this.locTempCity,
//     this.locTempLandmark,
//     this.locTempPincode,
//     this.locTempState,
//     this.familyType,
//     this.familyValue,
//     this.marriedBrother,
//     this.marriedSister,
//     this.noOfBrother,
//     this.noOfBrotherInLaw,
//     this.noOfSister,
//     this.noOfSisterInLaw,
//     this.birthCity,
//     this.bloodGroup,
//     this.complexion,
//     this.diet,
//     this.disability,
//     this.healthInformation,
//     this.height,
//     this.manglik,
//     this.weight,
//     this.annualIncome,
//     this.highestDegree,
//     this.occupation,
//     this.organizationName,
//     this.otherEducation,
//     this.pgCollegeName,
//     this.prevWorkingDetail,
//     this.schoolName,
//     this.ugCollegeName,
//     this.workingWith,
//     this.photo,
//     this.photo1,
//     this.photo2,
//     this.photo3,
//     this.photo4,
//     this.photoBlur,
//     this.partnerQualities,
//     this.partnerCaste,
//     this.partnerDosh,
//     this.partnerReligion,
//     this.partnerSubCaste,
//     this.partnerAgeFrom,
//     this.partnerAgeTo,
//     this.partnerCity,
//     this.partnerComplexion,
//     this.partnerCountry,
//     this.partnerDiet,
//     this.partnerDrinking,
//     this.partnerEducation,
//     this.partnerHaveChildren,
//     this.partnerHeightFrom,
//     this.partnerHeightTo,
//     this.partnerIncomeFrom,
//     this.partnerIncomeTo,
//     this.partnerLanguage,
//     this.partnerManagedBy,
//     this.partnerMotherTongue,
//     this.partnerOccupation,
//     this.partnerProfessionalQualification,
//     this.partnerSmoking,
//     this.partnerState,
//     this.partnerWeightFrom,
//     this.partnerWeightTo,
//     this.partnerWorkingAs,
//   });

//   factory MemberData.fromJson(Map<String, dynamic> json) => MemberData(
//     id: json["_id"],
//     profileId: json["profile_id"],
//     email: json["email"],
//     mobile: json["mobile"],
//     otp: json["otp"],
//     otpExpireAt: json["otp_expire_at"],
//     hobbies: json["hobbies"] == null
//         ? []
//         : List<CommonDataWithIcon>.from(
//             json["hobbies"].map((x) => CommonDataWithIcon.fromJson(x)),
//           ),
//     gotra: json["gotra"] == null ? null : CommonData.fromJson(json["gotra"]),
//     ugDegree: json["ug_degree"],
//     pgDegree: json["pg_degree"],
//     partnerHobbies: json["partner_hobbies"] == null
//         ? []
//         : List<String>.from(json["partner_hobbies"]),
//     partnerMaritalStatus: json["partner_marital_status"] ?? [],
//     partnerGotra: json["partner_gotra"] == null
//         ? null
//         : CommonData.fromJson(json["partner_gotra"]),
//     appStep: json["app_step"],
//     deviceToken: json["device_token"],
//     formStatus: json["form_status"],
//     status: json["status"],
//     createdAt: json["createdAt"],
//     updatedAt: json["updatedAt"],
//     about: json["about"],
//     birthState: json["birth_state"] == null
//         ? null
//         : CommonData.fromJson(json["birth_state"]),
//     dob: json["dob"],
//     gender: json["gender"],
//     maritalStatus: json["marital_status"] == null
//         ? null
//         : CommonData.fromJson(json["marital_status"]),
//     name: json["name"],
//     profileFor: json["profile_for"] == null
//         ? null
//         : CommonData.fromJson(json["profile_for"]),
//     step: json["step"],
//     contactEmail: json["contact_email"],
//     contactNo: json["contact_no"],
//     facebook: json["facebook"],
//     instagram: json["instagram"],
//     reference: json["reference"],
//     referenceOther: json["reference_other"],
//     caste: json["caste"] == null ? null : CommonData.fromJson(json["caste"]),
//     dosh: json["dosh"],
//     gotraOther: json["gotra_other"],
//     religion: json["religion"] == null
//         ? null
//         : CommonData.fromJson(json["religion"]),
//     subCaste: json["sub_caste"] == null
//         ? null
//         : CommonData.fromJson(json["sub_caste"]),
//     locRelation: json["loc_relation"],
//     locRelationEmail: json["loc_relation_email"],
//     locRelationMobile: json["loc_relation_mobile"],
//     locRelationName: json["loc_relation_name"],
//     locCity: json["loc_city"] == null
//         ? null
//         : CommonData.fromJson(json["loc_city"]),
//     locHouseType: json["loc_house_type"],
//     locLandmark: json["loc_landmark"],
//     locNationality: json["loc_nationality"] == null
//         ? null
//         : CommonData.fromJson(json["loc_nationality"]),
//     locPincode: json["loc_pincode"],
//     locResidenceType: json["loc_residence_type"],
//     locState: json["loc_state"] == null
//         ? null
//         : CommonData.fromJson(json["loc_state"]),
//     locTempCity: json["loc_temp_city"] == null
//         ? null
//         : CommonData.fromJson(json["loc_temp_city"]),
//     locTempLandmark: json["loc_temp_landmark"],
//     locTempPincode: json["loc_temp_pincode"],
//     locTempState: json["loc_temp_state"] == null
//         ? null
//         : CommonData.fromJson(json["loc_temp_state"]),
//     familyType: json["family_type"],
//     familyValue: json["family_value"],
//     marriedBrother: json["married_brother"],
//     marriedSister: json["married_sister"],
//     noOfBrother: json["no_of_brother"],
//     noOfBrotherInLaw: json["no_of_brother_in_law"],
//     noOfSister: json["no_of_sister"],
//     noOfSisterInLaw: json["no_of_sister_in_law"],
//     birthCity: json["birth_city"] == null
//         ? null
//         : CommonData.fromJson(json["birth_city"]),
//     bloodGroup: json["blood_group"],
//     complexion: json["complexion"] == null
//         ? null
//         : CommonData.fromJson(json["complexion"]),
//     diet: json["diet"] == null ? null : CommonData.fromJson(json["diet"]),
//     disability: json["disability"],
//     healthInformation: json["health_information"],
//     height: (json["height"] ?? 0).toDouble(),
//     manglik: json["manglik"],
//     weight: json["weight"],
//     annualIncome: json["annual_income"],
//     highestDegree: json["highest_degree"] == null
//         ? null
//         : Education.fromJson(json["highest_degree"]),
//     occupation: json["occupation"] == null
//         ? null
//         : CommonData.fromJson(json["occupation"]),
//     organizationName: json["organization_name"],
//     otherEducation: json["other_education"],
//     pgCollegeName: json["pg_college_name"],
//     prevWorkingDetail: json["prev_working_detail"],
//     schoolName: json["school_name"],
//     ugCollegeName: json["ug_college_name"],
//     workingWith: json["working_with"] == null
//         ? null
//         : CommonData.fromJson(json["working_with"]),
//     photo: json["photo"],
//     photo1: json["photo1"],
//     photo2: json["photo2"],
//     photo3: json["photo3"],
//     photo4: json["photo4"],
//     photoBlur: json["photo_blur"],
//     partnerQualities: json["partner_qualities"],
//     partnerCaste: json["partner_caste"] == null
//         ? null
//         : CommonData.fromJson(json["partner_caste"]),
//     partnerDosh: json["partner_dosh"],
//     partnerReligion: json["partner_religion"] == null
//         ? null
//         : CommonData.fromJson(json["partner_religion"]),
//     partnerSubCaste: json["partner_sub_caste"] == null
//         ? null
//         : CommonData.fromJson(json["partner_sub_caste"]),
//     partnerAgeFrom: json["partner_age_from"],
//     partnerAgeTo: json["partner_age_to"],
//     partnerCity: json["partner_city"] == null
//         ? null
//         : CommonData.fromJson(json["partner_city"]),
//     partnerComplexion: json["partner_complexion"] == null
//         ? null
//         : CommonData.fromJson(json["partner_complexion"]),
//     partnerCountry: json["partner_country"] == null
//         ? null
//         : CommonData.fromJson(json["partner_country"]),
//     partnerDiet: json["partner_diet"] == null
//         ? null
//         : CommonData.fromJson(json["partner_diet"]),
//     partnerDrinking: json["partner_drinking"],
//     partnerEducation: json["partner_education"] == null
//         ? null
//         : Education.fromJson(json["partner_education"]),
//     partnerHaveChildren: json["partner_have_children"],
//     partnerHeightFrom: (json["partner_height_from"] ?? 0).toDouble(),
//     partnerHeightTo: (json["partner_height_to"] ?? 0).toDouble(),
//     partnerIncomeFrom: json["partner_income_from"],
//     partnerIncomeTo: json["partner_income_to"],
//     partnerLanguage: json["partner_language"] == null
//         ? null
//         : CommonData.fromJson(json["partner_language"]),
//     partnerManagedBy: json["partner_managed_by"],
//     partnerMotherTongue: json["partner_mother_tongue"] == null
//         ? null
//         : CommonData.fromJson(json["partner_mother_tongue"]),
//     partnerOccupation: json["partner_occupation"] == null
//         ? null
//         : CommonData.fromJson(json["partner_occupation"]),
//     partnerProfessionalQualification:
//         json["partner_professional_qualification"] == null
//         ? null
//         : CommonData.fromJson(json["partner_professional_qualification"]),
//     partnerSmoking: json["partner_smoking"],
//     partnerState: json["partner_state"] == null
//         ? null
//         : CommonData.fromJson(json["partner_state"]),
//     partnerWeightFrom: json["partner_weight_from"],
//     partnerWeightTo: json["partner_weight_to"],
//     partnerWorkingAs: json["partner_working_as"] == null
//         ? null
//         : CommonData.fromJson(json["partner_working_as"]),
//   );
// }

// ////////////////////////////////////////////////////////////////////////////////
// //                               PARTNER PREFERENCE                           //
// ////////////////////////////////////////////////////////////////////////////////

// class PartnerPreferences {
//   CommonValue? age;
//   CommonValue? height;
//   StatusWithData? maritalStatus;
//   StatusWithData? religion;
//   StatusWithData? caste;
//   StatusWithData? motherTongue;
//   StatusWithData? education;
//   StatusWithData? occupation;
//   StatusWithData? diet;
//   StatusWithData? country;
//   StatusWithData? state;
//   StatusWithData? city;
//   CommonValue? annualIncome;

//   PartnerPreferences({
//     this.age,
//     this.height,
//     this.maritalStatus,
//     this.religion,
//     this.caste,
//     this.motherTongue,
//     this.education,
//     this.occupation,
//     this.diet,
//     this.country,
//     this.state,
//     this.city,
//     this.annualIncome,
//   });

//   factory PartnerPreferences.fromJson(
//     Map<String, dynamic> json,
//   ) => PartnerPreferences(
//     age: json["age"] == null ? null : CommonValue.fromJson(json["age"]),
//     height: json["height"] == null
//         ? null
//         : CommonValue.fromJson(json["height"]),
//     maritalStatus: json["maritalStatus"] == null
//         ? null
//         : StatusWithData.fromJson(json["maritalStatus"]),
//     religion: json["religion"] == null
//         ? null
//         : StatusWithData.fromJson(json["religion"]),
//     caste: json["caste"] == null
//         ? null
//         : StatusWithData.fromJson(json["caste"]),
//     motherTongue: json["motherTongue"] == null
//         ? null
//         : StatusWithData.fromJson(json["motherTongue"]),
//     education: json["education"] == null
//         ? null
//         : StatusWithData.fromJson(json["education"]),
//     occupation: json["occupation"] == null
//         ? null
//         : StatusWithData.fromJson(json["occupation"]),
//     diet: json["diet"] == null ? null : StatusWithData.fromJson(json["diet"]),
//     country: json["country"] == null
//         ? null
//         : StatusWithData.fromJson(json["country"]),
//     state: json["state"] == null
//         ? null
//         : StatusWithData.fromJson(json["state"]),
//     city: json["city"] == null ? null : StatusWithData.fromJson(json["city"]),
//     annualIncome: json["annualIncome"] == null
//         ? null
//         : CommonValue.fromJson(json["annualIncome"]),
//   );
// }

// class CommonValue {
//   dynamic age;
//   dynamic height;
//   dynamic annualIncome;

//   CommonValue({this.age, this.height, this.annualIncome});

//   factory CommonValue.fromJson(Map<String, dynamic> json) => CommonValue(
//     age: json["age"],
//     height: json["height"],
//     annualIncome: json["annualIncome"],
//   );
// }

// class StatusWithData {
//   bool? status;
//   dynamic maritalStatus;
//   dynamic religion;
//   dynamic caste;
//   dynamic motherTongue;
//   dynamic education;
//   dynamic occupation;
//   dynamic diet;
//   dynamic country;
//   dynamic state;
//   dynamic city;

//   StatusWithData({
//     this.status,
//     this.maritalStatus,
//     this.religion,
//     this.caste,
//     this.motherTongue,
//     this.education,
//     this.occupation,
//     this.diet,
//     this.country,
//     this.state,
//     this.city,
//   });

//   factory StatusWithData.fromJson(Map<String, dynamic> json) => StatusWithData(
//     status: json["status"],
//     maritalStatus: json["maritalStatus"],
//     religion: json["religion"],
//     caste: json["caste"],
//     motherTongue: json["motherTongue"],
//     education: json["education"],
//     occupation: json["occupation"],
//     diet: json["diet"],
//     country: json["country"],
//     state: json["state"],
//     city: json["city"],
//   );
// }

// ////////////////////////////////////////////////////////////////////////////////
// //                     COMMON MODELS (Used Everywhere)                        //
// ////////////////////////////////////////////////////////////////////////////////

// class CommonData {
//   dynamic id;
//   dynamic name;

//   CommonData({this.id, this.name});

//   factory CommonData.fromJson(Map<String, dynamic> json) =>
//       CommonData(id: json["_id"], name: json["name"]);
// }

// class CommonDataWithIcon {
//   dynamic id;
//   dynamic name;
//   dynamic icon;

//   CommonDataWithIcon({this.id, this.name, this.icon});

//   factory CommonDataWithIcon.fromJson(Map<String, dynamic> json) =>
//       CommonDataWithIcon(
//         id: json["_id"],
//         name: json["name"],
//         icon: json["icon"],
//       );
// }

// class Education {
//   dynamic id;
//   dynamic name;
//   dynamic educationType;

//   Education({this.id, this.name, this.educationType});

//   factory Education.fromJson(Map<String, dynamic> json) => Education(
//     id: json["_id"],
//     name: json["name"],
//     educationType: json["education_type"],
//   );
// }
// user_full_profile_model.dart
// Auto-generated from profile JSON. Null-safe, all fields optional.

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  bool? status;
  String? message;
  ProfileData? data;

  ProfileResponse({this.status, this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
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

  ProfileData({
    this.memberData,
    this.expressEntrest,
    this.contactLockStatus,
    this.partnerPreferences,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      memberData: json['memberData'] != null
          ? MemberData.fromJson(json['memberData'] as Map<String, dynamic>)
          : null,
      expressEntrest: json['express_entrest'],
      contactLockStatus: json['contact_lock_status'],
      partnerPreferences: json['partnerPreferences'] != null
          ? PartnerPreferences.fromJson(
              json['partnerPreferences'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'memberData': memberData?.toJson(),
        'express_entrest': expressEntrest,
        'contact_lock_status': contactLockStatus,
        'partnerPreferences': partnerPreferences?.toJson(),
      };
}

class MemberData {
  String? id;
  String? profileId;
  String? email;
  String? mobile;
  String? otp;
  String? otpExpireAt;

  List<Hobby>? hobbies;
  RefData? gotra;

  String? ugDegree;
  String? pgDegree;

  List<String>? partnerHobbies;
  List<dynamic>? partnerMaritalStatus;

  RefData? partnerGotra;
  String? homeRegId;
  int? appStep;
  String? deviceToken;
  String? formStatus;
  String? status;

  String? createdAt;
  String? updatedAt;

  String? about;

  RefData? birthState;

  String? dob;
  String? gender;

  RefData? maritalStatus;
  String? name;

  RefData? profileFor;

  int? step;

  String? contactEmail;
  String? contactNo;

  String? facebook;
  String? instagram;

  String? reference;
  String? referenceOther;

  RefData? caste;
  String? dosh;
  String? gotraOther;

  RefData? religion;
  RefData? subCaste;

  String? locRelation;
  String? locRelationEmail;
  String? locRelationMobile;
  String? locRelationName;

  RefData? locCity;
  String? locHouseType;
  String? locLandmark;

  RefData? locNationality;
  String? locPincode;
  String? locResidenceType;

  RefData? locState;

  RefData? locTempCity;
  String? locTempLandmark;
  String? locTempPincode;
  RefData? locTempState;

  String? familyType;
  String? familyValue;

  int? marriedBrother;
  int? marriedSister;
  int? noOfBrother;
  int? noOfBrotherInLaw;
  int? noOfSister;
  int? noOfSisterInLaw;

  RefData? birthCity;
  String? bloodGroup;

  RefData? complexion;
  RefData? diet;

  String? disability;
  String? healthInformation;

  double? height;
  String? manglik;
  int? weight;

  String? annualIncome;

  RefData? highestDegree;
  RefData? occupation;

  String? organizationName;
  String? otherEducation;

  String? pgCollegeName;
  String? prevWorkingDetail;
  String? schoolName;
  String? ugCollegeName;

  RefData? workingWith;

  String? photo;
  String? photoBlur;

  String? partnerQualities;

  RefData? partnerCaste;
  String? partnerDosh;
  RefData? partnerReligion;
  RefData? partnerSubCaste;

  int? partnerAgeFrom;
  int? partnerAgeTo;

  RefData? partnerCity;
  RefData? partnerComplexion;
  RefData? partnerCountry;

  RefData? partnerDiet;
  String? partnerDrinking;

  RefData? partnerEducation;
  String? partnerHaveChildren;

  double? partnerHeightFrom;
  double? partnerHeightTo;

  String? partnerIncomeFrom;
  String? partnerIncomeTo;

  RefData? partnerLanguage;

  String? partnerManagedBy;

  RefData? partnerMotherTongue;

  RefData? partnerOccupation;
  RefData? partnerProfessionalQualification;

  String? partnerSmoking;

  RefData? partnerState;

  int? partnerWeightFrom;
  int? partnerWeightTo;

  RefData? partnerWorkingAs;

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
      id: json['_id'] as String?,
      profileId: json['profile_id'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      otp: json['otp'] as String?,
      otpExpireAt: json['otp_expire_at'] as String?,
      hobbies: (json['hobbies'] as List<dynamic>?)
          ?.map((e) => Hobby.fromJson(e as Map<String, dynamic>))
          .toList(),
      gotra: json['gotra'] != null
          ? RefData.fromJson(json['gotra'] as Map<String, dynamic>)
          : null,
      ugDegree: json['ug_degree'] as String?,
      pgDegree: json['pg_degree'] as String?,
      partnerHobbies: (json['partner_hobbies'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      partnerMaritalStatus:
          (json['partner_marital_status'] as List<dynamic>?) ?? <dynamic>[],
      partnerGotra: json['partner_gotra'] != null
          ? RefData.fromJson(json['partner_gotra'] as Map<String, dynamic>)
          : null,
      homeRegId: json['home_reg_id']?.toString(),
      appStep: json['app_step'] as int?,
      deviceToken: json['device_token']?.toString(),
      formStatus: json['form_status'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      about: json['about'] as String?,
      birthState: json['birth_state'] != null
          ? RefData.fromJson(json['birth_state'] as Map<String, dynamic>)
          : null,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      maritalStatus: json['marital_status'] != null
          ? RefData.fromJson(json['marital_status'] as Map<String, dynamic>)
          : null,
      name: json['name'] as String?,
      profileFor: json['profile_for'] != null
          ? RefData.fromJson(json['profile_for'] as Map<String, dynamic>)
          : null,
      step: json['step'] as int?,
      contactEmail: json['contact_email'] as String?,
      contactNo: json['contact_no']?.toString(),
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      reference: json['reference'] as String?,
      referenceOther: json['reference_other'] as String?,
      caste: json['caste'] != null
          ? RefData.fromJson(json['caste'] as Map<String, dynamic>)
          : null,
      dosh: json['dosh'] as String?,
      gotraOther: json['gotra_other'] as String?,
      religion: json['religion'] != null
          ? RefData.fromJson(json['religion'] as Map<String, dynamic>)
          : null,
      subCaste: json['sub_caste'] != null
          ? RefData.fromJson(json['sub_caste'] as Map<String, dynamic>)
          : null,
      locRelation: json['loc_relation'] as String?,
      locRelationEmail: json['loc_relation_email'] as String?,
      locRelationMobile: json['loc_relation_mobile'] as String?,
      locRelationName: json['loc_relation_name'] as String?,
      locCity: json['loc_city'] != null
          ? RefData.fromJson(json['loc_city'] as Map<String, dynamic>)
          : null,
      locHouseType: json['loc_house_type'] as String?,
      locLandmark: json['loc_landmark'] as String?,
      locNationality: json['loc_nationality'] != null
          ? RefData.fromJson(json['loc_nationality'] as Map<String, dynamic>)
          : null,
      locPincode: json['loc_pincode'] as String?,
      locResidenceType: json['loc_residence_type'] as String?,
      locState: json['loc_state'] != null
          ? RefData.fromJson(json['loc_state'] as Map<String, dynamic>)
          : null,
      locTempCity: json['loc_temp_city'] != null
          ? RefData.fromJson(json['loc_temp_city'] as Map<String, dynamic>)
          : null,
      locTempLandmark: json['loc_temp_landmark'] as String?,
      locTempPincode: json['loc_temp_pincode'] as String?,
      locTempState: json['loc_temp_state'] != null
          ? RefData.fromJson(json['loc_temp_state'] as Map<String, dynamic>)
          : null,
      familyType: json['family_type'] as String?,
      familyValue: json['family_value'] as String?,
      marriedBrother: json['married_brother'] as int?,
      marriedSister: json['married_sister'] as int?,
      noOfBrother: json['no_of_brother'] as int?,
      noOfBrotherInLaw: json['no_of_brother_in_law'] as int?,
      noOfSister: json['no_of_sister'] as int?,
      noOfSisterInLaw: json['no_of_sister_in_law'] as int?,
      birthCity: json['birth_city'] != null
          ? RefData.fromJson(json['birth_city'] as Map<String, dynamic>)
          : null,
      bloodGroup: json['blood_group'] as String?,
      complexion: json['complexion'] != null
          ? RefData.fromJson(json['complexion'] as Map<String, dynamic>)
          : null,
      diet: json['diet'] != null
          ? RefData.fromJson(json['diet'] as Map<String, dynamic>)
          : null,
      disability: json['disability'] as String?,
      healthInformation: json['health_information'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      manglik: json['manglik'] as String?,
      weight: json['weight'] as int?,
      annualIncome: json['annual_income']?.toString(),
      highestDegree: json['highest_degree'] != null
          ? RefData.fromJson(json['highest_degree'] as Map<String, dynamic>)
          : null,
      occupation: json['occupation'] != null
          ? RefData.fromJson(json['occupation'] as Map<String, dynamic>)
          : null,
      organizationName: json['organization_name'] as String?,
      otherEducation: json['other_education'] as String?,
      pgCollegeName: json['pg_college_name'] as String?,
      prevWorkingDetail: json['prev_working_detail'] as String?,
      schoolName: json['school_name'] as String?,
      ugCollegeName: json['ug_college_name'] as String?,
      workingWith: json['working_with'] != null
          ? RefData.fromJson(json['working_with'] as Map<String, dynamic>)
          : null,
      photo: json['photo'] as String?,
      photoBlur: json['photo_blur'] as String?,
      partnerQualities: json['partner_qualities'] as String?,
      partnerCaste: json['partner_caste'] != null
          ? RefData.fromJson(json['partner_caste'] as Map<String, dynamic>)
          : null,
      partnerDosh: json['partner_dosh'] as String?,
      partnerReligion: json['partner_religion'] != null
          ? RefData.fromJson(json['partner_religion'] as Map<String, dynamic>)
          : null,
      partnerSubCaste: json['partner_sub_caste'] != null
          ? RefData.fromJson(json['partner_sub_caste'] as Map<String, dynamic>)
          : null,
      partnerAgeFrom: json['partner_age_from'] as int?,
      partnerAgeTo: json['partner_age_to'] as int?,
      partnerCity: json['partner_city'] != null
          ? RefData.fromJson(json['partner_city'] as Map<String, dynamic>)
          : null,
      partnerComplexion: json['partner_complexion'] != null
          ? RefData.fromJson(json['partner_complexion'] as Map<String, dynamic>)
          : null,
      partnerCountry: json['partner_country'] != null
          ? RefData.fromJson(json['partner_country'] as Map<String, dynamic>)
          : null,
      partnerDiet: json['partner_diet'] != null
          ? RefData.fromJson(json['partner_diet'] as Map<String, dynamic>)
          : null,
      partnerDrinking: json['partner_drinking'] as String?,
      partnerEducation: json['partner_education'] != null
          ? RefData.fromJson(json['partner_education'] as Map<String, dynamic>)
          : null,
      partnerHaveChildren: json['partner_have_children']?.toString(),
      partnerHeightFrom: (json['partner_height_from'] as num?)?.toDouble(),
      partnerHeightTo: (json['partner_height_to'] as num?)?.toDouble(),
      partnerIncomeFrom: json['partner_income_from']?.toString(),
      partnerIncomeTo: json['partner_income_to']?.toString(),
      partnerLanguage: json['partner_language'] != null
          ? RefData.fromJson(json['partner_language'] as Map<String, dynamic>)
          : null,
      partnerManagedBy: json['partner_managed_by'] as String?,
      partnerMotherTongue: json['partner_mother_tongue'] != null
          ? RefData.fromJson(
              json['partner_mother_tongue'] as Map<String, dynamic>,
            )
          : null,
      partnerOccupation: json['partner_occupation'] != null
          ? RefData.fromJson(json['partner_occupation'] as Map<String, dynamic>)
          : null,
      partnerProfessionalQualification:
          json['partner_professional_qualification'] != null
              ? RefData.fromJson(
                  json['partner_professional_qualification']
                      as Map<String, dynamic>,
                )
              : null,
      partnerSmoking: json['partner_smoking'] as String?,
      partnerState: json['partner_state'] != null
          ? RefData.fromJson(json['partner_state'] as Map<String, dynamic>)
          : null,
      partnerWeightFrom: json['partner_weight_from'] as int?,
      partnerWeightTo: json['partner_weight_to'] as int?,
      partnerWorkingAs: json['partner_working_as'] != null
          ? RefData.fromJson(json['partner_working_as'] as Map<String, dynamic>)
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
        'partner_professional_qualification':
            partnerProfessionalQualification?.toJson(),
        'partner_smoking': partnerSmoking,
        'partner_state': partnerState?.toJson(),
        'partner_weight_from': partnerWeightFrom,
        'partner_weight_to': partnerWeightTo,
        'partner_working_as': partnerWorkingAs?.toJson(),
      };
}

class Hobby {
  String? icon;
  String? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;

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
      icon: json['icon'] as String?,
      id: json['_id'] as String?,
      name: json['name'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
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
  String? id;
  String? name;
  String? religionId;
  String? countryId;
  String? stateId;
  String? casteId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;

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

  factory RefData.fromJson(Map<String, dynamic> json) {
    return RefData(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      religionId: json['religion_id']?.toString(),
      countryId: json['country_id']?.toString(),
      stateId: json['state_id']?.toString(),
      casteId: json['caste_id']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      v: json['__v'] as int?,
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
  });

  factory PartnerPreferences.fromJson(Map<String, dynamic> json) {
    return PartnerPreferences(
      age: json['age'] != null
          ? AgePreference.fromJson(json['age'] as Map<String, dynamic>)
          : null,
      height: json['height'] != null
          ? HeightPreference.fromJson(json['height'] as Map<String, dynamic>)
          : null,
      maritalStatus: json['maritalStatus'] != null
          ? MaritalStatusPreference.fromJson(
              json['maritalStatus'] as Map<String, dynamic>,
            )
          : null,
      religion: json['religion'] != null
          ? ReligionPreference.fromJson(
              json['religion'] as Map<String, dynamic>,
            )
          : null,
      caste: json['caste'] != null
          ? CastePreference.fromJson(json['caste'] as Map<String, dynamic>)
          : null,
      motherTongue: json['motherTongue'] != null
          ? MotherTonguePreference.fromJson(
              json['motherTongue'] as Map<String, dynamic>,
            )
          : null,
      education: json['education'] != null
          ? EducationPreference.fromJson(
              json['education'] as Map<String, dynamic>,
            )
          : null,
      occupation: json['occupation'] != null
          ? OccupationPreference.fromJson(
              json['occupation'] as Map<String, dynamic>,
            )
          : null,
      diet: json['diet'] != null
          ? DietPreference.fromJson(json['diet'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? CountryPreference.fromJson(
              json['country'] as Map<String, dynamic>,
            )
          : null,
      state: json['state'] != null
          ? StatePreference.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      city: json['city'] != null
          ? CityPreference.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      annualIncome: json['annualIncome'] != null
          ? AnnualIncomePreference.fromJson(
              json['annualIncome'] as Map<String, dynamic>,
            )
          : null,
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
      };
}

class AgePreference {
  String? age;

  AgePreference({this.age});

  factory AgePreference.fromJson(Map<String, dynamic> json) {
    return AgePreference(
      age: json['age']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'age': age,
      };
}

class HeightPreference {
  double? height;

  HeightPreference({this.height});

  factory HeightPreference.fromJson(Map<String, dynamic> json) {
    return HeightPreference(
      height: (json['height'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'height': height,
      };
}

class AnnualIncomePreference {
  String? annualIncome;

  AnnualIncomePreference({this.annualIncome});

  factory AnnualIncomePreference.fromJson(Map<String, dynamic> json) {
    return AnnualIncomePreference(
      annualIncome: json['annualIncome']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'annualIncome': annualIncome,
      };
}

class MaritalStatusPreference {
  bool? status;
  RefData? maritalStatus;

  MaritalStatusPreference({this.status, this.maritalStatus});

  factory MaritalStatusPreference.fromJson(Map<String, dynamic> json) {
    return MaritalStatusPreference(
      status: json['status'] as bool?,
      maritalStatus: json['maritalStatus'] != null
          ? RefData.fromJson(json['maritalStatus'] as Map<String, dynamic>)
          : null,
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

  factory ReligionPreference.fromJson(Map<String, dynamic> json) {
    return ReligionPreference(
      status: json['status'] as bool?,
      religion: json['religion'] != null
          ? RefData.fromJson(json['religion'] as Map<String, dynamic>)
          : null,
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

  factory CastePreference.fromJson(Map<String, dynamic> json) {
    return CastePreference(
      status: json['status'] as bool?,
      caste: json['caste'] != null
          ? RefData.fromJson(json['caste'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'caste': caste?.toJson(),
      };
}

class MotherTonguePreference {
  bool? status;
  String? motherTongue;

  MotherTonguePreference({this.status, this.motherTongue});

  factory MotherTonguePreference.fromJson(Map<String, dynamic> json) {
    return MotherTonguePreference(
      status: json['status'] as bool?,
      motherTongue: json['motherTongue']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'motherTongue': motherTongue,
      };
}

class EducationPreference {
  bool? status;
  String? education;

  EducationPreference({this.status, this.education});

  factory EducationPreference.fromJson(Map<String, dynamic> json) {
    return EducationPreference(
      status: json['status'] as bool?,
      education: json['education']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'education': education,
      };
}

class OccupationPreference {
  bool? status;
  RefData? occupation;

  OccupationPreference({this.status, this.occupation});

  factory OccupationPreference.fromJson(Map<String, dynamic> json) {
    return OccupationPreference(
      status: json['status'] as bool?,
      occupation: json['occupation'] != null
          ? RefData.fromJson(json['occupation'] as Map<String, dynamic>)
          : null,
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

  factory DietPreference.fromJson(Map<String, dynamic> json) {
    return DietPreference(
      status: json['status'] as bool?,
      diet: json['diet'] != null
          ? RefData.fromJson(json['diet'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'diet': diet?.toJson(),
      };
}

class CountryPreference {
  bool? status;
  RefData? country;

  CountryPreference({this.status, this.country});

  factory CountryPreference.fromJson(Map<String, dynamic> json) {
    return CountryPreference(
      status: json['status'] as bool?,
      country: json['country'] != null
          ? RefData.fromJson(json['country'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'country': country?.toJson(),
      };
}

class StatePreference {
  bool? status;
  String? state;

  StatePreference({this.status, this.state});

  factory StatePreference.fromJson(Map<String, dynamic> json) {
    return StatePreference(
      status: json['status'] as bool?,
      state: json['state']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'state': state,
      };
}

class CityPreference {
  bool? status;
  RefData? city;

  CityPreference({this.status, this.city});

  factory CityPreference.fromJson(Map<String, dynamic> json) {
    return CityPreference(
      status: json['status'] as bool?,
      city: json['city'] != null
          ? RefData.fromJson(json['city'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'city': city?.toJson(),
      };
}
