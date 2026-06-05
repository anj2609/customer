class SettingModel {
  String? code;
  String? message;
  SettingDetails? data;

  SettingModel({this.code, this.message, this.data});

  SettingModel.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    message = json['message'];
    data = json['data'] != null
        ? SettingDetails.fromJson(json['data'])
        : null;
  }
}

class SettingDetails {
  int? id;
  String? email;
  String? mobile;
  String? websiteUrl;
  String? facebookUrl;
  String? instagramUrl;
  String? twitterUrl;
  String? linkedinUrl;
  String? youtubeUrl;
  String? createdAt;
  String? updatedAt;

  SettingDetails({
    this.id,
    this.email,
    this.mobile,
    this.websiteUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.linkedinUrl,
    this.youtubeUrl,
    this.createdAt,
    this.updatedAt,
  });

  SettingDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    mobile = json['mobile'];
    websiteUrl = json['website_url'];
    facebookUrl = json['facebook_url'];
    instagramUrl = json['instagram_url'];
    twitterUrl = json['twitter_url'];
    linkedinUrl = json['linkedin_url'];
    youtubeUrl = json['youtube_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}