import 'dart:async';
import 'dart:developer' as developer;

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:myrideuser/data/modal/driveravailable_model.dart';

/// Every state the "find nearby drivers" flow can be in. The UI renders a
/// distinct message for each — in particular, [empty] ("no drivers right
/// now") is never conflated with [locating]/[searching] ("still working")
/// or [requestFailed]/[locationDenied]/[locationTimeout] ("something's
/// actually wrong"), which the old implementation didn't distinguish at
/// all (it just silently showed nothing on any kind of failure).
enum NearbyDriversPhase {
  idle,
  locating,
  searching,
  success,
  empty,
  locationDenied,
  locationTimeout,
  requestFailed,
}

class NearbyDriversState {
  final NearbyDriversPhase phase;
  final List<DriverAvailableDataModel> drivers;
  final LatLng? location;
  final String? message;

  const NearbyDriversState._(
    this.phase, {
    this.drivers = const [],
    this.location,
    this.message,
  });

  factory NearbyDriversState.idle() =>
      const NearbyDriversState._(NearbyDriversPhase.idle);

  factory NearbyDriversState.locating() =>
      const NearbyDriversState._(NearbyDriversPhase.locating);

  factory NearbyDriversState.searching(LatLng location) =>
      NearbyDriversState._(NearbyDriversPhase.searching, location: location);

  factory NearbyDriversState.success(
    List<DriverAvailableDataModel> drivers,
    LatLng location,
  ) => NearbyDriversState._(
    NearbyDriversPhase.success,
    drivers: drivers,
    location: location,
  );

  factory NearbyDriversState.empty(LatLng location) =>
      NearbyDriversState._(NearbyDriversPhase.empty, location: location);

  factory NearbyDriversState.locationDenied([String? message]) =>
      NearbyDriversState._(
        NearbyDriversPhase.locationDenied,
        message: message ?? "Location permission is needed to find nearby drivers.",
      );

  factory NearbyDriversState.locationTimeout([String? message]) =>
      NearbyDriversState._(
        NearbyDriversPhase.locationTimeout,
        message: message ?? "Couldn't get your location. Please try again.",
      );

  factory NearbyDriversState.requestFailed(String message, LatLng? location) =>
      NearbyDriversState._(
        NearbyDriversPhase.requestFailed,
        message: message,
        location: location,
      );

  bool get isLoading =>
      phase == NearbyDriversPhase.locating || phase == NearbyDriversPhase.searching;
}

/// Thin wrapper around the three Geolocator calls this flow needs, so
/// tests can substitute a fake instead of talking to real GPS hardware.
abstract class LocationClient {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<Position> getCurrentPosition({required Duration timeout});
}

class GeolocatorLocationClient implements LocationClient {
  const GeolocatorLocationClient();

  @override
  Future<bool> isLocationServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() => Geolocator.requestPermission();

  @override
  Future<Position> getCurrentPosition({required Duration timeout}) {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(timeout);
  }
}

/// Fetches the nearby-drivers list for a given coordinate. Kept as a plain
/// function type (rather than depending on BookingRepo directly) so tests
/// can supply a fake without constructing the whole repo/API-client chain.
typedef NearbyDriversFetcher = Future<Response> Function(
  double latitude,
  double longitude,
);

/// Step-by-step log hook — defaults to `dart:developer.log` (visible in
/// `flutter logs`/DevTools) but tests can capture it directly instead.
typedef NearbyDriversLogger = void Function(String step, [Map<String, dynamic>? data]);

void _defaultLogger(String step, [Map<String, dynamic>? data]) {
  developer.log(
    data == null ? step : '$step $data',
    name: 'NearbyDriversSearch',
  );
}

/// Owns the whole "find nearby drivers" flow end to end — location capture
/// (with permission/timeout handling), the backend request, and the
/// resulting state — as a single, framework-light, directly unit-testable
/// unit. No Flutter widgets or GetX controller lifecycle involved, only
/// an [Rx] value for whoever wants to react to it.
class NearbyDriversSearch {
  NearbyDriversSearch({
    required this.locationClient,
    required this.fetchNearbyDrivers,
    this.logger = _defaultLogger,
    this.locationTimeout = const Duration(seconds: 15),
    this.autoRefreshInterval = const Duration(seconds: 20),
  });

  final LocationClient locationClient;
  final NearbyDriversFetcher fetchNearbyDrivers;
  final NearbyDriversLogger logger;
  final Duration locationTimeout;
  final Duration autoRefreshInterval;

  final Rx<NearbyDriversState> state = Rx<NearbyDriversState>(
    NearbyDriversState.idle(),
  );

  Timer? _autoRefreshTimer;
  bool _disposed = false;

  /// Runs the full flow once: capture location → request nearby drivers →
  /// update [state]. Safe to call repeatedly (e.g. from a refresh button
  /// or the auto-refresh timer) — never leaves a stale/null coordinate
  /// search in flight.
  Future<void> search() async {
    if (_disposed) return;

    state.value = NearbyDriversState.locating();
    logger('locating');

    LocationPermission permission;
    try {
      permission = await locationClient.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await locationClient.requestPermission();
      }
    } catch (e) {
      if (_disposed) return;
      state.value = NearbyDriversState.locationDenied(e.toString());
      logger('location_denied', {'error': e.toString()});
      return;
    }

    if (_disposed) return;

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state.value = NearbyDriversState.locationDenied();
      logger('location_denied', {'permission': permission.toString()});
      return;
    }

    final serviceEnabled = await locationClient.isLocationServiceEnabled();
    if (_disposed) return;
    if (!serviceEnabled) {
      state.value = NearbyDriversState.locationDenied(
        "Turn on location services to find nearby drivers.",
      );
      logger('location_service_disabled');
      return;
    }

    late final Position position;
    try {
      position = await locationClient.getCurrentPosition(timeout: locationTimeout);
    } on TimeoutException {
      if (_disposed) return;
      state.value = NearbyDriversState.locationTimeout();
      logger('location_timeout', {'timeout_seconds': locationTimeout.inSeconds});
      return;
    } catch (e) {
      if (_disposed) return;
      state.value = NearbyDriversState.locationTimeout(e.toString());
      logger('location_error', {'error': e.toString()});
      return;
    }

    if (_disposed) return;

    final lat = position.latitude;
    final lng = position.longitude;
    final location = LatLng(lat, lng);
    logger('location_captured', {'lat': lat, 'lng': lng});

    state.value = NearbyDriversState.searching(location);
    logger('match_request_sent', {'lat': lat, 'lng': lng});

    try {
      final response = await fetchNearbyDrivers(lat, lng);
      if (_disposed) return;

      final body = response.body;
      final isOk = response.statusCode == 200 &&
          body is Map &&
          body['code']?.toString() == '200';

      if (isOk) {
        final model = DriverAvailableModel.fromJson(Map<String, dynamic>.from(body));
        final drivers = model.data ?? [];
        logger('match_response_received', {
          'status': 'success',
          'count': drivers.length,
        });
        state.value = drivers.isEmpty
            ? NearbyDriversState.empty(location)
            : NearbyDriversState.success(drivers, location);
      } else {
        final message = (body is Map ? body['message']?.toString() : null) ??
            "Couldn't load nearby drivers. Please try again.";
        logger('match_response_received', {
          'status': 'failed',
          'http_status': response.statusCode,
          'message': message,
        });
        state.value = NearbyDriversState.requestFailed(message, location);
      }
    } catch (e) {
      if (_disposed) return;
      logger('match_response_received', {'status': 'error', 'error': e.toString()});
      state.value = NearbyDriversState.requestFailed(
        "Network error. Please check your connection and try again.",
        location,
      );
    }
  }

  /// Keeps results fresh while the rider is on a screen that shows nearby
  /// drivers — without this, the list was only ever fetched once, at app
  /// startup, and never again for the lifetime of the app process.
  void startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(autoRefreshInterval, (_) => search());
  }

  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  void dispose() {
    _disposed = true;
    stopAutoRefresh();
  }
}
