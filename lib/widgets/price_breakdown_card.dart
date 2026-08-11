import 'package:flutter/material.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/modal/trip_detail_model.dart';

/// Real fare/payment info for a booking that actually exists (has a
/// booking_id), sourced from /trip-detail. Shown on the Finding Driver
/// screen, the post-ride Completed Ride Sheet, and the Activity ride
/// detail screen — never on pre-booking screens (Services tab, vehicle
/// selection, etc.) since there's no booking to look up yet there.
///
/// Renders whichever shape the API actually returned:
///   - the full breakdown (base fare, platform fee, CGST, SGST always;
///     distance/time/extra-distance charges and wallet used only when
///     > 0), if trip-detail included a "price_breakdown" object — this
///     is the original spec, kept for bookings/ride-types that might
///     still return it (unconfirmed either way).
///   - otherwise the lighter "payment" summary that's confirmed to be
///     what a real completed normal-ride booking actually returns today
///     (total fare, promo discount if > 0, wallet used if > 0, final
///     amount) — this used to render nothing at all, since the code only
///     ever looked for "price_breakdown", which doesn't exist on that
///     response.
///   - nothing, if trip-detail has neither (e.g. still loading).
class PriceBreakdownCard extends StatelessWidget {
  final TripDetailData tripData;
  final EdgeInsetsGeometry padding;

  const PriceBreakdownCard({
    super.key,
    required this.tripData,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    final breakdown = tripData.priceBreakdown;
    final payment = tripData.payment;

    if (breakdown == null && payment == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: breakdown != null
            ? _breakdownRows(breakdown)
            : _paymentRows(payment!),
      ),
    );
  }

  List<Widget> _breakdownRows(PriceBreakdown breakdown) {
    return [
      _row("Base Fare", breakdown.baseFare),
      if (breakdown.distanceCharge > 0)
        _row("Distance Charge", breakdown.distanceCharge),
      if (breakdown.timeCharge > 0)
        _row("Time Charge", breakdown.timeCharge),
      if (breakdown.extraDistanceCharge > 0)
        _row("Extra Distance Charge", breakdown.extraDistanceCharge),
      _row("Platform Fee", breakdown.platformFee),
      _row("CGST", breakdown.cgstAmount),
      _row("SGST", breakdown.sgstAmount),
      if (breakdown.walletUsed > 0)
        _row("Wallet Used", breakdown.walletUsed, isDeduction: true),
      const Divider(),
      _row("Final Amount", breakdown.finalAmount, isBold: true),
    ];
  }

  List<Widget> _paymentRows(TripPayment payment) {
    return [
      _row("Total Fare", payment.totalFare),
      if (payment.promoDiscount > 0)
        _row("Promo Discount", payment.promoDiscount, isDeduction: true),
      if (payment.walletUsed > 0)
        _row("Wallet Used", payment.walletUsed, isDeduction: true),
      const Divider(),
      _row("Final Amount", payment.finalAmount, isBold: true),
    ];
  }

  Widget _row(
    String label,
    double amount, {
    bool isBold = false,
    bool isDeduction = false,
  }) {
    final text = "${isDeduction ? '- ' : ''}₹ ${amount.toStringAsFixed(2)}";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: isBold
                  ? PoppinsSemiBold.copyWith(color: ColorResources.blackcolor11)
                  : PoppinsReguler.copyWith(
                      color: ColorResources.TextColorForGrey,
                    ),
            ),
          ),
          Text(
            text,
            style: isBold
                ? PoppinsSemiBold.copyWith(color: ColorResources.blackcolor11)
                : PoppinsMedium.copyWith(color: ColorResources.blackcolor11),
          ),
        ],
      ),
    );
  }
}
