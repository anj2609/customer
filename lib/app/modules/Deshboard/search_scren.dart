import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:http/http.dart' as http;

//////// Search Location ===================
class SearchLocationScreen extends StatefulWidget {
  String? addressdata;
  SearchLocationScreen({super.key, this.addressdata});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

///

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController currentlocaController = TextEditingController();

  List predictions = [];
  String apiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";

  String currentAddress = "Loading...";
  LatLng? currentLatLng;

  /// ================= CURRENT LOCATION =================
  Future<void> getCurrentLocation() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLatLng = LatLng(pos.latitude, pos.longitude);

    // Convert lat lng to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );

    Placemark place = placemarks.first;

    setState(() {
      currentAddress = widget.addressdata?.isNotEmpty == true
          ? widget.addressdata!
          : "${place.name}, ${place.locality}, ${place.administrativeArea}";
    });
  }

  Future<void> searchPlaces(String input) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&components=country:in";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        predictions = data['predictions'];
      });
    }
  }

  /// 🔹 Get LatLng from place_id
  Future<void> getPlaceDetails(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final loc = data['result']['geometry']['location'];

      currentLatLng = LatLng(loc['lat'], loc['lng']);
    }
  }

  /// ================= SEARCH API =================
  Future<void> searchPlace(String input) async {
    if (input.isEmpty) {
      setState(() => predictions = []);
      return;
    }

    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey";

    var response = await http.get(Uri.parse(url));

    var data = jsonDecode(response.body);

    setState(() {
      predictions = data["predictions"];
    });
  }

  /// ================= GET PLACE LAT LNG =================
  Future<void> getPlaceDetail(String placeId) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);

    var location = data["result"]["geometry"]["location"];

    LatLng selectedLatLng = LatLng(location["lat"], location["lng"]);
    Get.find<BookingController>().bookingestimateListApi(
      pickup_lat: currentLatLng!.latitude,
      pickup_lng: currentLatLng!.longitude,
      drop_lat: selectedLatLng.latitude,
      drop_lng: selectedLatLng.longitude,
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  bool isSearching = false;

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Where do you want to go?")),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(Dimensions.spacingSize16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.spacingSize16),
            ),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isSearching)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearching = true;
                            currentlocaController.text = currentAddress;
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.my_location, color: Colors.blue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                currentAddress,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),

                    /// 🔍 SEARCH UI
                    if (isSearching)
                      Column(
                        children: [
                          TextField(
                            controller: currentlocaController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Search location...",
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    isSearching = false;
                                  });
                                },
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length > 2) {
                                searchPlaces(value);
                              }
                            },
                          ),

                          const SizedBox(height: 10),

                          /// 🔹 RESULT LIST
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: predictions.length,
                            itemBuilder: (context, index) {
                              final item = predictions[index];

                              return ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text(
                                  item['structured_formatting']['main_text'],
                                ),
                                subtitle: Text(item['description']),
                                onTap: () async {
                                  await getPlaceDetails(item['place_id']);

                                  setState(() {
                                    currentAddress = item['description'];
                                    isSearching = false;
                                    predictions.clear();
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),

                const Divider(),

                /// SEARCH FIELD
                TextField(
                  controller: searchController,
                  onChanged: searchPlace,
                  decoration: InputDecoration(
                    hintText: "Where to?",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.spacingSize12,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ===== LIST =====
          Expanded(
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                var place = predictions[index];

                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(place["structured_formatting"]["main_text"]),
                  subtitle: Text(place["description"]),
                  onTap: () {
                    getPlaceDetail(place["place_id"]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

