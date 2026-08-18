import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myrideuser/data/modal/vehicle_model.dart';

/// Trimmed to three rows from a real /estimate-ride-list response — a car, a
/// bike (zero platform fee) and an auto. The point of the fixture is the key
/// names and value types, which is exactly what create-booking depends on.
const String _estimateResponse = '''
{
  "code": "200",
  "message": "Data fetched successfully",
  "data": [
    {
      "vehicle_type_id": 1,
      "name": "Sedan",
      "estimated_time": "2804 mins",
      "distance_km": 2413.54,
      "fare_details": {
        "base_fare": "500",
        "distance_charge": 53097.77,
        "time_charge": 5607.93,
        "platform_fee": "30.00",
        "booking_fee": "30.00",
        "surge_multiplier": 1.4,
        "gst_percent": 0,
        "gst_amount": 0
      },
      "price": 82948
    },
    {
      "vehicle_type_id": 5,
      "name": "Bike",
      "estimated_time": "2804 mins",
      "distance_km": 2413.54,
      "fare_details": {
        "base_fare": "30",
        "distance_charge": 19308.28,
        "time_charge": 5607.93,
        "platform_fee": "0.00",
        "booking_fee": "5.00",
        "surge_multiplier": 1.4,
        "gst_percent": 0,
        "gst_amount": 0
      },
      "price": 34930
    },
    {
      "vehicle_type_id": 8,
      "name": "Auto",
      "estimated_time": "2804 mins",
      "distance_km": 2413.54,
      "fare_details": {
        "base_fare": "50",
        "distance_charge": 24135.35,
        "time_charge": 5607.93,
        "platform_fee": "0.00",
        "booking_fee": "10.00",
        "surge_multiplier": 1.4,
        "gst_percent": 0,
        "gst_amount": 0
      },
      "price": 41721
    }
  ]
}
''';

List<VehicleModel> _parse(String body) => (jsonDecode(body)['data'] as List)
    .map((item) => VehicleModel.fromJson(Map<String, dynamic>.from(item)))
    .toList();

void main() {
  group('VehicleModel.fromJson', () {
    test('reads the fare breakdown out of fare_details', () {
      final sedan = _parse(_estimateResponse).first;

      expect(sedan.vehicleTypeId, 1);
      expect(sedan.name, 'Sedan');
      expect(sedan.price, 82948);

      // create-booking's base_price is the estimate's base_fare, and arrives
      // as a string.
      expect(sedan.basePrice, 500);
      expect(sedan.platformFee, 30.00);
      expect(sedan.gstPercent, 0);
      expect(sedan.gstAmount, 0);
    });

    test('keeps a zero platform fee as 0 rather than dropping it', () {
      // "0.00" must survive as 0 and not as null — a null would omit
      // platform_fee from the booking body entirely and let the backend
      // re-derive a non-zero fee for a vehicle that has none.
      final bike = _parse(_estimateResponse)[1];

      expect(bike.platformFee, isNotNull);
      expect(bike.platformFee, 0);
      expect(bike.basePrice, 30);
    });

    test('leaves fare fields null when the row has no fare_details', () {
      final vehicle = VehicleModel.fromJson({
        'vehicle_type_id': 2,
        'name': 'Hatchback',
        'price': 100,
      });

      expect(vehicle.basePrice, isNull);
      expect(vehicle.platformFee, isNull);
      expect(vehicle.gstPercent, isNull);
      expect(vehicle.gstAmount, isNull);
    });

    test('reduces the formatted estimated_time to plain minutes', () {
      final sedan = _parse(_estimateResponse).first;

      expect(sedan.estimatedTime, '2804 mins');
      expect(sedan.estimatedMinutes, 2804);
      // Sent alongside it as estimated_distance.
      expect(sedan.distanceKm, 2413.54);
    });

    test('accepts a bare number and a singular unit as minutes', () {
      expect(
        VehicleModel.fromJson({'estimated_time': '45'}).estimatedMinutes,
        45,
      );
      expect(
        VehicleModel.fromJson({'estimated_time': '7 min'}).estimatedMinutes,
        7,
      );
    });

    test('refuses to guess at an hours-based duration', () {
      // Parsing the leading number here would book an 80-minute ride as a
      // 1-minute one. Null omits the field and lets the backend derive it.
      expect(
        VehicleModel.fromJson({'estimated_time': '1 hour 20 mins'})
            .estimatedMinutes,
        isNull,
      );
      expect(
        VehicleModel.fromJson({'estimated_time': '2 hrs'}).estimatedMinutes,
        isNull,
      );
    });

    test('returns null for a missing or unparseable duration', () {
      expect(VehicleModel.fromJson({}).estimatedMinutes, isNull);
      expect(
        VehicleModel.fromJson({'estimated_time': ''}).estimatedMinutes,
        isNull,
      );
      expect(
        VehicleModel.fromJson({'estimated_time': 'shortly'}).estimatedMinutes,
        isNull,
      );
    });

    test('accepts base_price as an alias for base_fare', () {
      final vehicle = VehicleModel.fromJson({
        'vehicle_type_id': 3,
        'fare_details': {'base_price': '800', 'platform_fee': 40},
      });

      expect(vehicle.basePrice, 800);
      expect(vehicle.platformFee, 40);
    });
  });
}
