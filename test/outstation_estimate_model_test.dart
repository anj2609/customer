import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myrideuser/data/modal/outstation_estimate_model.dart';

/// Two rows from a real /outstation/estimate response. This endpoint sends
/// `base_price` as a string ("2449.00") where the rental endpoint sends it as
/// a number — both have to end up as num for the create-booking body.
const String _outstationEstimateResponse = '''
{
  "code": "200",
  "message": "Outstation vehicles fetched successfully.",
  "data": [
    {
      "outstation_pricing_id": 1,
      "vehicle_type_id": 2,
      "vehicle_name": "Hatchback",
      "vehicle_image": "images/admin/vehicalType/17852312841766.png",
      "trip_type": "one_way",
      "distance": 799.32,
      "duration": 638,
      "billable_distance": 799.32,
      "fare_details": {
        "base_price": "2449.00",
        "extra_distance": 599.32,
        "per_km_charge": "8.00",
        "driver_allowance": 0,
        "platform_fee": "20.00",
        "booking_fee_per_trip": 0,
        "surge_multiplier": 1.4,
        "gst_percent": 0,
        "gst_amount": 0
      },
      "price": 10161
    },
    {
      "outstation_pricing_id": 2,
      "vehicle_type_id": 1,
      "vehicle_name": "Sedan",
      "vehicle_image": "images/admin/vehicalType/17851301263473.png",
      "trip_type": "one_way",
      "distance": 799.32,
      "duration": 638,
      "billable_distance": 799.32,
      "fare_details": {
        "base_price": "2999.00",
        "extra_distance": 599.32,
        "per_km_charge": "10.00",
        "driver_allowance": 0,
        "platform_fee": "30.00",
        "booking_fee_per_trip": 0,
        "surge_multiplier": 1.4,
        "gst_percent": 0,
        "gst_amount": 0
      },
      "price": 12620
    }
  ]
}
''';

List<OutstationEstimateModel> _parse(String body) =>
    (jsonDecode(body)['data'] as List)
        .map((item) =>
            OutstationEstimateModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

void main() {
  group('OutstationEstimateModel.fromJson', () {
    test('reads the fields create-booking needs for an outstation ride', () {
      final hatchback = _parse(_outstationEstimateResponse).first;

      expect(hatchback.outstationPricingId, 1);
      expect(hatchback.vehicleTypeId, 2);
      expect(hatchback.tripType, 'one_way');
      expect(hatchback.distance, 799.32);
      expect(hatchback.duration, 638);
      expect(hatchback.billableDistance, 799.32);
      expect(hatchback.price, 10161);

      final fare = hatchback.fareDetails!;
      // Both arrive as strings and must not be posted as text.
      expect(fare.basePrice, isA<num>());
      expect(fare.basePrice, 2449.00);
      expect(fare.platformFee, isA<num>());
      expect(fare.platformFee, 20.00);
      expect(fare.driverAllowance, 0);
      expect(fare.gstPercent, 0);
      expect(fare.gstAmount, 0);
    });

    test('parses each pricing row independently', () {
      final sedan = _parse(_outstationEstimateResponse)[1];

      expect(sedan.outstationPricingId, 2);
      expect(sedan.fareDetails!.basePrice, 2999.00);
      expect(sedan.fareDetails!.platformFee, 30.00);
      expect(sedan.fareDetails!.perKmCharge, 10.00);
    });

    test('leaves absent fare fields null rather than defaulting them', () {
      // base_distance_km is not in this endpoint's payload at all.
      final estimate = _parse(_outstationEstimateResponse).first;

      expect(estimate.fareDetails!.baseDistanceKm, isNull);
    });

    test('leaves fareDetails null when the row omits it', () {
      final estimate = OutstationEstimateModel.fromJson({
        'outstation_pricing_id': 9,
        'vehicle_type_id': 9,
        'price': 100,
      });

      expect(estimate.fareDetails, isNull);
    });
  });
}
