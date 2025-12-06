import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfessionalEduController extends GetxController {
  var profEduList = <ProfessionalEduModel>[].obs;

  var selectedProfEduId = "".obs;
  var selectedProfEduName = RxnString();

  @override
  void onInit() {
    fetchProfessionalEducation();
    super.onInit();
  }

  Future<void> fetchProfessionalEducation() async {
    final url =
        "https://vivashri.com/vivashribackend/api/front/professional-education";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      profEduList.value = List.from(
        jsonData["data"],
      ).map((e) => ProfessionalEduModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedProfEduId.value = id;

    var selected = profEduList.firstWhere((e) => e.id == id);

    selectedProfEduName.value = selected.name;

    print("PROF EDUCATION ID = ${selectedProfEduId.value}");
    print("PROF EDUCATION NAME = ${selectedProfEduName.value}");
  }
}

class ProfessionalEduModel {
  final String id;
  final String name;

  ProfessionalEduModel({required this.id, required this.name});

  factory ProfessionalEduModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalEduModel(id: json["_id"], name: json["name"]);
  }
}
