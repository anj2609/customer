import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HobbyController extends GetxController {
  var hobbyList = <HobbyModel>[].obs;
  var selectedHobbyIds = <String>[].obs;
  var selectedHobbyIds222 = <String>[].obs;

  @override
  void onInit() {
    fetchHobbies();
    super.onInit();
  }

  Future<void> fetchHobbies() async {
    final url =
        "https://testing.akslearning.in/vivashribackend/api/front/hobbies";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      hobbyList.value = List.from(
        jsonData["data"],
      ).map((e) => HobbyModel.fromJson(e)).toList();
    }
  }

  void toggleHobby(String id) {
    if (selectedHobbyIds.contains(id)) {
      selectedHobbyIds.remove(id);
    } else {
      selectedHobbyIds.add(id);
    }

    print("Selected Hobby IDs = $selectedHobbyIds");
  }

  void toggleHobby22(String id) {
    if (selectedHobbyIds222.contains(id)) {
      selectedHobbyIds222.remove(id);
    } else {
      selectedHobbyIds222.add(id);
    }

    print("Selected Hobby IDs = $selectedHobbyIds222");
  }
}

class HobbyModel {
  final String id;
  final String name;

  HobbyModel({required this.id, required this.name});

  factory HobbyModel.fromJson(Map<String, dynamic> json) {
    return HobbyModel(id: json["_id"], name: json["name"]);
  }
}
