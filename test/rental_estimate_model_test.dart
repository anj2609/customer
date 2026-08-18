import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myrideuser/data/modal/rental_estimate_model.dart';

/// Two rows from a real /rental/estimate response. Unlike the city-ride
/// estimate, this endpoint names the base component `base_price` — matching
/// create-booking directly — so the fixture guards that difference staying put.
const String _rentalEstimateResponse = '''
{
  "code": "200",
  "message": "Rental vehicles fetched successfully.",
  "data": [
    {
      "package_id": 1,
      "vehicle_type_id": 1,
      "vehicle_name": "Sedan",
      "vehicle_image": "images/admin/vehicalType/17851301263473.png",
      "hours": 3,
      "price_per_hr": "1849.00",
      "included_km": 240,
      "fare_details": {
        "base_price": 8017.799999999999,
        "time_charge": 180,
        "platform_fee": "30.00",
        "surge_multiplier": 1.4,
        "gst_percent": 5,
        "gst_amount": 400.89,
        "cgst_percent": 2.5,
        "cgst_amount": 200.45,
        "sgst_percent": 2.5,
        "sgst_amount": 200.45,
        "booking_fee_per_trip": "30.00"
      },
      "price": 8479
    },
    {
      "package_id": 2,
      "vehicle_type_id": 2,
      "vehicle_name": "Hatchback",
      "vehicle_image": "images/admin/vehicalType/17852312841766.png",
      "hours": 3,
      "price_per_hr": "1449.00",
      "included_km": 240,
      "fare_details": {
        "base_price": 6337.799999999999,
        "time_charge": 180,
        "platform_fee": "55.00",
        "surge_multiplier": 1.4,
        "gst_percent": 5,
        "gst_amount": 316.89,
        "cgst_percent": 2.5,
        "cgst_amount": 158.45,
        "sgst_percent": 2.5,
        "sgst_amount": 158.45,
        "booking_fee_per_trip": "20.00"
      },
      "price": 6730
    }
  ]
}
''';

List<RentalEstimateModel> _parse(String body) =>
    (jsonDecode(body)['data'] as List)
        .map((item) =>
            RentalEstimateModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();

void main() {
  group('RentalEstimateModel.fromJson', () {
    test('reads the fields create-booking needs for a rental', () {
      final sedan = _parse(_rentalEstimateResponse).first;

      expect(sedan.packageId, 1);
      expect(sedan.vehicleTypeId, 1);
      expect(sedan.hours, 3);
      expect(sedan.includedKm, 240);
      expect(sedan.price, 8479);

      final fare = sedan.fareDetails!;
      expect(fare.basePrice, 8017.799999999999);
      // "30.00" must land as a number, not the string it arrives as.
      expect(fare.platformFee, isA<num>());
      expect(fare.platformFee, 30.00);
      expect(fare.gstPercent, 5);
      expect(fare.gstAmount, 400.89);
    });

    test('parses each package independently', () {
      final hatchback = _parse(_rentalEstimateResponse)[1];

      expect(hatchback.packageId, 2);
      expect(hatchback.fareDetails!.platformFee, 55.00);
      expect(hatchback.fareDetails!.gstAmount, 316.89);
    });

    test('leaves fareDetails null when the row omits it', () {
      final estimate = RentalEstimateModel.fromJson({
        'package_id': 9,
        'vehicle_type_id': 9,
        'price': 100,
      });

      expect(estimate.fareDetails, isNull);
    });
  });
}
