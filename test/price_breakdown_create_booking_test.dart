import 'package:flutter_test/flutter_test.dart';
import 'package:myrideuser/data/modal/trip_detail_model.dart';

/// create-booking's response `data`, captured live. This is the only
/// endpoint confirmed to return the itemised fare, and its key names differ
/// from trip-detail's "price_breakdown" shape in ways that fail silently
/// (a wrong key just reads 0 and prints "₹ 0.00" on the receipt) — so the
/// mapping is pinned here rather than left to be re-derived by eye.
Map<String, dynamic> _liveCreateBookingData() => {
      'booking_id': 259,
      'final_amount': 592,
      'total_fare': 592,
      'promo_discount': 0,
      'wallet_used': 0,
      'fare_details': {
        'base_fare': 500,
        'base_distance_km': 7,
        'distance_charge': 0,
        'time_charge': 7,
        'taxable_amount': 507,
        'surge_multiplier': 1,
        'gst_percent': 5,
        'gst_amount': 25.35,
        'cgst_percent': 2.5,
        'cgst_amount': 12.68,
        'sgst_percent': 2.5,
        'sgst_amount': 12.68,
        'platform_fee': 30,
        'booking_fee': 30,
        'total_fare': 592,
      },
    };

void main() {
  group('PriceBreakdown.fromCreateBooking', () {
    test('reads every row the fare receipt renders', () {
      final b = PriceBreakdown.fromCreateBooking(_liveCreateBookingData());

      expect(b.baseFare, 500);
      expect(b.cgstPercent, 2.5);
      expect(b.cgstAmount, 12.68);
      expect(b.sgstPercent, 2.5);
      expect(b.sgstAmount, 12.68);
      expect(b.platformFee, 30);
      expect(b.finalAmount, 592);
    });

    test('maps booking_fee, which price_breakdown calls booking_fee_per_trip',
        () {
      final b = PriceBreakdown.fromCreateBooking(_liveCreateBookingData());
      // The whole point of the separate factory: reusing fromJson's
      // 'booking_fee_per_trip' key against this payload silently yields 0.
      expect(b.bookingFeePerTrip, 30);
    });

    test('takes deductions and final amount from data, not fare_details', () {
      final data = _liveCreateBookingData()
        ..['promo_discount'] = 50
        ..['wallet_used'] = 42
        ..['final_amount'] = 500;

      final b = PriceBreakdown.fromCreateBooking(data);

      expect(b.promoDiscount, 50);
      expect(b.walletUsed, 42);
      // fare_details.total_fare stays the pre-deduction sum.
      expect(b.totalFare, 592);
      expect(b.finalAmount, 500);
    });

    test('survives a response with no fare_details block at all', () {
      final b = PriceBreakdown.fromCreateBooking({
        'booking_id': 1,
        'final_amount': 100,
        'total_fare': 100,
      });

      expect(b.baseFare, 0);
      expect(b.finalAmount, 100);
      // Falls back to the booking's own total when the fare block is absent.
      expect(b.totalFare, 100);
    });

    test('accepts numbers sent as strings', () {
      final b = PriceBreakdown.fromCreateBooking({
        'final_amount': '592',
        'fare_details': {'base_fare': '500', 'cgst_amount': '12.68'},
      });

      expect(b.baseFare, 500);
      expect(b.cgstAmount, 12.68);
      expect(b.finalAmount, 592);
    });
  });

  group('TripDetailData.copyWithPriceBreakdown', () {
    test('attaches the breakdown without disturbing the rest of the ride', () {
      final original = TripDetailData.fromJson({
        'booking_id': 259,
        'booking_number': 'NR259',
        'status': 'completed',
        'payment': {'total_fare': 592, 'final_amount': 592},
      });
      expect(original.priceBreakdown, isNull);

      final withBreakdown = original.copyWithPriceBreakdown(
        PriceBreakdown.fromCreateBooking(_liveCreateBookingData()),
      );

      expect(withBreakdown.priceBreakdown?.baseFare, 500);
      expect(withBreakdown.bookingId, 259);
      expect(withBreakdown.bookingNumber, 'NR259');
      expect(withBreakdown.status, 'completed');
      expect(withBreakdown.payment?.finalAmount, 592);
    });
  });
}
