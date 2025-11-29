import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityController extends GetxController {
  var cityList = <CityModel>[].obs;

  var selectedCityId = "".obs;
  var selectedCityName = RxnString();

  Future<void> fetchCity(String stateId) async {
    selectedCityId.value = "";
    selectedCityName.value = null;

    final url =
        "https://testing.akslearning.in/vivashribackend/api/front/city/$stateId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      cityList.value = List.from(
        jsonData["data"],
      ).map((e) => CityModel.fromJson(e)).toList();
    }
  }

  void onSelect(String id) {
    selectedCityId.value = id;

    var model = cityList.firstWhere((e) => e.id == id);
    selectedCityName.value = model.name;

    print("CITY ID = ${selectedCityId.value}");
  }
}

class CityModel {
  final String id;
  final String name;
  final String stateId;

  CityModel({required this.id, required this.name, required this.stateId});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json["_id"],
      name: json["name"],
      stateId: json["state_id"],
    );
  }
}
