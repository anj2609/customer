import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MaritalStatusController extends GetxController {
  var maritalList = <MaritalModel>[].obs;
  var selectedName = RxnString();
  var selectedId = "".obs;

  @override
  void onInit() {
    fetchMaritalStatus();
    super.onInit();
  }

  Future<void> fetchMaritalStatus() async {
    final url =
        "https://testing.akslearning.in/vivashribackend/api/front/marital-status";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      maritalList.value = List.from(
        jsonData["data"],
      ).map((e) => MaritalModel.fromJson(e)).toList();
    }
  }

  void onSelect(String name) {
    selectedName.value = name;

    var item = maritalList.firstWhere((e) => e.name == name);
    selectedId.value = item.id;

    print("MARITAL SELECTED ID = ${selectedId.value}");
  }
}

class MaritalModel {
  final String id;
  final String name;

  MaritalModel({required this.id, required this.name});

  factory MaritalModel.fromJson(Map<String, dynamic> json) {
    return MaritalModel(id: json["_id"], name: json["name"]);
  }
}
