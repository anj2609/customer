import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryController extends GetxController {
  var countryList = <CountryModel>[].obs;

  var selectedCountryId = "".obs;
  var selectedCountryName = RxnString();

  @override
  void onInit() {
    fetchCountries();
    super.onInit();
  }

  Future<void> fetchCountries() async {
    final url =
        "https://testing.akslearning.in/vivashribackend/api/front/country";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      countryList.value = List.from(
        jsonData["data"],
      ).map((e) => CountryModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedCountryId.value = id;

    var model = countryList.firstWhere((e) => e.id == id);
    selectedCountryName.value = model.name;

    print("COUNTRY ID = ${selectedCountryId.value}");
  }
}

class CountryModel {
  final String id;
  final String name;

  CountryModel({required this.id, required this.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(id: json["_id"], name: json["name"]);
  }
}
