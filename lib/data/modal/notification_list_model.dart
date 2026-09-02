class NotificationListModel {
  String? code;
  String? message;
  List<NotificationItemModel>? data;

  NotificationListModel({this.code, this.message, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationItemModel>[];
      json['data'].forEach((v) {
        data!.add(NotificationItemModel.fromJson(v));
      });
    }
  }
}

class NotificationItemModel {
  String? id;
  String? type;
  String? message;
  String? isRead;
  String? date;

  NotificationItemModel({
    this.id,
    this.type,
    this.message,
    this.isRead,
    this.date,
  });

  NotificationItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    message = json['message'];
    isRead = json['is_read'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['type'] = this.type;
    data['message'] = this.message;
    data['is_read'] = this.isRead;
    data['date'] = this.date;
    return data;
  }
}
