import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/dimensions.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';
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

  // This app operates in Tripura only — search results outside it are not
  // actionable (see _isLocationAllowed below, which already rejected a
  // booking whose pickup/drop were both outside the allowed area). That
  // check ran only *after* a result was tapped, though; the autocomplete
  // list itself was unrestricted — one call scoped to the whole of India
  // (components=country:in) and the other to the entire world with no
  // scoping at all — so a rider could type a city name anywhere on Earth
  // and see it suggested, tap it, and only then learn it wasn't served.
  //
  // Google's legacy Autocomplete API (the endpoint already in use here) has
  // no state/region-level restriction — `components` only goes down to
  // country. The closest real restriction it supports is a location+radius
  // circle with strictbounds=true, which turns that circle from a mere
  // ranking bias into a hard filter. Centred and sized to cover Tripura's
  // full extent (bounding box roughly 22.98–24.53°N, 91.15–92.35°E — this
  // circle necessarily over-covers the corners a little, since Tripura's
  // shape isn't a circle, and Tripura is bordered by Bangladesh on three
  // sides, which components=country:in below is what actually excludes).
  static const double _tripuraCenterLat = 23.76;
  static const double _tripuraCenterLng = 91.75;
  static const int _tripuraRadiusMeters = 110000;

  /// Appended to every Autocomplete request below.
  static const String _tripuraLocationParams =
      '&location=$_tripuraCenterLat,$_tripuraCenterLng'
      '&radius=$_tripuraRadiusMeters'
      '&strictbounds=true'
      '&components=country:in';

  String currentAddress = "Loading...";
  LatLng? currentLatLng;
  String? _currentAdminArea;

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

    _currentAdminArea = place.administrativeArea;
    print('DEBUG: Current admin area detected: $_currentAdminArea');

    setState(() {
      currentAddress = widget.addressdata?.isNotEmpty == true
          ? widget.addressdata!
          : "${place.name}, ${place.locality}, ${place.administrativeArea}";
    });
  }

  Future<void> searchPlaces(String input) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey$_tripuraLocationParams";

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
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey$_tripuraLocationParams";

    var response = await http.get(Uri.parse(url));

    var data = jsonDecode(response.body);

    setState(() {
      predictions = data["predictions"];
    });
  }

  /// ================= GET PLACE LAT LNG =================
  Future<void> getPlaceDetail(String placeId) async {
    if (_isCheckingLocation) return;
    setState(() => _isCheckingLocation = true);

    try {
      String url =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";

      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);

      var location = data["result"]["geometry"]["location"];
      LatLng selectedLatLng = LatLng(location["lat"], location["lng"]);

      // If current location hasn't been determined yet, try to fetch it now
      if (_currentAdminArea == null && currentLatLng == null) {
        try {
          await getCurrentLocation();
        } catch (_) {}
      }

      // Check destination state from the selected place's address components
      String? destAdminArea;
      if (data["result"]["address_components"] != null) {
        for (var component in data["result"]["address_components"]) {
          List types = component["types"] ?? [];
          if (types.contains("administrative_area_level_1")) {
            destAdminArea = component["long_name"];
            break;
          }
        }
      }

      // If we still don't have current location info, try reverse geocoding
      if (_currentAdminArea == null && currentLatLng != null) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            currentLatLng!.latitude,
            currentLatLng!.longitude,
          );
          if (placemarks.isNotEmpty) {
            _currentAdminArea = placemarks.first.administrativeArea;
          }
        } catch (_) {}
      }

      // Allow ride if either pickup or destination is in an allowed state
      // If we couldn't determine the current area, don't block the user
      final bool pickupAllowed = _currentAdminArea == null || _isLocationAllowed(_currentAdminArea);
      final bool destAllowed = destAdminArea == null || _isLocationAllowed(destAdminArea);

      if (!pickupAllowed && !destAllowed) {
        AnimatedTopToast.show(
          context: context,
          message:
              "Sorry! We are not available in this location at the moment.",
          backgroundColor: ColorResources.textColorBaclColor,
          icon: Icons.location_off_outlined,
        );
        return;
      }

      Get.find<BookingController>().bookingestimateListApi(
        pickup_lat: currentLatLng!.latitude,
        pickup_lng: currentLatLng!.longitude,
        drop_lat: selectedLatLng.latitude,
        drop_lng: selectedLatLng.longitude,
        context: context,
      );
    } catch (e) {
      AnimatedTopToast.show(
        context: context,
        message: "Could not verify location. Please try again.",
        backgroundColor: ColorResources.textColorBaclColor,
        icon: Icons.error_outline,
      );
    } finally {
      if (mounted) setState(() => _isCheckingLocation = false);
    }
  }

  Future<void> _saveRecentSearch(String name, String description) async {
    final prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString('recent_searches');
    List<dynamic> list = stored != null ? jsonDecode(stored) : [];
    list.removeWhere((item) => item['description'] == description);
    list.insert(0, {'name': name, 'description': description});
    if (list.length > 5) list = list.sublist(0, 5);
    await prefs.setString('recent_searches', jsonEncode(list));
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  bool isSearching = false;
  bool _isCheckingLocation = false;

  // Was ['delhi', 'tripura'] — this app is strictly Tripura-only, so 'delhi'
  // let a pickup or drop in Delhi silently pass the one safety check this
  // screen already had, even though nothing else about this service
  // operates there.
  static const List<String> _allowedStates = ['tripura'];

  bool _isLocationAllowed(String? administrativeArea) {
    if (administrativeArea == null || administrativeArea.isEmpty) return false;
    final lower = administrativeArea.toLowerCase();
    return _allowedStates.any((s) => lower.contains(s));
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Where do you want to go?")),
      body: Column(
        children: [
          /// ===== TOP: Input fields (fixed height) =====
          Container(
            margin: const EdgeInsets.all(Dimensions.spacingSize16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.spacingSize16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pickup location row / search field
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
                        Icon(Icons.my_location, color: ColorResources.blueeebutton),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            currentAddress,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const Icon(Icons.edit, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),

                if (isSearching)
                  TextField(
                    controller: currentlocaController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search pickup location...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            isSearching = false;
                            predictions.clear();
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

                const Divider(),

                // Destination search field
                TextField(
                  controller: searchController,
                  onChanged: searchPlace,
                  decoration: InputDecoration(
                    hintText: "Where to?",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.spacingSize12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ===== BOTTOM: Results list (fills remaining space) =====
          if (_isCheckingLocation)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(strokeWidth: 2),
                    SizedBox(height: 12),
                    Text(
                      "Checking availability...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  var place = predictions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(place["structured_formatting"]["main_text"]),
                    subtitle: Text(place["description"]),
                    onTap: () {
                      if (isSearching) {
                        // User is editing pickup location
                        getPlaceDetails(place["place_id"]).then((_) {
                          setState(() {
                            currentAddress = place['description'];
                            isSearching = false;
                            predictions.clear();
                          });
                        });
                      } else {
                        // User is selecting destination
                        _saveRecentSearch(
                          place["structured_formatting"]["main_text"],
                          place["description"],
                        );
                        getPlaceDetail(place["place_id"]);
                      }
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
