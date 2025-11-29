import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HobbyController extends GetxController {
  var hobbyList = <HobbyModel>[].obs;
  var selectedHobbyIds = <String>[].obs;   // <-- store selected IDs

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

      hobbyList.value = List.from(jsonData["data"])
          .map((e) => HobbyModel.fromJson(e))
          .toList();
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
}
class HobbyModel {
  final String id;
  final String name;

  HobbyModel({
    required this.id,
    required this.name,
  });

  factory HobbyModel.fromJson(Map<String, dynamic> json) {
    return HobbyModel(
      id: json["_id"],
      name: json["name"],
    );
  }
}
