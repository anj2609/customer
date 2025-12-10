// class SearchListModel {
//   final bool? status;
//   final List<MatchListData>? data;
//   final List<MatchListData>? usersBride;
//   final List<MatchListData>? usersGrooms;

//   SearchListModel({this.status, this.data, this.usersBride, this.usersGrooms});

//   factory SearchListModel.fromJson(Map<String, dynamic> json) {
//     return SearchListModel(
//       status: json['status'],
//       data: (json['data'] as List?)
//           ?.map((e) => MatchListData.fromJson(e))
//           .toList(),
//       usersBride: (json['usersBride'] as List?)
//           ?.map((e) => MatchListData.fromJson(e))
//           .toList(),
//       usersGrooms: (json['usersGrooms'] as List?)
//           ?.map((e) => MatchListData.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'status': status,
//     'data': data?.map((e) => e.toJson()).toList(),
//     'usersBride': usersBride?.map((e) => e.toJson()).toList(),
//     'usersGrooms': usersGrooms?.map((e) => e.toJson()).toList(),
//   };
// }

// class MatchListData {
//   final String? id;
//   final String? profileId;
//   final String? email;
//   final String? mobile;
//   final String? about;

//   final String? gender;
//   final String? manglik;
//   final String? maritalStatus;
//   final String? name;

//   final String? deviceToken;
//   final String? profilePhoto;
//   // final ReligionModel? religion;
//   final String? caste;
//   final String? dob;

//   final dynamic weight;
//   final double? height;
//   final bool? interestSent;

//   final List<String>? partnerHobbies;
//   final List<String>? partnerMaritalStatus;
//   final List<String>? hobbies;

//   final ProfileFor? profileFor;
//   final HighestDegree? highestDegree;
//   final OccupationModel? occupation;
//   final LocationModel? locCity;
//   final LocationModel? locState;
//   final LocationModel? birthCity;
//   final LocationModel? birthState;

//   final String? photo;
//   final String? photo1;
//   final String? photoBlur;

//   MatchListData({
//     this.id,
//     this.profileId,
//     this.email,
//     this.mobile,
//     this.about,

//     this.gender,
//     this.manglik,
//     this.maritalStatus,
//     this.name,

//     this.deviceToken,
//     this.profilePhoto,
//     // this.religion,
//     this.caste,
//     this.dob,

//     this.weight,
//     this.height,
//     this.interestSent,
//     this.partnerHobbies,
//     this.partnerMaritalStatus,
//     this.hobbies,
//     this.profileFor,
//     this.highestDegree,
//     this.occupation,
//     this.locCity,
//     this.locState,
//     this.birthCity,
//     this.birthState,
//     this.photo,
//     this.photo1,
//     this.photoBlur,
//   });

//   factory MatchListData.fromJson(Map<String, dynamic> json) {
//     return MatchListData(
//       id: json['_id'],
//       profileId: json['profile_id'],
//       email: json['email'],
//       mobile: json['mobile'],
//       about: json['about'],

//       gender: json['gender'],
//       manglik: json['manglik'],
//       maritalStatus: json['marital_status'],
//       name: json['name'],

//       deviceToken: json['device_token'],
//       profilePhoto: json['profile_photo']?.toString(),
//       // religion: json['religion'] != null && json['religion'] is Map
//       //     ? ReligionModel.fromJson(json['religion'])
//       //     : null,
//       caste: json['caste']?.toString(),
//       dob: json['dob'],

//       weight: json['weight'],
//       height: json['height'] == null
//           ? null
//           : double.tryParse(json['height'].toString()),
//       interestSent: json['interest_sent'] ?? false,

//       hobbies: (json['hobbies'] as List?)?.map((e) => e.toString()).toList(),
//       partnerHobbies: (json['partner_hobbies'] as List?)
//           ?.map((e) => e.toString())
//           .toList(),
//       partnerMaritalStatus: (json['partner_marital_status'] as List?)
//           ?.map((e) => e.toString())
//           .toList(),

//       profileFor: json['profile_for'] != null
//           ? ProfileFor.fromJson(json['profile_for'])
//           : null,
//       highestDegree: json['highest_degree'] != null
//           ? HighestDegree.fromJson(json['highest_degree'])
//           : null,
//       occupation: json['occupation'] != null
//           ? OccupationModel.fromJson(json['occupation'])
//           : null,
//       locCity: json['loc_city'] != null
//           ? LocationModel.fromJson(json['loc_city'])
//           : null,
//       locState: json['loc_state'] != null
//           ? LocationModel.fromJson(json['loc_state'])
//           : null,
//       birthCity: json['birth_city'] != null
//           ? LocationModel.fromJson(json['birth_city'])
//           : null,
//       birthState: json['birth_state'] != null
//           ? LocationModel.fromJson(json['birth_state'])
//           : null,

//       photo: json['photo'],
//       photo1: json['photo1'],
//       photoBlur: json['photo_blur'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     '_id': id,
//     'profile_id': profileId,
//     'email': email,
//     'mobile': mobile,
//     'about': about,

//     'gender': gender,
//     'manglik': manglik,
//     'marital_status': maritalStatus,
//     'name': name,

//     'device_token': deviceToken,
//     'profile_photo': profilePhoto,
//     // 'religion': religion,
//     'caste': caste,
//     'dob': dob,

//     'weight': weight,
//     'height': height,
//     'interest_sent': interestSent,
//     'hobbies': hobbies,
//     'partner_hobbies': partnerHobbies,
//     'partner_marital_status': partnerMaritalStatus,
//     'profile_for': profileFor?.toJson(),
//     'highest_degree': highestDegree?.toJson(),
//     'occupation': occupation?.toJson(),
//     'loc_city': locCity?.toJson(),
//     'loc_state': locState?.toJson(),
//     'birth_city': birthCity?.toJson(),
//     'birth_state': birthState?.toJson(),
//     'photo': photo,
//     'photo1': photo1,
//     'photo_blur': photoBlur,
//   };
// }

// // -------- ProfileFor ----------
// class ProfileFor {
//   final String? id;
//   final String? name;

//   ProfileFor({this.id, this.name});

//   factory ProfileFor.fromJson(Map<String, dynamic> json) =>
//       ProfileFor(id: json['_id'], name: json['name']);

//   Map<String, dynamic> toJson() => {'_id': id, 'name': name};
// }

// // -------- HighestDegree ----------
// class HighestDegree {
//   final String? id;
//   final String? name;
//   final int? educationType;

//   HighestDegree({this.id, this.name, this.educationType});

//   factory HighestDegree.fromJson(Map<String, dynamic> json) {
//     return HighestDegree(
//       id: json['_id'],
//       name: json['name'],
//       educationType: json['education_type'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     '_id': id,
//     'name': name,
//     'education_type': educationType,
//   };
// }

// // -------- Occupation ----------
// class OccupationModel {
//   final String? id;
//   final String? name;

//   OccupationModel({this.id, this.name});

//   factory OccupationModel.fromJson(Map<String, dynamic> json) {
//     return OccupationModel(id: json['_id'], name: json['name']);
//   }

//   Map<String, dynamic> toJson() => {'_id': id, 'name': name};
// }

// // -------- Location ----------
// class LocationModel {
//   final String? id;
//   final String? name;

//   LocationModel({this.id, this.name});

//   factory LocationModel.fromJson(Map<String, dynamic> json) =>
//       LocationModel(id: json['_id'], name: json['name']);

//   Map<String, dynamic> toJson() => {'_id': id, 'name': name};
// }

// class ReligionModel {
//   final String? id;
//   final String? name;

//   ReligionModel({this.id, this.name});

//   factory ReligionModel.fromJson(Map<String, dynamic> json) =>
//       ReligionModel(id: json['_id'], name: json['name']);

//   Map<String, dynamic> toJson() => {'_id': id, 'name': name};
// }
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
    this.photo3,
    this.photo4,
    this.photoBlur,
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

      photo: json['photo'],
      photo1: json['photo1'],
      photo2: json['photo2'],
      photo3: json['photo3'],
      photo4: json['photo4'],
      photoBlur: json['photo_blur'],
    );
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
