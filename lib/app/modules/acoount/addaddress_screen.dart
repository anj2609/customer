import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/data/controller/addaddress_controller.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/modal/addaddress_model.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class AddAddresScreen extends StatefulWidget {
  bool? isEdit;
  int? index;
  AddressModel? address;
  AddAddresScreen({super.key, this.isEdit, this.index, this.address});
  @override
  State<AddAddresScreen> createState() => _AddAddresScreenState();
}

class _AddAddresScreenState extends State<AddAddresScreen> {
  //  final AddressController controller = Get.find();

  GoogleMapController? mapController;
  CameraPosition? _lastCameraPosition;

  TextEditingController searchController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  String address = "";
  double? lat;
  double? lng;

  LatLng initialPosition = const LatLng(28.6139, 77.2090);

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    // 🔥 Update UI when floor number changes
    detailController.addListener(() {
      setState(() {});
    });
  }

  /// GET CURRENT USER LOCATION
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permission denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permission permanently denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    lat = position.latitude;
    lng = position.longitude;

    // mapController?.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(target: currentLatLng, zoom: 16),
    //   ),
    // );

    await getAddress(currentLatLng);
  }

  /// GET ADDRESS FROM LAT LNG
  Future<void> getAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      setState(() {
        lat = position.latitude;
        lng = position.longitude;

        address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

        // if (nameController.text.isEmpty) {
        //   nameController.text = place.name ?? "";
        // }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (controllerMap) async {
                      mapController = controllerMap;
                      await getCurrentLocation();
                    },
                    onCameraMove: (position) {
                      _lastCameraPosition = position;
                    },
                    onCameraIdle: () async {
                      if (_lastCameraPosition != null) {
                        await getAddress(_lastCameraPosition!.target);
                      }
                    },
                  ),
                ),

                /// SEARCH FIELD
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: GooglePlaceAutoCompleteTextField(
                    textEditingController: searchController,
                    googleAPIKey: "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU",

                    inputDecoration: InputDecoration(
                      hintText: "Search for location",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    debounceTime: 800,
                    countries: ["in"],
                    isLatLngRequired: true,
                    getPlaceDetailWithLatLng: (prediction) async {
                      if (prediction.lat != null && prediction.lng != null) {
                        double newLat = double.parse(prediction.lat!);
                        double newLng = double.parse(prediction.lng!);

                        LatLng newPosition = LatLng(newLat, newLng);

                        mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: newPosition, zoom: 17),
                          ),
                        );

                        setState(() {
                          lat = newLat;
                          lng = newLng;
                          searchController.text = prediction.description ?? "";
                        });

                        await getAddress(newPosition);
                      }
                    },
                    itemClick: (prediction) {
                      searchController.text = prediction.description ?? "";
                      searchController.selection = TextSelection.fromPosition(
                        TextPosition(offset: searchController.text.length),
                      );
                    },
                  ),
                ),

                Center(
                  child: Icon(Icons.location_pin, size: 40, color: ColorResources.textColorRed),
                ),
              ],
            ),

            /// FORM SECTION
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Add an Address",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ADDRESS CARD
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: ColorResources.blueeebutton),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            address.isEmpty
                                ? "Select location"
                                : detailController.text.trim().isNotEmpty
                                ? "${detailController.text.trim()}, $address"
                                : address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text("Name"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Mom's House",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text("Address Details"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: detailController,
                    decoration: InputDecoration(
                      hintText: "Floor, unit number",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: CustomSecondaryDynamicButton(
                          text: "Cancel",
                          onTap: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: CustomPrimaryDyanamicButton(
                          text: "Save Address",
                          onTap: () async {
                            if (address.isEmpty || lat == null || lng == null) {
                              Get.snackbar("Error", "Please select address");
                              return;
                            }
                            // String finalAddress =
                            //     detailController.text.trim().isNotEmpty
                            //     ? "${detailController.text.trim()}, $address"
                            //     : address;
                            // Get.find<ProfileController>().addAddressCustomer(
                            //   context: context,
                            //   label: nameController.text.trim(),
                            //   address: finalAddress,
                            //   lat: lat!,
                            //   lng: lng!,
                            // );

                            try {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => PremiumBlurLoader(),
                              );

                              String finalAddress =
                                  detailController.text.trim().isNotEmpty
                                  ? "${detailController.text.trim()}, $address"
                                  : address;
                              await Get.find<ProfileController>()
                                  .addAddressCustomer(
                                context: context,
                                label: nameController.text.trim(),
                                address: finalAddress,
                                lat: lat!,
                                lng: lng!,
                              );
                            } catch (e) {
                              debugPrint('address update Error: $e');
                            } finally {
                              if (Get.isDialogOpen ?? false) {
                                Get.back();
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
