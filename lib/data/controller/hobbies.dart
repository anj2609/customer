import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HobbyController extends GetxController {
  var hobbyList = <HobbyModel>[].obs;
  var selectedHobbyIds = <String>[].obs; // For Create / Edit
  var selectedHobbyIds222 = <String>[].obs; // (If needed separately)

  @override
  void onInit() {
    fetchHobbies();
    super.onInit();
  }

  Future<void> fetchHobbies() async {
    final url =
        "https://vivashri.com/vivashribackend/api/front/hobbies";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      hobbyList.value = List.from(
        jsonData["data"],
      ).map((e) => HobbyModel.fromJson(e)).toList();
      update();
    }
  }

  // 🔥 SELECT / UNSELECT
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

  void setSelectedHobbiesFromApi(List<dynamic> hobbiesFromApi) {
    selectedHobbyIds.clear();

    for (var h in hobbiesFromApi) {
      // yahan h["_id"] nahi chalega kyunki h Hobby object hai
      selectedHobbyIds.add(h.id.toString());
    }

    print("Default Selected Hobbies = $selectedHobbyIds");
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
