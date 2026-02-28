import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NearestSwapStationController extends GetxController
    implements GetxService {
  var isLoading = false.obs;
  var stationList = <SwapStationModel>[].obs;

  Future<void> fetchNearestStations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      isLoading(true);

      var response = await http.post(
        Uri.parse("https://evfuel.akslearning.in/api/nearest-swapstation"),
        headers: {"Accept": "application/json"},
        body: {"user_id": token, "latitude": "2323", "longitude": "31233"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List list = data['success']['data'];
        stationList.value = list
            .map((e) => SwapStationModel.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class SwapStationModel {
  final int id;
  final String? latitude;
  final String? longitude;
  final String ownerName;
  final String address;
  final String distance;

  SwapStationModel({
    required this.id,
    this.latitude,
    this.longitude,
    required this.ownerName,
    required this.address,
    required this.distance,
  });

  factory SwapStationModel.fromJson(Map<String, dynamic> json) {
    return SwapStationModel(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      ownerName: json['owner_name'] ?? '',
      address: json['address'] ?? '',
      distance: json['distance'] ?? '',
    );
  }
}
