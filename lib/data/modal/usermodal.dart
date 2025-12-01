class UserDetailAllModel {
  final bool? status;
  final List<UserData>? data;

  UserDetailAllModel({this.status, this.data});

  factory UserDetailAllModel.fromJson(Map<String, dynamic> json) {
    return UserDetailAllModel(
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<UserData>.from(
              json["data"].map((x) => UserData.fromJson(x))),
    );
  }
}

class UserData {
  final String? id;
  final String? email;
  final String? mobile;
  final String? otp;
  final String? otpExpireAt;
  final List<dynamic>? hobbies;
  final dynamic gotra;
  final dynamic ugDegree;
  final dynamic pgDegree;
  final List<dynamic>? partnerHobbies;
  final List<dynamic>? partnerMaritalStatus;
  final dynamic partnerGotra;
  final dynamic homeRegId;
  final dynamic appStep;
  final String? deviceToken;
  final String? formStatus;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final bool? interestSent;
  final bool? planDetail;
  final dynamic interestUser;
  final dynamic totalUserView;
  final int? totalRecentUserView;

  UserData({
    this.id,
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
    this.interestSent,
    this.planDetail,
    this.interestUser,
    this.totalUserView,
    this.totalRecentUserView,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["_id"],
      email: json["email"] ?? "",
      mobile: json["mobile"] ?? "",
      otp: json["otp"],
      otpExpireAt: json["otp_expire_at"],
      hobbies: json["hobbies"] ?? [],
      gotra: json["gotra"],
      ugDegree: json["ug_degree"],
      pgDegree: json["pg_degree"],
      partnerHobbies: json["partner_hobbies"] ?? [],
      partnerMaritalStatus: json["partner_marital_status"] ?? [],
      partnerGotra: json["partner_gotra"],
      homeRegId: json["home_reg_id"],
      appStep: json["app_step"],
      deviceToken: json["device_token"],
      formStatus: json["form_status"],
      status: json["status"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      interestSent: json["interest_sent"],
      planDetail: json["plan_detail"],
      interestUser: json["interest_user"],
      totalUserView: json["total_user_view"],
      totalRecentUserView: json["totalRecentUserView"],
    );
  }
}
