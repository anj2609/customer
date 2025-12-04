import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WorkingWithController extends GetxController {
  var workingList = <WorkingWithModel>[].obs;

  var selectedWorkingId = "".obs;
  var selectedWorkingName = RxnString();

    var selectedWorkingId2 = "".obs;
  var selectedWorkingName2 = RxnString();

  @override
  void onInit() {
    fetchWorkingWith();
    super.onInit();
  }

  Future<void> fetchWorkingWith() async {
    final url =
        "https://testing.akslearning.in/vivashribackend/api/front/working-with";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      workingList.value = List.from(
        jsonData["data"],
      ).map((e) => WorkingWithModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedWorkingId.value = id;

    var selected = workingList.firstWhere((e) => e.id == id);
    selectedWorkingName.value = selected.name;

    print("WORKING WITH ID = ${selectedWorkingId.value}");
    print("WORKING WITH NAME = ${selectedWorkingName.value}");
  }
   void onSelect2(String id) {
    selectedWorkingId2.value = id;

    var selected = workingList.firstWhere((e) => e.id == id);
    selectedWorkingName2.value = selected.name;

    print("WORKING WITH ID = ${selectedWorkingId.value}");
    print("WORKING WITH NAME = ${selectedWorkingName.value}");
  }
}

class WorkingWithModel {
  final String id;
  final String name;

  WorkingWithModel({required this.id, required this.name});

  factory WorkingWithModel.fromJson(Map<String, dynamic> json) {
    return WorkingWithModel(id: json["_id"], name: json["name"]);
  }
}
