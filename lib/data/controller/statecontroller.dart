import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StateController extends GetxController {
  var stateList = <StateModel>[].obs;

  var selectedStateId = "".obs;
  var sameselectedStateId = "".obs;

  var selectedName = RxnString();
  var sameselectedName = RxnString();

  var selectedCountryId = "".obs;
    var sameselectedCountryId = "".obs;


  @override
  void onInit() {
    fetchStates();
    super.onInit();
  }

  Future<void> fetchStates() async {
    final url =
        "https://vivashri.com/vivashribackend/api/front/state";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      stateList.value = List.from(
        jsonData["data"],
      ).map((e) => StateModel.fromJson(e)).toList();
    }
  }

  /// ✅ ID-based selection (Correct)
  void onSelect(String id) {
    selectedStateId.value = id;

    var model = stateList.firstWhere((e) => e.id == id);
    selectedName.value = model.name;
    selectedCountryId.value = model.countryId;

    print("STATE ID = ${selectedStateId.value}");
    print("COUNTRY ID = ${selectedCountryId.value}");
  }
    void onSelect22(String id) {
    sameselectedStateId.value = id;

    var model = stateList.firstWhere((e) => e.id == id);
    sameselectedName.value = model.name;
    sameselectedCountryId.value = model.countryId;

    print("STATE ID = ${sameselectedStateId.value}");
    print("COUNTRY ID = ${sameselectedCountryId.value}");
  }
}

class StateModel {
  final String id;
  final String name;
  final String countryId;

  StateModel({required this.id, required this.name, required this.countryId});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json["_id"],
      name: json["name"],
      countryId: json["country_id"],
    );
  }
}
