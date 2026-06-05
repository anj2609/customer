class FaqModel {
  String? code;
  String? message;
  List<FqlModel>? data;

  FaqModel({this.code, this.message, this.data});

  FaqModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FqlModel>[];
      json['data'].forEach((v) {
        data!.add(FqlModel.fromJson(v));
      });
    }
  }
}

class FqlModel {
  int? id;
  String? type;
  String? question;
  String? answer;
  int? status;
  String? createdAt;
  String? updatedAt;

  FqlModel({
    this.id,
    this.type,
    this.question,
    this.answer,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  FqlModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    question = json['question'];
    answer = json['answer'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}