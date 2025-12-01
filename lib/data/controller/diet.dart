import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DietController extends GetxController {
  var dietList = <DietModel>[].obs;

  var selectedDietId = "".obs;
  var selectedDietName = RxnString();

  @override
  void onInit() {
    fetchDiet();
    super.onInit();
  }

  Future<void> fetchDiet() async {
    final url = "https://testing.akslearning.in/vivashribackend/api/front/diet";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      dietList.value = List.from(
        jsonData["data"],
      ).map((e) => DietModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedDietId.value = id;

    var selected = dietList.firstWhere((e) => e.id == id);
    selectedDietName.value = selected.name;

    print("DIET ID = ${selectedDietId.value}");
    print("DIET NAME = ${selectedDietName.value}");
  }
}

class DietModel {
  final String id;
  final String name;

  DietModel({required this.id, required this.name});

  factory DietModel.fromJson(Map<String, dynamic> json) {
    return DietModel(id: json["_id"], name: json["name"]);
  }
}
