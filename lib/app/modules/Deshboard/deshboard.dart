import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:evfual/app/modules/Deshboard/search_screen.dart';
import 'package:evfual/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:evfual/config/route.dart';
import 'package:evfual/config/utils/app_constants.dart';
import 'package:evfual/config/utils/colors.dart';
import 'package:evfual/config/utils/helper/get_di.dart' as di;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GoogleMapController? mapController;

  LatLng? currentLocation;

  final CameraPosition initialCamera = const CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 14,
  );

  BitmapDescriptor? carIcon;
  BitmapDescriptor? userIcon;
  bool isLoadingLocation = true;

  Set<Marker> markers = {};

  Timer? carTimer;

  // Dummy nearby cars
  List<LatLng> carPositions = [];

  @override
  void initState() {
    super.initState();
    loadCustomMarkers();
    checkLocationPermission();
  }

  // ================= LOAD CUSTOM ICONS =================

  Future<void> loadCustomMarkers() async {
    carIcon = await getResizedMarker("assets/images/cars.png", 150);

    // carIcon = await BitmapDescriptor.fromAssetImage(
    //   const ImageConfiguration(size: Size(10, 100)),
    //   "assets/images/cars.png",

    // );

    userIcon = await createUserMarker();

    setState(() {});
  }

  Future<BitmapDescriptor> getResizedMarker(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: width, // 👈 yaha size control hota hai
    );

    final ui.FrameInfo fi = await codec.getNextFrame();
    final Uint8List resizedBytes = (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  // ================= USER PHOTO MARKER =================

  Future<BitmapDescriptor> createUserMarker() async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    const size = 150.0;

    final Paint paint = Paint()..color = Colors.blue;

    // Outer circle
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);

    final image = await loadNetworkImage(
      "assets/images/profile.png",
    ); // demo profile image

    paintImage(
      canvas: canvas,
      rect: const Rect.fromLTWH(15, 15, 120, 120),
      image: image,
      fit: BoxFit.cover,
    );

    final img = await recorder.endRecording().toImage(150, 150);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<ui.Image> loadNetworkImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });

    return completer.future;
  }

  // Future<ui.Image> loadNetworkImage(String url) async {
  //   final completer = Completer<ui.Image>();
  //   final image = NetworkImage(url);
  //   image.resolve(const ImageConfiguration()).addListener(
  //     ImageStreamListener((info, _) {
  //       completer.complete(info.image);
  //     }),
  //   );
  //   return completer.future;
  // }
  Future<void> getCurrentLocations() async {
    setState(() {
      isLoadingLocation = true; // Loader show
    });

    await Future.delayed(const Duration(seconds: 2)); // 2 sec delay

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLocation = LatLng(pos.latitude, pos.longitude);

    generateNearbyCars();

    mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));

    setState(() {
      isLoadingLocation = false; // Loader hide
    });
  }
  // ================= LOCATION =================

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever)
      return;

    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLocation = LatLng(pos.latitude, pos.longitude);

    generateNearbyCars();

    mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));

    setState(() {});
  }

  // ================= GENERATE RANDOM CARS =================

  void generateNearbyCars() {
    if (currentLocation == null) return;

    final random = Random();

    carPositions = List.generate(5, (index) {
      double lat =
          currentLocation!.latitude + (random.nextDouble() - 0.5) / 500;
      double lng =
          currentLocation!.longitude + (random.nextDouble() - 0.5) / 500;
      return LatLng(lat, lng);
    });

    startCarAnimation();
  }

  void startCarAnimation() {
    carTimer?.cancel();
    carTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final random = Random();

      for (int i = 0; i < carPositions.length; i++) {
        carPositions[i] = LatLng(
          carPositions[i].latitude + (random.nextDouble() - 0.5) / 1000,
          carPositions[i].longitude + (random.nextDouble() - 0.5) / 1000,
        );
      }
      setState(() {});
    });
  }

  // ================= MARKERS =================

  Set<Marker> buildMarkers() {
    final Set<Marker> m = {};

    if (currentLocation != null && userIcon != null) {
      m.add(
        Marker(
          markerId: const MarkerId("user"),
          position: currentLocation!,
          icon: userIcon!,
        ),
      );
    }

    if (carIcon != null) {
      for (int i = 0; i < carPositions.length; i++) {
        m.add(
          Marker(
            markerId: MarkerId("car_$i"),
            position: carPositions[i],
            icon: carIcon!,
            rotation: Random().nextDouble() * 360,
          ),
        );
      }
    }

    return m;
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAP
          GoogleMap(
            initialCameraPosition: initialCamera,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: buildMarkers(),
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),

          /// BOTTOM CARD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Where to?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/images/loaction.png"),
                       // Icon(Icons.search),
                        SizedBox(width: 10),
                        Text(
                          "Enter location",
                          style: PoppinsReguler.copyWith(color: ColorResources.textdetailsColor),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  SizedBox(
  height: 50,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      locationItem("Home", true),
      locationItem("Office", false),
      locationItem("Apartment", false),
      locationItem("Mom’s house", false),
    ],
  ),
)

                  // Wrap(
                  //   spacing: 10,
                  //   children: [locationChip("Home"), locationChip("Office"), locationChip("Apartment")],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget locationItem(String text, bool isSelected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      color: isSelected ? ColorResources.blueeebutton : ColorResources.backgroundColor,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(
        color: isSelected ? ColorResources.blueeebutton : ColorResources.backgroundColor,
      ),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
  
  // Widget chip(String text) {
  //   return Chip(label: Text(text),
  //    backgroundColor: Colors.grey.shade200);
  // }
}
// GoogleMapController? mapController;

// LatLng? currentLocation;
// LatLng? destinationLocation;

// final CameraPosition initialCamera = const CameraPosition(
//   target: LatLng(28.6139, 77.2090),
//   zoom: 14,
// );

// @override
// void initState() {
//   super.initState();
//   checkLocationPermission();
// }

// /// ================= LOCATION PERMISSION =================
// Future<void> checkLocationPermission() async {
//   LocationPermission permission = await Geolocator.checkPermission();

//   if (permission == LocationPermission.denied ||
//       permission == LocationPermission.deniedForever) {
//     showLocationPopup();
//   } else {
//     getCurrentLocation();
//   }
// }

// /// ================= POPUP =================
// void showLocationPopup() {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.location_on, size: 60, color: Colors.blue),
//               const SizedBox(height: 20),
//               const Text(
//                 "Enable Location",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "To use service we need your location permission",
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   await Geolocator.requestPermission();
//                   getCurrentLocation();
//                 },
//                 child: const Text("Grant Permission"),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Maybe Later"),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

// /// ================= GET CURRENT LOCATION =================
// Future<void> getCurrentLocation() async {
//   Position pos = await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );

//   currentLocation = LatLng(pos.latitude, pos.longitude);

//   setState(() {});

//   mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
// }

// /// ================= MARKERS =================
// Set<Marker> getMarkers() {
//   Set<Marker> markers = {};

//   if (currentLocation != null) {
//     markers.add(
//       Marker(markerId: const MarkerId("current"), position: currentLocation!),
//     );
//   }

//   if (destinationLocation != null) {
//     markers.add(
//       Marker(
//         markerId: const MarkerId("dest"),
//         position: destinationLocation!,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       ),
//     );
//   }

//   return markers;
// }

// /// ================= UI =================
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Stack(
//       children: [
//         /// ===== MAP =====
//         GoogleMap(
//           initialCameraPosition: initialCamera,
//           myLocationEnabled: true,
//           markers: getMarkers(),
//           onMapCreated: (c) => mapController = c,
//         ),

//         /// ===== BOTTOM SEARCH BOX =====
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             height: 200,
//             padding: const EdgeInsets.all(15),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Where to?",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 /// ===== CLICK OPEN SEARCH PAGE =====
//                 GestureDetector(
//                   onTap: () async {
//                     LatLng? result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const SearchLocationScreen(),
//                       ),
//                     );

//                     if (result != null) {
//                       destinationLocation = result;
//                       setState(() {});
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Row(
//                       children: [
//                         Icon(Icons.search),
//                         SizedBox(width: 10),
//                         Text("Enter location"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );

/// =================================================
/// ================= SEARCH SCREEN =================
/// =================================================

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  TextEditingController searchController = TextEditingController();

  List predictions = [];
  String apiKey = "AIzaSyAv-WwyCAZ5rJArnCELEtTalFrSBmcyLgk";

  String currentAddress = "Loading...";
  LatLng? currentLatLng;

  /// ================= CURRENT LOCATION =================
  Future<void> getCurrentLocation() async {
    Position pos = await Geolocator.getCurrentPosition();

    currentLatLng = LatLng(pos.latitude, pos.longitude);

    setState(() {
      currentAddress = "Your current location";
    });
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RideOptionScreen(
          destination: selectedLatLng,
          pickup: currentLatLng!,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Where do you want to go?")),
      body: Column(
        children: [
          /// ===== TOP CARD (Screenshot जैसा) =====
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                /// CURRENT LOCATION
                Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(child: Text(currentAddress)),
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
                      borderRadius: BorderRadius.circular(12),
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

////-==-=-=-=-=-=-=--=-----=--=offer screen=-=-=-=-=-=-=-=-=-=-=-=-=-=

class PromosScreen extends StatefulWidget {
  const PromosScreen({super.key});

  @override
  State<PromosScreen> createState() => _PromosScreenState();
}

class _PromosScreenState extends State<PromosScreen> {
  int selectedTab = 0;

  final List<String> tabs = ["All", "Discount", "Cashback", "Partnership"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            /// ✅ TOP BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: Text(
                      "My",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Promos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert),
                ],
              ),
            ),

            /// ✅ PROMO CODE CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.discount, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Have a Promo Code?",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Enter your promo code here",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// ✅ TABS
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedTab == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            /// ✅ PROMO LIST
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: const [
                  PromoCard(
                    title: "Best Deal: 20% OFF",
                    subtitle: "End of year promo, 20% discount on all services",
                    code: "EOYP25",
                    image: "assets/images/car1.jpg",
                    percent: "20% OFF",
                    label1: "BEST DEAL",
                    label2: "END OF YEAR PROMO",
                  ),

                  SizedBox(height: 20),

                  PromoCard(
                    title: "15% OFF",
                    subtitle: "Special offer for new users only",
                    code: "NUP15K",
                    image: "assets/images/car2.jpg",
                    percent: "15% OFF",
                    label1: "SPECIAL OFFER",
                    label2: "FOR NEW USER ONLY",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ PROMO CARD WIDGET
class PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String code;
  final String image;
  final String percent;
  final String label1;
  final String label2;

  const PromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.code,
    required this.image,
    required this.percent,
    required this.label1,
    required this.label2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _tag(label1),
                const SizedBox(height: 6),
                _tag(label2),
                const Spacer(),
                Text(
                  percent,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _tag("CODE   $code"),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      color: Colors.blue,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}

class RideItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String time;
  final String rightDate;
  final IconData icon;

  const RideItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.time,
    required this.rightDate,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        Row(
          children: [
            /// LEFT CIRCLE ICON
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(icon, color: Colors.blue),
            ),

            const SizedBox(width: 12),

            /// TITLE + SUBTITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subTitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            /// RIGHT SIDE TIME + DATE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  rightDate,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }
}
////////////////////////////////////////////////////////////
/// ✅ COMPLETED TAB
////////////////////////////////////////////////////////////

class CompletedWidget extends StatelessWidget {
  const CompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No Completed Rides", style: TextStyle(color: Colors.grey)),
    );
  }
}

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              /// 🔹 TOP BAR
              Row(
                children: const [
                  Icon(Icons.arrow_back),
                  Spacer(),
                  Text(
                    "Activity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Icon(Icons.more_vert),
                ],
              ),

              const SizedBox(height: 15),

              /// 🔹 MAIN CARD
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    const Center(
                      child: Text(
                        "Your Scheduled Ride",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Center(
                      child: Text(
                        "Monday, Mar 21 - 16:00 PM",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 BLUE INFO BAR
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "We'll notify you when a driver's found",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 CAB DETAIL BOX
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/images/cab.png", height: 40),
                          const SizedBox(width: 10),

                          const Expanded(
                            child: Text(
                              "Cab Economy (Non-AC)\n3-5 mins  •  4 passengers",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),

                          const Text(
                            "₹ 448",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 ROUTE BOX
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Expanded(child: Text("Bobst Library")),
                            ],
                          ),
                          Divider(),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Expanded(child: Text("Larchmont Hotel")),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// 🔹 DETAILS CARD
                    _infoRow("Status", "Scheduled", isBadge: true),
                    _infoRow("Payment", "MyRide Wallet"),
                    _infoRow("Date", "Mar 21, 2026"),
                    _infoRow("Time", "16:00 PM"),
                    _infoRow("Transaction ID", "TRX12222240941"),
                    _infoRow("Booking ID", "BKG720469"),

                    const SizedBox(height: 15),

                    /// 🔹 FARE SUMMARY
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Column(
                        children: [
                          _FareRow("Trip Fair", "₹ 560"),
                          Divider(),
                          _FareRow("Discount (25%)", "₹ 112"),
                          Divider(),
                          _FareRow("Total Paid", "₹ 448", bold: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔹 SHARE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          showDriverFoundSheet(context);
                        },
                        child: const Text(
                          "Share Receipt",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 CANCEL BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Cancel Ride",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDriverFoundSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            /// MAIN CONTAINER
            Container(
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "We’ve found the driver!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),
                  Divider(color: Colors.grey.shade300),

                  const SizedBox(height: 15),

                  /// DRIVER ROW
                  Row(
                    children: [
                      /// DRIVER IMAGE
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(
                          "assets/images/profile.png",
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// DRIVER DETAILS
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Troska Sangam  ⭐ 4.8",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Tata Tigor, White  ·  TR 05 CB 2446",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// CHAT BUTTON
                      Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// SHARE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Share Receipt",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// TOP FLOATING ICON
            Container(
              height: 110,
              width: 110,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 55),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 INFO ROW
  Widget _infoRow(String title, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),
          isBadge
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                )
              : Text(value),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 FARE ROW WIDGET
////////////////////////////////////////////////////////////

class _FareRow extends StatelessWidget {
  final String title;
  final String price;
  final bool bold;

  const _FareRow(this.title, this.price, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Text(
          price,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
//account setting=-=-=-=-==-=-=-=-=-=

////////////////////////////////////////////////////////////
/// MODEL (DYNAMIC SETTINGS ITEM)
////////////////////////////////////////////////////////////

class SettingModel {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SettingModel({required this.icon, required this.title, required this.onTap});
}

////////////////////////////////////////////////////////////
/// MAIN SCREEN
////////////////////////////////////////////////////////////

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔥 DYNAMIC SETTINGS LIST
    final List<SettingModel> settings = [
      SettingModel(
        icon: Icons.location_on_outlined,
        title: "Saved Addresses",
        onTap: () => _open(context, "Saved Addresses"),
      ),
      SettingModel(
        icon: Icons.notifications_none,
        title: "Notifications",
        onTap: () => _open(context, "Notifications"),
      ),
      SettingModel(
        icon: Icons.credit_card,
        title: "Payment n Methods",
        onTap: () => _open(context, "Payment Methods"),
      ),
      SettingModel(
        icon: Icons.shield_outlined,
        title: "Account & Security",
        onTap: () => _open(context, "Account & Security"),
      ),
      SettingModel(
        icon: Icons.sync_alt,
        title: "Linked Accounts",
        onTap: () => _open(context, "Linked Accounts"),
      ),
      SettingModel(
        icon: Icons.remove_red_eye_outlined,
        title: "App Appearance",
        onTap: () => _open(context, "App Appearance"),
      ),
      SettingModel(
        icon: Icons.bar_chart,
        title: "Data & Analytics",
        onTap: () => _open(context, "Data & Analytics"),
      ),
      SettingModel(
        icon: Icons.help_outline,
        title: "Help & Support",
        onTap: () => _open(context, "Help & Support"),
      ),
      SettingModel(
        icon: Icons.star_border,
        title: "Rate us",
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Open Play Store Rating")),
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              ////////////////////////////////////////////////////////////
              /// 🔹 TOP BAR
              ////////////////////////////////////////////////////////////
              Row(
                children: const [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: Text(
                      "My Ride",
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Icon(Icons.more_vert),
                ],
              ),

              const SizedBox(height: 15),

              ////////////////////////////////////////////////////////////
              /// 🔹 PROFILE + WALLET CARD
              ////////////////////////////////////////////////////////////
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(
                            "assets/images/profile.png",
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ansh Saxena",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "+91 987-654-3210",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),

                    const SizedBox(height: 15),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹ 3582.67",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Available balance",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Text("Top Up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              ////////////////////////////////////////////////////////////
              /// 🔹 SETTINGS LIST (DYNAMIC)
              ////////////////////////////////////////////////////////////
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    ...settings.map((e) => SettingTile(model: e)).toList(),
                    const LogoutTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// NAVIGATION HELPER
  ////////////////////////////////////////////////////////////

  void _open(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DummyPage(title: title)),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 SETTING TILE
////////////////////////////////////////////////////////////

class SettingTile extends StatelessWidget {
  final SettingModel model;

  const SettingTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(model.icon),
      title: Text(
        model.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: model.onTap,
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 LOGOUT TILE
////////////////////////////////////////////////////////////

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "Logout",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Logged out")));
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔹 DUMMY PAGE (FOR NAVIGATION TEST)
////////////////////////////////////////////////////////////

class DummyPage extends StatelessWidget {
  final String title;

  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
