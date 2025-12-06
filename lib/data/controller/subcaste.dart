import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubCasteController extends GetxController {
  var subCasteList = <SubCasteModel>[].obs;

  var selectedSubCasteId = "".obs;
  var selectedSubCasteName = RxnString();

  // fetch based on caste_id
  Future<void> fetchSubCaste(String casteId) async {
    selectedSubCasteId.value = "";
    selectedSubCasteName.value = null;

    final url =
        "https://vivashri.com/vivashribackend/api/front/sub-caste/$casteId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      subCasteList.value = List.from(jsonData["data"])
          .map((e) => SubCasteModel.fromJson(e))
          .toList();
    }
  }

  /// ✅ ID-based onSelect
  void onSelect(String id) {
    selectedSubCasteId.value = id;

    var selected = subCasteList.firstWhere((e) => e.id == id);
    selectedSubCasteName.value = selected.name;

    print("SUB CASTE SELECTED ID = ${selectedSubCasteId.value}");
    print("SUB CASTE NAME = ${selectedSubCasteName.value}");
  }
}

class SubCasteModel {
  final String id;
  final String name;
  final String casteId;

  SubCasteModel({
    required this.id,
    required this.name,
    required this.casteId,
  });

  factory SubCasteModel.fromJson(Map<String, dynamic> json) {
    return SubCasteModel(
      id: json["_id"],
      name: json["name"],
      casteId: json["caste_id"],
    );
  }
}
