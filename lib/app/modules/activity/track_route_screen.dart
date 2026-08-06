import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';

/// In-app pickup → drop route view for a ride — used by the Ongoing tab's
/// "Track Route" button so the user never has to leave the app. Same
/// Directions API + polyline pattern already used on Rentals/Outstation.
class TrackRouteScreen extends StatefulWidget {
  final LatLng pickup;
  final LatLng drop;
  final String pickupAddress;
  final String dropAddress;

  const TrackRouteScreen({
    super.key,
    required this.pickup,
    required this.drop,
    required this.pickupAddress,
    required this.dropAddress,
  });

  @override
  State<TrackRouteScreen> createState() => _TrackRouteScreenState();
}

class _TrackRouteScreenState extends State<TrackRouteScreen> {
  static const String _directionsApiKey =
      "AIzaSyBNHiJLxFa2qcs079P5TaYrB770_CVMldU";

  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  bool _isLoadingRoute = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _drawRoute());
  }

  Future<void> _drawRoute() async {
    try {
      final origin = "${widget.pickup.latitude},${widget.pickup.longitude}";
      final destination = "${widget.drop.latitude},${widget.drop.longitude}";
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$_directionsApiKey";

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      final routePoints = <LatLng>[];
      final routes = data["routes"];
      if (routes != null && routes is List && routes.isNotEmpty) {
        final legs = routes[0]["legs"];
        if (legs != null && legs is List) {
          for (var leg in legs) {
            for (var step in leg["steps"]) {
              final polyline = step["polyline"]["points"];
              final decoded = PolylinePoints.decodePolyline(polyline);
              for (var point in decoded) {
                routePoints.add(LatLng(point.latitude, point.longitude));
              }
            }
          }
        }
      }

      // Fall back to a straight line between pickup/drop if the Directions
      // API returned nothing usable, so the map still shows a route.
      final points = routePoints.isNotEmpty
          ? routePoints
          : [widget.pickup, widget.drop];

      if (mounted) {
        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId("ongoing_ride_route"),
              points: points,
              width: 6,
              color: ColorResources.blueeebutton,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
            ),
          };
          _isLoadingRoute = false;
        });
      }

      await _fitBounds(points);
    } catch (e) {
      debugPrint("Track route draw error: $e");
      if (mounted) {
        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId("ongoing_ride_route"),
              points: [widget.pickup, widget.drop],
              width: 6,
              color: ColorResources.blueeebutton,
            ),
          };
          _isLoadingRoute = false;
        });
      }
      await _fitBounds([widget.pickup, widget.drop]);
    }
  }

  Future<void> _fitBounds(List<LatLng> points) async {
    if (_mapController == null || points.isEmpty) return;
    double minLat = points.first.latitude, maxLat = points.first.latitude;
    double minLng = points.first.longitude, maxLng = points.first.longitude;
    for (final p in points) {
      minLat = p.latitude < minLat ? p.latitude : minLat;
      maxLat = p.latitude > maxLat ? p.latitude : maxLat;
      minLng = p.longitude < minLng ? p.longitude : minLng;
      maxLng = p.longitude > maxLng ? p.longitude : maxLng;
    }
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60),
      );
    } catch (_) {
      // Bounds can be degenerate (pickup == drop); ignore, initial camera
      // position already centers on the pickup point.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Track Route",
          style: PoppinsSemiBold.copyWith(color: ColorResources.blackcolor11),
        ),
        elevation: 0,
        backgroundColor: ColorResources.whiteColor,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.pickup,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('pickup'),
                position: widget.pickup,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                infoWindow: InfoWindow(title: widget.pickupAddress),
              ),
              Marker(
                markerId: const MarkerId('drop'),
                position: widget.drop,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
                infoWindow: InfoWindow(title: widget.dropAddress),
              ),
            },
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              if (!_isLoadingRoute) {
                _fitBounds(
                  _polylines.isNotEmpty
                      ? _polylines.first.points
                      : [widget.pickup, widget.drop],
                );
              }
            },
          ),
          if (_isLoadingRoute)
            const Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              ),
            ),

          /// Pickup / drop address strip at the bottom, same real data
          /// shown on the ride's detail screen.
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ColorResources.whiteColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: ColorResources.blueeebutton,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.pickupAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: PoppinsReguler.copyWith(
                            color: ColorResources.blackcolor11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: ColorResources.textColorRed,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.dropAddress,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: PoppinsReguler.copyWith(
                            color: ColorResources.blackcolor11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
