import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:myrideuser/app/modules/Deshboard/rentals_vehicle_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

enum _ActiveField { none, from, to }

/// Pickup/drop-off picker for N Ride Rentals, inserted between the duration
/// step and vehicle selection since create-booking requires real
/// pickup_address/drop_address (and lng) — same Places Autocomplete pattern
/// used on the main dashboard and the Outstation flow.
class RentalsLocationScreen extends StatefulWidget {
  final int hours;

  const RentalsLocationScreen({super.key, required this.hours});

  @override
  State<RentalsLocationScreen> createState() => _RentalsLocationScreenState();
}

class _RentalsLocationScreenState extends State<RentalsLocationScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  LatLng? _fromLatLng;
  LatLng? _toLatLng;
  bool _loadingCurrentLocation = true;
  GoogleMapController? _mapController;

  _ActiveField _activeField = _ActiveField.none;
  List predictions = [];
  bool _isSearching = false;

  final String _placesApiKey = "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (mounted) setState(() => _loadingCurrentLocation = false);
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latLng = LatLng(pos.latitude, pos.longitude);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );

      if (mounted) {
        setState(() {
          _fromLatLng = latLng;
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            _fromController.text =
                "${place.name}, ${place.locality}, ${place.administrativeArea}";
          } else {
            _fromController.text = "Current location";
          }
          _loadingCurrentLocation = false;
        });
        _updateCamera();
      }
    } catch (e) {
      debugPrint("Rentals current location error: $e");
      if (mounted) setState(() => _loadingCurrentLocation = false);
    }
  }

  /// Pins the map on whatever is currently known — just pickup, just
  /// drop-off, or both (fit to bounds) once the user has set both.
  void _updateCamera() {
    if (_mapController == null) return;
    if (_fromLatLng != null && _toLatLng != null) {
      final southwest = LatLng(
        _fromLatLng!.latitude < _toLatLng!.latitude ? _fromLatLng!.latitude : _toLatLng!.latitude,
        _fromLatLng!.longitude < _toLatLng!.longitude ? _fromLatLng!.longitude : _toLatLng!.longitude,
      );
      final northeast = LatLng(
        _fromLatLng!.latitude > _toLatLng!.latitude ? _fromLatLng!.latitude : _toLatLng!.latitude,
        _fromLatLng!.longitude > _toLatLng!.longitude ? _fromLatLng!.longitude : _toLatLng!.longitude,
      );
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(LatLngBounds(southwest: southwest, northeast: northeast), 60),
      );
    } else if (_fromLatLng != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(_fromLatLng!, 14));
    } else if (_toLatLng != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(_toLatLng!, 14));
    }
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    if (_fromLatLng != null) {
      markers.add(Marker(
        markerId: const MarkerId('rentals_pickup'),
        position: _fromLatLng!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    }
    if (_toLatLng != null) {
      markers.add(Marker(
        markerId: const MarkerId('rentals_dropoff'),
        position: _toLatLng!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
    return markers;
  }

  void _startEditing(_ActiveField field) {
    setState(() {
      _activeField = field;
      predictions = [];
    });
  }

  void _stopEditing() {
    setState(() {
      _activeField = _ActiveField.none;
      predictions = [];
    });
  }

  Future<void> _searchPlaces(String input) async {
    if (input.isEmpty) {
      setState(() => predictions = []);
      return;
    }
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_placesApiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() => predictions = data["predictions"] ?? []);
      }
    }
  }

  Future<void> _selectPrediction(dynamic place) async {
    setState(() => _isSearching = true);
    try {
      final placeId = place["place_id"];
      final url =
          "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_placesApiKey";
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      final loc = data['result']['geometry']['location'];
      final latLng = LatLng(loc['lat'], loc['lng']);
      final description = place['description'] ?? "";

      if (!mounted) return;
      setState(() {
        if (_activeField == _ActiveField.from) {
          _fromLatLng = latLng;
          _fromController.text = description;
        } else if (_activeField == _ActiveField.to) {
          _toLatLng = latLng;
          _toController.text = description;
        }
        _activeField = _ActiveField.none;
        predictions = [];
      });
      _updateCamera();
    } catch (e) {
      debugPrint("Rentals place select error: $e");
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _onContinue() {
    if (_fromLatLng == null || _fromController.text.trim().isEmpty) {
      AnimatedTopToast.show(
        context: context,
        message: "Please set a pickup location",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (_toLatLng == null || _toController.text.trim().isEmpty) {
      AnimatedTopToast.show(
        context: context,
        message: "Please set a drop-off location",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return;
    }
    Get.to(() => RentalsVehicleScreen(
          hours: widget.hours,
          fromAddress: _fromController.text,
          toAddress: _toController.text,
          fromLatLng: _fromLatLng,
          toLatLng: _toLatLng,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorResources.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ColorResources.blackcolor11,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pickup & drop-off",
                      style: PoppinsBold.copyWith(
                        fontSize: 24,
                        color: ColorResources.blackcolor11,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: ColorResources.backgroundColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          _locationRow(
                            field: _ActiveField.from,
                            controller: _fromController,
                            icon: Icons.radio_button_checked_rounded,
                            iconColor: ColorResources.blueeebutton,
                            hint: "Where from?",
                            loading: _loadingCurrentLocation,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Divider(height: 1, color: ColorResources.greycolorborder),
                          ),
                          _locationRow(
                            field: _ActiveField.to,
                            controller: _toController,
                            icon: Icons.square_rounded,
                            iconColor: ColorResources.textColorRed,
                            hint: "Where to?",
                            loading: false,
                          ),
                        ],
                      ),
                    ),
                    if (_activeField != _ActiveField.none) ...[
                      const SizedBox(height: 8),
                      if (_isSearching)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            final place = predictions[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.location_on_outlined,
                                color: ColorResources.TextColorForGrey,
                              ),
                              title: Text(
                                place["structured_formatting"]?["main_text"] ??
                                    place["description"] ??
                                    "",
                                style: PoppinsMedium.copyWith(
                                  fontSize: 14,
                                  color: ColorResources.blackcolor11,
                                ),
                              ),
                              subtitle: Text(
                                place["description"] ?? "",
                                style: PoppinsReguler.copyWith(
                                  fontSize: 12,
                                  color: ColorResources.TextColorForGrey,
                                ),
                              ),
                              onTap: () => _selectPrediction(place),
                            );
                          },
                        ),
                    ],
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        height: 180,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _fromLatLng ?? const LatLng(28.5355, 77.3910),
                            zoom: 14,
                          ),
                          markers: _buildMarkers(),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          onMapCreated: (controller) {
                            _mapController = controller;
                            _updateCamera();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomPrimaryDyanamicButton(
                text: "Continue",
                onTap: _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationRow({
    required _ActiveField field,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String hint,
    required bool loading,
  }) {
    final isActive = _activeField == field;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 14),
          Expanded(
            child: isActive
                ? TextField(
                    controller: controller,
                    autofocus: true,
                    style: PoppinsReguler.copyWith(
                      fontSize: 15,
                      color: ColorResources.blackcolor11,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: PoppinsReguler.copyWith(
                        fontSize: 15,
                        color: ColorResources.TextColorForGrey,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length > 2) {
                        _searchPlaces(value);
                      } else {
                        setState(() => predictions = []);
                      }
                    },
                  )
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _startEditing(field),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: loading
                          ? Text(
                              "Locating you...",
                              style: PoppinsReguler.copyWith(
                                fontSize: 15,
                                color: ColorResources.TextColorForGrey,
                              ),
                            )
                          : Text(
                              controller.text.isEmpty ? hint : controller.text,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: PoppinsReguler.copyWith(
                                fontSize: 15,
                                color: controller.text.isEmpty
                                    ? ColorResources.TextColorForGrey
                                    : ColorResources.blackcolor11,
                              ),
                            ),
                    ),
                  ),
          ),
          if (isActive)
            GestureDetector(
              onTap: _stopEditing,
              child: Icon(Icons.close_rounded, size: 18, color: ColorResources.TextColorForGrey),
            ),
        ],
      ),
    );
  }
}
