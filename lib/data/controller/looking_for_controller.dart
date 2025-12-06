import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LookingForController extends GetxController {
  var lookingList = <LookingForModel>[].obs;
  var selectedName = RxnString();
  var selectedId = "".obs;

  @override
  void onInit() {
    fetchLookingFor();
    super.onInit();
  }

  Future<void> fetchLookingFor() async {
    final url =
        "https://vivashri.com/vivashribackend/api/front/looking-for";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      lookingList.value = List.from(
        jsonData["data"],
      ).map((e) => LookingForModel.fromJson(e)).toList();
    }
  }

  void onSelect(String name) {
    selectedName.value = name;

    var item = lookingList.firstWhere((e) => e.name == name);

    selectedId.value = item.id;

    print("SELECTED ID = ${selectedId.value}");
  }
}

class LookingForModel {
  final String id;
  final String name;

  LookingForModel({required this.id, required this.name});

  factory LookingForModel.fromJson(Map<String, dynamic> json) {
    return LookingForModel(id: json["_id"], name: json["name"]);
  }
}
