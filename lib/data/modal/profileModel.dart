class ProfileModels {
  String? code;
  String? message;
  Data? data;

  ProfileModels({this.code, this.message, this.data});

  ProfileModels.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  String? apiToken;
  String? phone;
  String? email;
  String? userType;
  String? gender;
  String? dateOfBirth;
  String? profileImage;

  Data(
      {this.id,
      this.apiToken,
      this.phone,
      this.email,
      this.userType,
      this.gender,
      this.dateOfBirth,
      this.profileImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apiToken = json['api_token'];
    phone = json['phone'];
    email = json['email'];
    userType = json['user_type'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['api_token'] = this.apiToken;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
