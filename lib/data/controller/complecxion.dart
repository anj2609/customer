import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComplexionController extends GetxController {
  var complexionList = <ComplexionModel>[].obs;

  var selectedComplexionId = "".obs;
  var selectedComplexionName = RxnString();

  var selectedComplexionId2 = "".obs;
  var selectedComplexionName2 = RxnString();

  @override
  void onInit() {
    fetchComplexion();
    super.onInit();
  }

  Future<void> fetchComplexion() async {
    final url =
        "https://vivashri.com/vivashribackend/api/front/complexion";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      complexionList.value = List.from(
        jsonData["data"],
      ).map((e) => ComplexionModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedComplexionId.value = id;

    var selected = complexionList.firstWhere((e) => e.id == id);
    selectedComplexionName.value = selected.name;

    print("COMPLEXION SELECTED ID = ${selectedComplexionId.value}");
    print("COMPLEXION NAME = ${selectedComplexionName.value}");
  }

  void onSelect2222(String id) {
    selectedComplexionId2.value = id;

    var selected = complexionList.firstWhere((e) => e.id == id);
    selectedComplexionName2.value = selected.name;

    print("COMPLEXION SELECTED ID = ${selectedComplexionId2.value}");
    print("COMPLEXION NAME = ${selectedComplexionName2.value}");
  }
}

class ComplexionModel {
  final String id;
  final String name;

  ComplexionModel({required this.id, required this.name});

  factory ComplexionModel.fromJson(Map<String, dynamic> json) {
    return ComplexionModel(id: json["_id"], name: json["name"]);
  }
}
