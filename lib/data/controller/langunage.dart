import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LanguageController extends GetxController {
  var languageList = <LanguageModel>[].obs;

  var selectedLanguageId = "".obs;
  var motherselectedLanguageId = "".obs;

  var selectedLanguageName = RxnString();
  var morherselectedLanguageName = RxnString();

  @override
  void onInit() {
    fetchLanguages();
    super.onInit();
  }

  Future<void> fetchLanguages() async {
    final url =
        "https://vivashri.com/vivashribackend/api/front/language";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      languageList.value = List.from(
        jsonData["data"],
      ).map((e) => LanguageModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedLanguageId.value = id;

    var model = languageList.firstWhere((e) => e.id == id);
    selectedLanguageName.value = model.name;

    print("LANGUAGE ID = ${selectedLanguageId.value}");
    print("LANGUAGE NAME = ${selectedLanguageName.value}");
  }

  void onSelect22(String id) {
    motherselectedLanguageId.value = id;

    var model = languageList.firstWhere((e) => e.id == id);
    morherselectedLanguageName.value = model.name;

    print("LANGUAGE ID = ${motherselectedLanguageId.value}");
    print("LANGUAGE NAME = ${morherselectedLanguageName.value}");
  }
}

class LanguageModel {
  final String id;
  final String name;

  LanguageModel({required this.id, required this.name});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(id: json["_id"], name: json["name"]);
  }
}
