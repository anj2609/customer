import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vivashri/data/modal/usermodal.dart';

class EducationController22222 extends GetxController {
  var educationList = <EducationModel>[].obs;
  var filteredList = <EducationModel>[].obs;

  Rx<EducationModel?> selectedMain = Rx<EducationModel?>(null);
  Rx<EducationModel?> selectedSub = Rx<EducationModel?>(null);
  Rx<EducationModel?> selectedThird = Rx<EducationModel?>(null);

  var isLoading = false.obs;
  var thirdList = <EducationModel>[].obs;

  @override
  void onInit() {
    fetchEducation();
    super.onInit();
  }

  void setSelectedMainFromApi(LookupModel highestDegree) {
    try {
      final id = highestDegree.id ?? "";

      // EducationList me ID match karke same instance pick karo
      final match = educationList.firstWhere(
        (e) => e.id == id,
        orElse: () => null!,
      );

      selectedMain.value = match;
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchEducation() async {
    try {
      isLoading.value = true;

      var response = await http.get(
        Uri.parse(
          "https://vivashri.com/vivashribackend/api/front/education",
        ),
      );

      var jsonData = jsonDecode(response.body);

      if (jsonData["status"] == true) {
        var list = jsonData["data"] as List;
        educationList.value = list
            .map((e) => EducationModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateFilteredList() {
    if (selectedMain.value != null) {
      int type = selectedMain.value!.educationType;

      /// Second dropdown → SAME TYPE
      filteredList.value = educationList
          .where((e) => e.educationType == type)
          .toList();

      /// Third dropdown → OPPOSITE TYPE
      thirdList.value = educationList
          .where((e) => e.educationType != type)
          .toList();
    } else {
      filteredList.clear();
      thirdList.clear();
    }
  }
}

class EducationModel {
  String id;
  String name;
  int educationType;

  EducationModel({
    required this.id,
    required this.name,
    required this.educationType,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      educationType: json["education_type"] ?? 0,
    );
  }
}
