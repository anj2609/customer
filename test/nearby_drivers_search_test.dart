import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' show Response;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:myrideuser/data/services/nearby_drivers_search.dart';

/// Fake location backend — lets each test dictate exactly what the
/// "GPS hardware" does, without touching real Geolocator/platform code.
class _FakeLocationClient implements LocationClient {
  _FakeLocationClient({
    this.serviceEnabled = true,
    this.permission = LocationPermission.always,
    this.position,
    this.positionError,
  });

  bool serviceEnabled;
  LocationPermission permission;
  Position? position;
  Object? positionError;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async => permission;

  @override
  Future<Position> getCurrentPosition({required Duration timeout}) async {
    if (positionError != null) throw positionError!;
    return position!;
  }
}

Position _fakePosition(double lat, double lng) => Position(
  latitude: lat,
  longitude: lng,
  timestamp: DateTime.now(),
  accuracy: 5,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

Response _jsonResponse(int statusCode, Map<String, dynamic> body) =>
    Response(statusCode: statusCode, body: body);

/// Collects every (step, data) pair the search logs, so tests can assert
/// telemetry fired at each stage without depending on real logging output.
class _LogCapture {
  final List<String> steps = [];
  void call(String step, [Map<String, dynamic>? data]) => steps.add(step);
}

void main() {
  group('NearbyDriversSearch', () {
    test(
      'permission denied → locationDenied state, no API call made',
      () async {
        final log = _LogCapture();
        var apiCalled = false;

        final search = NearbyDriversSearch(
          locationClient: _FakeLocationClient(
            permission: LocationPermission.denied,
          ),
          fetchNearbyDrivers: (lat, lng) async {
            apiCalled = true;
            return _jsonResponse(200, {'code': '200', 'data': []});
          },
          logger: log.call,
        );

        await search.search();

        expect(search.state.value.phase, NearbyDriversPhase.locationDenied);
        expect(apiCalled, isFalse);
        expect(log.steps, contains('location_denied'));
        expect(log.steps, isNot(contains('match_request_sent')));
      },
    );

    test('permission denied forever → locationDenied state', () async {
      final search = NearbyDriversSearch(
        locationClient: _FakeLocationClient(
          permission: LocationPermission.deniedForever,
        ),
        fetchNearbyDrivers: (lat, lng) async =>
            _jsonResponse(200, {'code': '200', 'data': []}),
      );

      await search.search();

      expect(search.state.value.phase, NearbyDriversPhase.locationDenied);
    });

    test('location services disabled → locationDenied state', () async {
      final search = NearbyDriversSearch(
        locationClient: _FakeLocationClient(serviceEnabled: false),
        fetchNearbyDrivers: (lat, lng) async =>
            _jsonResponse(200, {'code': '200', 'data': []}),
      );

      await search.search();

      expect(search.state.value.phase, NearbyDriversPhase.locationDenied);
    });

    test(
      'GPS timeout → locationTimeout state, no API call made',
      () async {
        final log = _LogCapture();
        var apiCalled = false;

        final search = NearbyDriversSearch(
          locationClient: _FakeLocationClient(
            positionError: TimeoutException('timed out'),
          ),
          fetchNearbyDrivers: (lat, lng) async {
            apiCalled = true;
            return _jsonResponse(200, {'code': '200', 'data': []});
          },
          logger: log.call,
        );

        await search.search();

        expect(search.state.value.phase, NearbyDriversPhase.locationTimeout);
        expect(apiCalled, isFalse);
        expect(log.steps, contains('location_timeout'));
      },
    );

    test(
      'valid location with drivers nearby → success state with drivers list',
      () async {
        final log = _LogCapture();
        double? sentLat, sentLng;

        final search = NearbyDriversSearch(
          locationClient: _FakeLocationClient(
            position: _fakePosition(28.6139, 77.2090),
          ),
          fetchNearbyDrivers: (lat, lng) async {
            sentLat = lat;
            sentLng = lng;
            return _jsonResponse(200, {
              'code': '200',
              'data': [
                {
                  'id': 1,
                  'name': 'Ravi',
                  'latitude': '28.6140',
                  'longitude': '77.2091',
                  'distance': 0.2,
                },
                {
                  'id': 2,
                  'name': 'Sana',
                  'latitude': '28.6150',
                  'longitude': '77.2100',
                  'distance': 1.1,
                },
              ],
            });
          },
          logger: log.call,
        );

        await search.search();

        expect(search.state.value.phase, NearbyDriversPhase.success);
        expect(search.state.value.drivers, hasLength(2));
        expect(search.state.value.drivers.first.name, 'Ravi');
        expect(search.state.value.location, const LatLng(28.6139, 77.2090));
        // The captured GPS fix must be exactly what's sent to the backend.
        expect(sentLat, 28.6139);
        expect(sentLng, 77.2090);

        // Full telemetry trail, in order.
        expect(log.steps, [
          'locating',
          'location_captured',
          'match_request_sent',
          'match_response_received',
        ]);
      },
    );

    test(
      'valid location with no drivers nearby → empty state, not an error',
      () async {
        final search = NearbyDriversSearch(
          locationClient: _FakeLocationClient(
            position: _fakePosition(28.6139, 77.2090),
          ),
          fetchNearbyDrivers: (lat, lng) async =>
              _jsonResponse(200, {'code': '200', 'data': []}),
        );

        await search.search();

        expect(search.state.value.phase, NearbyDriversPhase.empty);
        expect(search.state.value.drivers, isEmpty);
      },
    );

    test(
      'backend error response (e.g. the 500 crash) → requestFailed state',
      () async {
        final search = NearbyDriversSearch(
          locationClient: _FakeLocationClient(
            position: _fakePosition(28.6139, 77.2090),
          ),
          fetchNearbyDrivers: (lat, lng) async => Response(
            statusCode: 500,
            body: {'message': 'Internal Server Error'},
          ),
        );

        await search.search();

        expect(search.state.value.phase, NearbyDriversPhase.requestFailed);
        expect(search.state.value.message, isNotNull);
      },
    );

    test('network exception during the API call → requestFailed state', () async {
      final search = NearbyDriversSearch(
        locationClient: _FakeLocationClient(
          position: _fakePosition(28.6139, 77.2090),
        ),
        fetchNearbyDrivers: (lat, lng) async =>
            throw Exception('socket closed'),
      );

      await search.search();

      expect(search.state.value.phase, NearbyDriversPhase.requestFailed);
    });

    test('state transitions through locating → searching before resolving', () async {
      final phases = <NearbyDriversPhase>[];
      final search = NearbyDriversSearch(
        locationClient: _FakeLocationClient(
          position: _fakePosition(28.6139, 77.2090),
        ),
        fetchNearbyDrivers: (lat, lng) async =>
            _jsonResponse(200, {'code': '200', 'data': []}),
      );
      search.state.listen((s) => phases.add(s.phase));

      await search.search();

      expect(phases, [
        NearbyDriversPhase.locating,
        NearbyDriversPhase.searching,
        NearbyDriversPhase.empty,
      ]);
    });

    test('startAutoRefresh() re-runs search() on the given interval', () async {
      var callCount = 0;
      final search = NearbyDriversSearch(
        locationClient: _FakeLocationClient(
          position: _fakePosition(28.6139, 77.2090),
        ),
        fetchNearbyDrivers: (lat, lng) async {
          callCount++;
          return _jsonResponse(200, {'code': '200', 'data': []});
        },
        autoRefreshInterval: const Duration(milliseconds: 50),
      );

      search.startAutoRefresh();
      await Future.delayed(const Duration(milliseconds: 180));
      search.stopAutoRefresh();

      // ~3-4 ticks in 180ms at a 50ms interval; assert it's more than one
      // to prove it actually repeats rather than firing once.
      expect(callCount, greaterThan(1));
      search.dispose();
    });

    test('dispose() stops auto-refresh and further search() calls are no-ops', () async {
      var callCount = 0;
      final search = NearbyDriversSearch(
        locationClient: _FakeLocationClient(
          position: _fakePosition(28.6139, 77.2090),
        ),
        fetchNearbyDrivers: (lat, lng) async {
          callCount++;
          return _jsonResponse(200, {'code': '200', 'data': []});
        },
        autoRefreshInterval: const Duration(milliseconds: 30),
      );

      search.startAutoRefresh();
      await Future.delayed(const Duration(milliseconds: 70));
      search.dispose();
      final countAtDispose = callCount;
      await Future.delayed(const Duration(milliseconds: 100));

      expect(callCount, countAtDispose); // no further calls after dispose
    });
  });
}
