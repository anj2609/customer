import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OccupationController extends GetxController {
  var occupationList = <OccupationModel>[].obs;

  var selectedOccId = "".obs;
  var selectedOccName = RxnString();

  var selectedOccId2 = "".obs;
  var selectedOccName2 = RxnString();

  @override
  void onInit() {
    fetchOccupation();
    super.onInit();
  }

  Future<void> fetchOccupation() async {
    final url =
        "https://vivashri.com/vivashribackend/api/front/occupation";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      occupationList.value = List.from(
        jsonData["data"],
      ).map((e) => OccupationModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedOccId.value = id;

    var selected = occupationList.firstWhere((e) => e.id == id);

    selectedOccName.value = selected.name;

    print("OCCUPATION ID = ${selectedOccId.value}");
    print("OCCUPATION NAME = ${selectedOccName.value}");
  }

  void onSelect2(String id) {
    selectedOccId2.value = id;

    var selected = occupationList.firstWhere((e) => e.id == id);

    selectedOccName2.value = selected.name;

    print("OCCUPATION ID = ${selectedOccId2.value}");
    print("OCCUPATION NAME = ${selectedOccName2.value}");
  }
}

class OccupationModel {
  final String id;
  final String name;

  OccupationModel({required this.id, required this.name});

  factory OccupationModel.fromJson(Map<String, dynamic> json) {
    return OccupationModel(id: json["_id"], name: json["name"]);
  }
}
