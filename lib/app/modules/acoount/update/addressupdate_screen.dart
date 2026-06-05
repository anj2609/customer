import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/modal/address_Model.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myrideuser/widgets/custom_loader.dart';

class AddressUpdateScreen extends StatefulWidget {
  final bool? isEdit;
  final int? index;
  final AddressModels? address;

  const AddressUpdateScreen({super.key, this.isEdit, this.index, this.address});

  @override
  State<AddressUpdateScreen> createState() => _AddressUpdateScreenState();
}

class _AddressUpdateScreenState extends State<AddressUpdateScreen> {
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

    /// 🔥 EDIT MODE PREFILL
    if (widget.isEdit == true && widget.address != null) {
      nameController.text = widget.address!.label ?? "";
      address = widget.address!.address ?? "";
      detailController.text = "";

      lat = widget.address!.lat != null
          ? double.tryParse(widget.address!.lat.toString())
          : null;

      lng = widget.address!.lng != null
          ? double.tryParse(widget.address!.lng.toString())
          : null;

      if (lat != null && lng != null) {
        initialPosition = LatLng(lat!, lng!);
      }
    } else {
      getCurrentLocation();
    }

    detailController.addListener(() {
      setState(() {});
    });
  }

  /// GET CURRENT LOCATION
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

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: 16),
      ),
    );

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
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            /// GOOGLE MAP
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialPosition,
                      zoom: 16,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (controllerMap) async {
                      mapController = controllerMap;

                      if (lat != null && lng != null) {
                        mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(lat!, lng!),
                              zoom: 16,
                            ),
                          ),
                        );
                      } else {
                        await getCurrentLocation();
                      }
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
                        });

                        await getAddress(newPosition);
                      }
                    },
                  ),
                ),

                const Center(
                  child: Icon(Icons.location_pin, size: 40, color: Colors.red),
                ),
              ],
            ),

            /// FORM
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.isEdit == true ? "Edit Address" : "Add an Address",
                      style: const TextStyle(
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
                        const Icon(Icons.location_on, color: Colors.blue),
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
                          text: widget.isEdit == true
                              ? "Update Address"
                              : "Save Address",
                          onTap: () {
                            if (address.isEmpty || lat == null || lng == null) {
                              Get.snackbar("Error", "Please select address");
                              return;
                            }

                            String finalAddress =
                                detailController.text.trim().isNotEmpty
                                ? "${detailController.text.trim()}, $address"
                                : address;
                            try {
                              showDialog(
                                context: Get.context!,
                                barrierDismissible: false,
                                builder: (_) => PremiumBlurLoader(),
                              );

                              Get.find<ProfileController>().updateAddress(
                                context: context,
                                address_id: widget.address!.id!,
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
                            // Get.find<ProfileController>().updateAddress(
                            //   context: context,
                            //   address_id: widget.address!.id!,
                            //   label: nameController.text.trim(),
                            //   address: finalAddress,
                            //   lat: lat!,
                            //   lng: lng!,
                            // );
                          },
                        ),
                      ),
                    ],
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
