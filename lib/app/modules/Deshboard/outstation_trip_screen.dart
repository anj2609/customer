import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:myrideuser/app/modules/Deshboard/outstation_vehicle_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

enum _ActiveField { none, from, to }

/// Trip planner for N Ride Outstation. No outstation booking backend exists
/// yet, so trip type and leave-now/later are local UI state only, but the
/// from/to location pickers are real — same Places Autocomplete pattern used
/// on the main dashboard — since location isn't fabricated data.
class OutstationTripScreen extends StatefulWidget {
  const OutstationTripScreen({super.key});

  @override
  State<OutstationTripScreen> createState() => _OutstationTripScreenState();
}

class _OutstationTripScreenState extends State<OutstationTripScreen> {
  bool _oneWay = true;
  bool _leaveNow = true;
  int _days = 1;
  DateTime? _scheduledDateTime;

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  LatLng? _fromLatLng;
  LatLng? _toLatLng;
  bool _loadingCurrentLocation = true;

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
      }
    } catch (e) {
      debugPrint("Outstation current location error: $e");
      if (mounted) setState(() => _loadingCurrentLocation = false);
    }
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
    } catch (e) {
      debugPrint("Outstation place select error: $e");
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _pickSchedule() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;
    if (!mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      _leaveNow = false;
      _scheduledDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  String get _scheduleApiFormat {
    final dt = _scheduledDateTime;
    if (dt == null) return "";
    return "${dt.year}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}:00";
  }

  String get _scheduleDisplayLabel {
    final dt = _scheduledDateTime;
    if (dt == null) return "Later";
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final period = dt.hour >= 12 ? "PM" : "AM";
    final minute = dt.minute.toString().padLeft(2, '0');
    return "${dt.day}/${dt.month} · $hour12:$minute $period";
  }

  void _onSearchRides() {
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
        message: "Please set a destination",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!_leaveNow && _scheduledDateTime == null) {
      AnimatedTopToast.show(
        context: context,
        message: "Please pick a date & time",
        backgroundColor: ColorResources.textColorRed,
        icon: Icons.error_outline,
      );
      return;
    }
    Get.to(() => OutstationVehicleScreen(
          fromAddress: _fromController.text,
          toAddress: _toController.text,
          fromLatLng: _fromLatLng,
          toLatLng: _toLatLng,
          tripType: _oneWay ? 'one_way' : 'round_trip',
          estimatedDays: _oneWay ? 1 : _days,
          isSchedule: !_leaveNow,
          scheduleDateTime: _scheduleApiFormat,
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
                      "Plan your Outstation trip",
                      style: PoppinsBold.copyWith(
                        fontSize: 24,
                        color: ColorResources.blackcolor11,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ColorResources.backgroundColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          _tripTypeOption("One way", _oneWay, () {
                            setState(() => _oneWay = true);
                          }),
                          _tripTypeOption("Round trip", !_oneWay, () {
                            setState(() => _oneWay = false);
                          }),
                        ],
                      ),
                    ),
                    if (!_oneWay) ...[
                      const SizedBox(height: 14),
                      _dayStepper(),
                    ],
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
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _timeOption(
                          icon: Icons.access_time_rounded,
                          label: "Leave now",
                          selected: _leaveNow,
                          onTap: () => setState(() => _leaveNow = true),
                        ),
                        const SizedBox(width: 10),
                        _timeOption(
                          icon: Icons.calendar_month_rounded,
                          label: _scheduleDisplayLabel,
                          selected: !_leaveNow,
                          onTap: _pickSchedule,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomPrimaryDyanamicButton(
                text: "Search rides",
                onTap: _onSearchRides,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shown only for Round trip — how many days the outstation trip spans,
  /// sent to the backend as estimated_days.
  Widget _dayStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: ColorResources.backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.date_range_rounded, size: 18, color: ColorResources.TextColorForGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _days == 1 ? "1 day" : "$_days days",
              style: PoppinsMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackcolor11,
              ),
            ),
          ),
          GestureDetector(
            onTap: _days > 1 ? () => setState(() => _days--) : null,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: ColorResources.whiteColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove_rounded,
                size: 18,
                color: _days > 1
                    ? ColorResources.blackcolor11
                    : ColorResources.TextColorForGrey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _days < 30 ? () => setState(() => _days++) : null,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: ColorResources.whiteColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                size: 18,
                color: _days < 30
                    ? ColorResources.blackcolor11
                    : ColorResources.TextColorForGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tripTypeOption(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? ColorResources.blueeebutton : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: PoppinsMedium.copyWith(
              fontSize: 14,
              color: selected ? ColorResources.whiteColor : ColorResources.blackcolor11,
            ),
          ),
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

  Widget _timeOption({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? ColorResources.blueeebutton.withValues(alpha: 0.08)
              : ColorResources.backgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? ColorResources.blueeebutton : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? ColorResources.blueeebutton : ColorResources.TextColorForGrey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: PoppinsMedium.copyWith(
                fontSize: 14,
                color: selected ? ColorResources.blueeebutton : ColorResources.blackcolor11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
