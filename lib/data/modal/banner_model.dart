class BannerModel {
  int? id;
  String? title;
  String? subTitle;
  String? image;

  BannerModel({this.id, this.title, this.subTitle, this.image});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    image = json['image'];
  }
}
