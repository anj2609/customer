import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReligionController extends GetxController {
  var religionList = <ReligionModel>[].obs;

  var selectedName = RxnString();
  var selectedId = "".obs;

  @override
  void onInit() {
    fetchReligion();
    super.onInit();
  }

  Future<void> fetchReligion() async {
    final url =
        "https://testing.akslearning.in/vivashribackend/api/front/religion";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      religionList.value = List.from(
        jsonData["data"],
      ).map((e) => ReligionModel.fromJson(e)).toList();
    }
  }

void onSelectById(String id) {
  selectedId.value = id;

  var data = religionList.firstWhere((e) => e.id == id);
  selectedName.value = data.name;

  print("RELIGION SELECTED ID = $id");
}

}

class ReligionModel {
  final String id;
  final String name;

  ReligionModel({required this.id, required this.name});

  factory ReligionModel.fromJson(Map<String, dynamic> json) {
    return ReligionModel(id: json["_id"], name: json["name"]);
  }
}
