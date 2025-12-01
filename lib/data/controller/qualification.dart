import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EducationController extends GetxController {
  var educationList = <EducationModel>[].obs;

  var selectedEduId = "".obs;
  var selectedEduName = RxnString();

  @override
  void onInit() {
    fetchEducation();
    super.onInit();
  }

  Future<void> fetchEducation() async {
    final url =
        "https://testing.akslearning.in/vivashribackend/api/front/education";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      educationList.value = List.from(
        jsonData["data"],
      ).map((e) => EducationModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedEduId.value = id;

    var selected = educationList.firstWhere((e) => e.id == id);
    selectedEduName.value = selected.name;

    print("EDUCATION SELECTED ID = ${selectedEduId.value}");
    print("EDUCATION NAME = ${selectedEduName.value}");
  }
}

class EducationModel {
  final String id;
  final String name;
  final int type;

  EducationModel({required this.id, required this.name, required this.type});

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json["_id"],
      name: json["name"],
      type: json["education_type"],
    );
  }
}
