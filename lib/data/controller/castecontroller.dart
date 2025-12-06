import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CasteController extends GetxController {
  var casteList = <CasteModel>[].obs;

  var selectedCasteId = "".obs;
  var selectedCasteName = RxnString();
  var selectedReligionId = "".obs;

  Future<void> fetchCaste(String religionId) async {
    selectedCasteId.value = "";
    selectedCasteName.value = null;

    final url =
        "https://vivashri.com/vivashribackend/api/front/caste/$religionId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      casteList.value = List.from(
        jsonData["data"],
      ).map((e) => CasteModel.fromJson(e)).toList();
    }
  }

  /// ID-based selection (correct)
  void onSelect(String id) {
    selectedCasteId.value = id;

    var model = casteList.firstWhere((e) => e.id == id);

    selectedCasteName.value = model.name;
    selectedReligionId.value = model.religionId;

    print("CASTE ID = ${selectedCasteId.value}");
    print("RELIGION ID = ${selectedReligionId.value}");
  }
}

class CasteModel {
  final String id;
  final String name;
  final String religionId;

  CasteModel({required this.id, required this.name, required this.religionId});

  factory CasteModel.fromJson(Map<String, dynamic> json) {
    return CasteModel(
      id: json["_id"],
      name: json["name"],
      religionId: json["religion_id"],
    );
  }
}
