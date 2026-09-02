import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/modal/trip_detail_model.dart';
import 'package:myrideuser/widgets/price_breakdown_card.dart';

/// Post-ride "Trip Completed" summary and rating screen, shown once the ride
/// is finished and payment has settled. "Done" returns the rider Home.
///
/// Fare, distance and duration, and the expandable breakdown, all come from
/// the same /trip-detail data every other fare display in the app reads —
/// [BookingController.tripDetailModel], kept fresh by the 3s poll that runs
/// throughout tracking (see findingdriver_screen.dart). Nothing here fetches
/// its own copy; it reads whatever the app already has for this booking.
class TripCompletedScreen extends StatefulWidget {
  final String bookingId;

  /// From getPaymentStatus's data.payment_type (e.g. "cash", "online",
  /// "wallet") — see PaymentController. Empty when genuinely unknown, in
  /// which case the row is left off rather than shown with a guessed value.
  final String paymentType;

  const TripCompletedScreen({
    super.key,
    required this.bookingId,
    this.paymentType = '',
  });

  @override
  State<TripCompletedScreen> createState() => _TripCompletedScreenState();
}

class _TripCompletedScreenState extends State<TripCompletedScreen> {
  static const Color _navyTop = Color(0xFF0B2A7A);
  static const Color _navyBottom = Color(0xFF07204F);

  /// Starts empty — a rating is the rider's own judgement of the ride, not
  /// a default they have to notice and correct. They tap to fill it in
  /// themselves before pressing Done.
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;
  bool _fareExpanded = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _done() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      await Get.find<BookingController>().submitTripRating(
        bookingId: widget.bookingId,
        rating: _rating,
        review: _reviewController.text.trim(),
      );
    } catch (e) {
      // submitTripRating already catches internally and returns false on
      // failure — this is a second net in case Get.find itself throws
      // (BookingController not registered). Either way, a failed rating
      // submit must never trap the rider on a screen for a ride that's
      // already over and already paid for.
      debugPrint('[TripCompleted] rating submit failed: $e');
    }

    Get.offAllNamed(RouteHelper.getmainNavigationScreen());
  }

  /// "cash" -> "Cash", "online" -> "Online". The backend sends this
  /// lowercase; title-casing it is purely cosmetic, not a translation of
  /// meaning, so an unrecognised value still displays (capitalised) rather
  /// than being swallowed into a generic fallback.
  String _formatPaymentType(String raw) {
    if (raw.isEmpty) return '';
    return raw[0].toUpperCase() + raw.substring(1).toLowerCase();
  }

  IconData _paymentIcon(String raw) {
    switch (raw.toLowerCase()) {
      case 'cash':
        return Icons.payments_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.credit_card_rounded;
    }
  }

  /// The one figure a "Total Fare" line means: what the rider was actually
  /// charged. Delegates to TripDetailData.displayFare — the single source
  /// every "Total Fare" on this screen (this top figure and the
  /// PriceBreakdownCard below it) now reads, so they can no longer show
  /// two different numbers for the same booking the way they used to when
  /// this method had its own, differently-ordered fallback chain.
  double? _totalFare(TripDetailData? data) => data?.displayFare;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Explicit rather than left to Scaffold's own default (white): the
      // reported "white rectangle at the bottom" was the theme's stock
      // scaffoldBackgroundColor showing through wherever the gradient body
      // didn't reach — the keyboard opening for the review field being the
      // main case, since Scaffold shrinks the body for it by default and
      // repaints the freed strip with its own background, not the body's.
      backgroundColor: _navyBottom,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_navyTop, _navyBottom],
          ),
        ),
        child: SafeArea(
          child: GetBuilder<BookingController>(
            builder: (bc) {
              final tripData = bc.tripDetailModel.value?.data;

              // Duration/distance specifically fall back to the latched
              // completedTripStats snapshot when the live data doesn't have
              // a reading — see BookingController.completedTripStats for
              // why the live value can lose them by the time this screen
              // is reached, even though they showed correctly moments
              // earlier on the "You have arrived!" sheet. Fare still reads
              // from the live tripData: that's expected to only ever get
              // more complete (payment settling) as this booking wraps up,
              // not to regress the way duration/distance can.
              final liveStats = tripData?.rideStats;
              final hasLiveStats =
                  (liveStats?.duration ?? 0) > 0 || (liveStats?.distance ?? 0) > 0;
              final statsSource =
                  hasLiveStats ? liveStats : bc.completedTripStats?.rideStats;

              // Distance is computed straight from pickup/drop coordinates
              // rather than trusting trip-detail's own final_distance — a
              // live-captured response for a real booking returned
              // 2429.43 km for a trip between two points a normal drive
              // apart, so that field can't be relied on as-is. Pickup/drop
              // themselves can't be wrong the same way; see
              // haversineDistanceKm's own note. completedTripStats is
              // checked too, same reasoning as the duration/distance latch
              // above: the live tripData can lose its pickup/drop the same
              // way it can lose rideStats.
              final pickup = tripData?.pickup ?? bc.completedTripStats?.pickup;
              final drop = tripData?.drop ?? bc.completedTripStats?.drop;
              final computedDistanceKm = haversineDistanceKm(
                pickup?.lat,
                pickup?.lng,
                drop?.lat,
                drop?.lng,
              );

              final fare = _totalFare(tripData);
              final durationText = formatTripDuration(statsSource?.duration);
              final distanceText =
                  formatTripDistance(computedDistanceKm ?? statsSource?.distance);

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: ConstrainedBox(
                      // Guarantees the gradient content fills at least the
                      // full viewport even when everything above it is
                      // shorter than the screen, rather than leaving dead
                      // space at the bottom for the Scaffold's own
                      // background to show through.
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      // Deliberately no Expanded/Spacer in here: this Column
                      // sits inside a ConstrainedBox with only a minHeight
                      // (maxHeight stays unbounded, from the scroll view
                      // above it), which is what lets it size to its natural
                      // content height and then simply get padded up to
                      // minHeight when that's taller — the standard
                      // "scrollable content that still fills a short screen"
                      // pattern. A flexible child here would need a bounded
                      // height to expand into, which this deliberately
                      // doesn't have.
                      child: Column(
                        children: [
                          const SizedBox(height: 22),
                          const _SuccessBadge(),
                          const SizedBox(height: 22),

                          Text(
                            "Thanks for riding with us!",
                            textAlign: TextAlign.center,
                            style: PoppinsSemiBold.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "We hope you had a\ngreat experience.",
                            textAlign: TextAlign.center,
                            style: PoppinsReguler.copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),

                          const SizedBox(height: 26),
                          _summaryCard(
                            tripData: tripData,
                            fare: fare,
                            durationText: durationText,
                            distanceText: distanceText,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _summaryCard({
    required TripDetailData? tripData,
    required double? fare,
    required String durationText,
    required String distanceText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- Total fare, with a disclosure chevron ----
          InkWell(
            onTap: () => setState(() => _fareExpanded = !_fareExpanded),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Total Fare",
                    style: PoppinsSemiBold.copyWith(fontSize: 15),
                  ),
                ),
                Text(
                  fare != null ? "₹${fare.toStringAsFixed(2)}" : "—",
                  style: PoppinsSemiBold.copyWith(fontSize: 17),
                ),
                const SizedBox(width: 4),
                Icon(
                  _fareExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: Colors.black54,
                ),
              ],
            ),
          ),

          // The real itemised breakdown — same widget and same data source
          // as the Finding Driver screen and Activity ride detail use.
          // Falls back to a plain notice only for the genuine edge case of
          // no trip data being available at all (e.g. this screen reached
          // by some path other than the normal payment flow).
          if (_fareExpanded) ...[
            const SizedBox(height: 10),
            if (tripData != null)
              PriceBreakdownCard(
                tripData: tripData,
                padding: EdgeInsets.zero,
              )
            else
              Text(
                "Fare breakdown is unavailable for this ride.",
                style: PoppinsReguler.copyWith(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
          ],

          // ---- Payment method — only shown when actually known ----
          if (widget.paymentType.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Payment Method",
                    style: PoppinsReguler.copyWith(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Icon(_paymentIcon(widget.paymentType), size: 16),
                const SizedBox(width: 6),
                Text(
                  _formatPaymentType(widget.paymentType),
                  style: PoppinsSemiBold.copyWith(fontSize: 13),
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // ---- Duration / distance ----
          Row(
            children: [
              Expanded(child: _statTile("Duration", durationText)),
              const SizedBox(width: 10),
              Expanded(child: _statTile("Distance", distanceText)),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            "How was your ride?",
            style: PoppinsSemiBold.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 10),
          _stars(),

          const SizedBox(height: 16),

          TextField(
            controller: _reviewController,
            minLines: 1,
            maxLines: 3,
            style: PoppinsReguler.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: "Write a review (optional)",
              hintStyle: PoppinsReguler.copyWith(
                fontSize: 13,
                color: Colors.black38,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _done,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123EBC),
                disabledBackgroundColor:
                    const Color(0xFF123EBC).withValues(alpha: 0.6),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isSubmitting ? "Please wait..." : "Done",
                style: PoppinsSemiBold.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: PoppinsSemiBold.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: PoppinsReguler.copyWith(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stars() {
    return Row(
      children: List.generate(5, (i) {
        final bool filled = i < _rating;
        return GestureDetector(
          onTap: () => setState(() => _rating = i + 1),
          // opaque + padding widens the hit area: a bare 30px star is below
          // the ~44px comfortable tap target, which makes the rating fiddly
          // to set precisely.
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 30,
              color: filled ? const Color(0xFF123EBC) : Colors.black26,
            ),
          ),
        );
      }),
    );
  }
}

/// White circular tick, the confirmation mark at the top of the screen.
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 20,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.check_rounded,
        size: 40,
        color: Color(0xFF123EBC),
      ),
    );
  }
}
