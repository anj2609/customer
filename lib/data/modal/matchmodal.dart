class SearchListModel {
  final bool? status;
  final List<MatchListData>? data;
  final List<MatchListData>? usersBride;
  final List<MatchListData>? usersGrooms;

  SearchListModel({this.status, this.data, this.usersBride, this.usersGrooms});

  factory SearchListModel.fromJson(Map<String, dynamic> json) {
    return SearchListModel(
      status: json['status'],
      data: (json['data'] as List?)
          ?.map((e) => MatchListData.fromJson(e))
          .toList(),
      usersBride: (json['usersBride'] as List?)
          ?.map((e) => MatchListData.fromJson(e))
          .toList(),
      usersGrooms: (json['usersGrooms'] as List?)
          ?.map((e) => MatchListData.fromJson(e))
          .toList(),
    );
  }
}

class MatchListData {
  final String? id;
  final String? profileId;
  final String? email;
  final String? mobile;
  final String? about;
  final String? annualincome;
  final dynamic aasherno;
  final String? gender;
  final String? manglik;
  final String? maritalStatus;
  final String? name;
  final ReligionModel? religion;
  final String? deviceToken;
  final String? profilePhoto;

  final String? caste;
  final String? dob;

  final dynamic weight;
  final double? height;
  final bool? interestSent;

  final List<String>? partnerHobbies;
  final List<String>? partnerMaritalStatus;
  final List<String>? hobbies;

  final ProfileFor? profileFor;
  final HighestDegree? highestDegree;
  final OccupationModel? occupation;
  final LocationModel? locCity;
  final LocationModel? locState;
  final LocationModel? birthCity;
  final LocationModel? birthState;

  final String? photo;
  final String? photo1;
  final String? photo2;
  final String? photo3;
  final String? photo4;
  final String? photoBlur;
  final dynamic interestsentstatus;
  final dynamic shortlistsent;
  final ProfileSettings? profilesetting;
  bool? photorequestcheck;
  dynamic photorequeststatus;
  MatchListData({
    this.id,
    this.profileId,
    this.email,
    this.mobile,
    this.about,
    this.gender,
    this.manglik,
    this.maritalStatus,
    this.annualincome,
    this.name,
    this.deviceToken,
    this.profilePhoto,
    this.caste,
    this.dob,
    this.weight,
    this.religion,
    this.height,
    this.interestSent,
    this.partnerHobbies,
    this.partnerMaritalStatus,
    this.hobbies,
    this.profileFor,
    this.highestDegree,
    this.occupation,
    this.locCity,
    this.locState,
    this.birthCity,
    this.birthState,
    this.photo,
    this.photo1,
    this.photo2,
    this.photorequeststatus,
    this.photo3,
    this.photo4,
    this.photoBlur,
    this.aasherno,
    this.interestsentstatus,
    this.shortlistsent,
    this.profilesetting,
    this.photorequestcheck,
  });

  factory MatchListData.fromJson(Map<String, dynamic> json) {
    return MatchListData(
      id: json['_id'],
      profileId: json['profile_id'],
      email: json['email'],
      mobile: json['mobile'],
      about: json['about'],
      annualincome: json['annual_income'] ?? "",
      gender: json['gender'],
      manglik: json['manglik'],
      maritalStatus: json['marital_status'],
      name: json['name'],

      deviceToken: json['device_token'],
      profilePhoto: json['profile_photo']?.toString(),
      photorequeststatus: json['photo_request_status'],
      caste: json['caste']?.toString(),
      dob: json['dob'],
      religion: json['religion'] is Map
          ? ReligionModel.fromJson(json['religion'])
          : null,
      weight: json['weight'],
      height: json['height'] == null
          ? null
          : double.tryParse(json['height'].toString()),

      interestSent: json['interest_sent'] ?? false,

      hobbies: (json['hobbies'] as List?)?.map((e) => e.toString()).toList(),

      partnerHobbies: (json['partner_hobbies'] as List?)
          ?.map((e) => e.toString())
          .toList(),

      partnerMaritalStatus: (json['partner_marital_status'] as List?)
          ?.map((e) => e.toString())
          .toList(),

      // 🔥 100% Safe Nested Maps
      profileFor: json['profile_for'] is Map
          ? ProfileFor.fromJson(json['profile_for'])
          : null,
      profilesetting: json['profileSettings'] is Map
          ? ProfileSettings.fromJson(json['profileSettings'])
          : null,
      highestDegree: json['highest_degree'] is Map
          ? HighestDegree.fromJson(json['highest_degree'])
          : null,

      occupation: json['occupation'] is Map
          ? OccupationModel.fromJson(json['occupation'])
          : null,

      locCity: json['loc_city'] is Map
          ? LocationModel.fromJson(json['loc_city'])
          : null,

      locState: json['loc_state'] is Map
          ? LocationModel.fromJson(json['loc_state'])
          : null,

      birthCity: json['birth_city'] is Map
          ? LocationModel.fromJson(json['birth_city'])
          : null,

      birthState: json['birth_state'] is Map
          ? LocationModel.fromJson(json['birth_state'])
          : null,
      photorequestcheck: json['photo_request_check'],
      photo: json['photo'],
      photo1: json['photo1'],
      photo2: json['photo2'],
      photo3: json['photo3'],
      photo4: json['photo4'],
      photoBlur: json['photo_blur'],
      aasherno: json['aadhaar_no'] ?? "",
      interestsentstatus: json['interest_sent_status'] ?? "",
      shortlistsent: json['shortlist_sent'] ?? '',
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

class ProfileFor {
  final String? id;
  final String? name;

  ProfileFor({this.id, this.name});

  factory ProfileFor.fromJson(Map<String, dynamic> json) =>
      ProfileFor(id: json['_id'], name: json['name']);
}

class HighestDegree {
  final String? id;
  final String? name;
  final int? educationType;

  HighestDegree({this.id, this.name, this.educationType});

  factory HighestDegree.fromJson(Map<String, dynamic> json) => HighestDegree(
    id: json['_id'],
    name: json['name'],
    educationType: json['education_type'],
  );
}

class OccupationModel {
  final String? id;
  final String? name;

  OccupationModel({this.id, this.name});

  factory OccupationModel.fromJson(Map<String, dynamic> json) =>
      OccupationModel(id: json['_id'], name: json['name']);
}

class LocationModel {
  final String? id;
  final String? name;

  LocationModel({this.id, this.name});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      LocationModel(id: json['_id'], name: json['name']);
}

class ReligionModel {
  final String? id;
  final String? name;

  ReligionModel({this.id, this.name});

  factory ReligionModel.fromJson(Map<String, dynamic> json) =>
      ReligionModel(id: json['_id'], name: json['name']);
}
