class SearchListModel {
  bool status;
  List<MatchListData> data;
  int total;
  int page;
  int totalPages;
  bool hasMore;

  SearchListModel({
    required this.status,
    required this.data,
    required this.total,
    required this.page,
    required this.totalPages,
    required this.hasMore,
  });

  factory SearchListModel.fromJson(Map<String, dynamic> json) {
    return SearchListModel(
      status: json["status"] ?? false,
      data: json["data"] == null
          ? []
          : List<MatchListData>.from(
              json["data"].map((x) => MatchListData.fromJson(x)),
            ),
      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      totalPages: json["totalPages"] ?? 0,
      hasMore: json["hasMore"] ?? false,
    );
  }
}

class MatchListData {
  String id;
  String? name;
  String? gender;
  String? profileId;
  String? dob;
  double? height;
  String? religion;
  String? caste;
  String? manglik;
  String? occupation;
  String? income;
  String? city;
  String? photo;
  String? profileManagedBy;

  MatchListData({
    required this.id,
    this.name,
    this.gender,
    this.profileId,
    this.dob,
    this.height,
    this.religion,
    this.caste,
    this.manglik,
    this.occupation,
    this.income,
    this.city,
    this.photo,
    this.profileManagedBy,
  });

  factory MatchListData.fromJson(Map<String, dynamic> json) {
    return MatchListData(
      id: json["_id"] ?? "",
      name: json["name"] ?? "N/A",
      gender: json["gender"] ?? "N/A",
      profileId: json["profile_id"] ?? "N/A",
      dob: json["dob"] ?? "",
      height: json["height"] != null
          ? double.tryParse(json["height"].toString())
          : null,
      religion: json["religion"]?["name"] ?? "N/A",
      caste: json["caste"] ?? "N/A",
      manglik: json["manglik"] ?? "N/A",
      occupation: json["partner_occupation"] ?? "N/A",
      income: json["annual_income"] ?? "N/A",
      city: json["loc_city"]?["name"] ?? "N/A",
      photo: json["photo"] ?? "",
      profileManagedBy: json["profile_for"]?["name"] ?? "N/A",
    );
  }
}
