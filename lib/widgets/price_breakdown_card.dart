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
///   - the full six-line receipt — Subtotal Fare, CGST(x%), SGST(x%),
///     Booking Fee Trip, Platform Fee, Total Fare — when trip-detail
///     included a "price_breakdown" object. CONFIRMED against a real, live,
///     completed normal-ride response to be what this endpoint sends. Both
///     GST lines print the percentage the backend actually reported rather
///     than a hardcoded 2.5%, so a booking taxed at a different rate can't
///     be labelled with a rate it wasn't charged.
///   - otherwise the lighter "payment" summary, using the same labels for
///     the same roles (see _paymentRows) so a figure never changes name
///     depending on which shape came back. The tax and fee lines are absent
///     there because that shape genuinely does not carry them — not because
///     they were zero.
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
      // Deductions sit above the total, not below it — they're part of
      // arriving at what's owed, and a receipt that shows a bold total and
      // then keeps subtracting from it reads as though the bold figure were
      // the amount charged. Silent in the common case where both are 0.
      if (breakdown.promoDiscount > 0)
        _row("Promo Discount", breakdown.promoDiscount, isDeduction: true),
      if (breakdown.walletUsed > 0)
        _row("Wallet Used", breakdown.walletUsed, isDeduction: true),
      const Divider(),
      // tripData.displayFare, not breakdown.finalAmount directly — same
      // number in practice (this branch only runs when breakdown is the
      // object displayFare itself prefers), but reading the shared getter
      // rather than this object's own field is what keeps this row
      // structurally unable to disagree with any other "Total Fare"
      // display reading the same tripData (e.g. trip_completed_screen.dart's
      // top figure — see TripDetailData.displayFare's own note on the two
      // having actually drifted apart once already). Labelling the
      // pre-deduction subtotal as the total would contradict the deduction
      // rows immediately above it, which is why this isn't totalFare.
      _row("Total Fare", tripData.displayFare ?? breakdown.finalAmount, isBold: true),
    ];
  }

  /// Fallback for a booking whose trip-detail carried only the lighter
  /// "payment" object and no "price_breakdown".
  ///
  /// Named to match the full receipt above so the same figure never carries
  /// two different labels depending on which shape the API happened to
  /// return: "total_fare" is the pre-deduction subtotal (the same role
  /// base_fare plays above), and "final_amount" is what the rider actually
  /// pays, which is the number a receipt calls the total.
  ///
  /// The tax and fee lines genuinely cannot be shown from this shape —
  /// "payment" carries only {promo_discount, wallet_used, total_fare,
  /// final_amount}, and its own arithmetic (final = total − promo − wallet)
  /// leaves no room to derive CGST/SGST/platform/booking-fee components; any
  /// tax is already baked inside total_fare. Printing them as ₹0.00 here
  /// would state, falsely, that no tax was charged. They appear in full
  /// whenever the API sends price_breakdown — see _breakdownRows.
  List<Widget> _paymentRows(TripPayment payment) {
    return [
      _row("Subtotal Fare", payment.totalFare),
      if (payment.promoDiscount > 0)
        _row("Promo Discount", payment.promoDiscount, isDeduction: true),
      if (payment.walletUsed > 0)
        _row("Wallet Used", payment.walletUsed, isDeduction: true),
      const Divider(),
      // tripData.displayFare, not payment.finalAmount directly — see the
      // matching note in _breakdownRows above.
      _row("Total Fare", tripData.displayFare ?? payment.finalAmount, isBold: true),
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
