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
///   - the requested six-line receipt (subtotal, CGST, SGST, booking fee,
///     platform fee, total — plus promo/wallet deductions and a final
///     amount line, but only when either actually applies), if trip-detail
///     included a "price_breakdown" object. CONFIRMED against a real, live,
///     completed normal-ride response to actually be what this endpoint
///     sends — this was previously assumed unconfirmed and effectively
///     unused; the "payment"-only path below is what a normal-ride booking
///     was rendering from instead.
///   - otherwise the lighter "payment" summary (total fare, promo discount
///     if > 0, wallet used if > 0, final amount) as a fallback for whatever
///     case genuinely lacks a "price_breakdown" object (e.g. still loading,
///     or a ride type/status this hasn't been reconfirmed against).
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
    // CONFIRMED against a real, live, completed normal-ride response —
    // price_breakdown genuinely is sent, with exactly these keys, settling
    // the "unconfirmed either way" this file used to carry. Rendered as the
    // six-line receipt requested: subtotal, the two GST components (each
    // showing its own real percentage, not a hardcoded one — the confirmed
    // response has 0%, but this can't assume every booking does), the two
    // fees, then the total.
    String pct(num value) {
      // Whole numbers ("0", "2") read cleaner than "0.0"/"2.0" on a receipt
      // line; a genuinely fractional rate (2.5) still shows in full.
      return value == value.roundToDouble()
          ? value.toInt().toString()
          : value.toString();
    }

    return [
      _row("Subtotal Fare", breakdown.baseFare),
      _row("CGST(${pct(breakdown.cgstPercent)}%)", breakdown.cgstAmount),
      _row("SGST(${pct(breakdown.sgstPercent)}%)", breakdown.sgstAmount),
      _row("Booking Fee Trip", breakdown.bookingFeePerTrip),
      _row("Platform Fee", breakdown.platformFee),
      const Divider(),
      _row("Total Fare", breakdown.totalFare, isBold: true),
      // Not part of the requested six rows, but kept: when a promo or wallet
      // amount actually reduced what the rider paid, hiding that would make
      // the total on screen not match what they were actually charged.
      // Silent for the common case (both 0), same as before.
      if (breakdown.promoDiscount > 0)
        _row("Promo Discount", breakdown.promoDiscount, isDeduction: true),
      if (breakdown.walletUsed > 0)
        _row("Wallet Used", breakdown.walletUsed, isDeduction: true),
      if (breakdown.promoDiscount > 0 || breakdown.walletUsed > 0)
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
