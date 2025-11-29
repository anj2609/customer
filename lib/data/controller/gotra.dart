import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GotraController extends GetxController {
  var gotraList = <GotraModel>[].obs;

  var selectedGotraId = "".obs;
  var selectedGotraName = RxnString();

  Future<void> fetchGotra(String subCasteId) async {
    selectedGotraId.value = "";
    selectedGotraName.value = null;

    final url =
        "https://testing.akslearning.in/vivashribackend/api/front/gotra-sub-caste/$subCasteId";

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      gotraList.value = List.from(
        data["data"],
      ).map((e) => GotraModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedGotraId.value = id;

    var model = gotraList.firstWhere((e) => e.id == id);
    selectedGotraName.value = model.name;

    print("GOTRA ID = ${selectedGotraId.value}");
  }
}

class GotraModel {
  final String id;
  final String name;
  //final String subCasteId;

  GotraModel({required this.id, required this.name});

  factory GotraModel.fromJson(Map<String, dynamic> json) {
    return GotraModel(
      id: json["_id"],
      name: json["name"],
      // subCasteId: json["sub_caste_id"],
    );
  }
}
