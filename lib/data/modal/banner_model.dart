class BannerModel {
  int? id;
  String? title;
  String? subTitle;
  String? image;

  BannerModel({this.id, this.title, this.subTitle, this.image});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    title = json['title']?.toString();
    subTitle = json['sub_title']?.toString();
    image = json['image']?.toString();
  }
}
