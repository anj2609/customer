class PromoDetailsModel {
  final int? id;
  final String? category;
  final String? name;
  final String? title;
  final String? shortDescription;
  final String? priceOff;
  final String? code;
  final String? details;
  final String? startDate;
  final String? endDate;
  final bool? status;

  PromoDetailsModel({
    this.id,
    this.category,
    this.name,
    this.title,
    this.shortDescription,
    this.priceOff,
    this.code,
    this.details,
    this.startDate,
    this.endDate,
    this.status,
  });

  factory PromoDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return PromoDetailsModel(
      id: data['id'],
      category: data['category'],
      name: data['name'],
      title: data['title'],
      shortDescription: data['short_description'],
      priceOff: data['price_off'],
      code: data['code'],
      details: data['details'],
      startDate: data['start_date'],
      endDate: data['end_date'],
      status: data['status'],
    );
  }
}
