import 'package:flutter/material.dart';
import 'package:myrideuser/config/utils/style.dart';

/// The full-screen "Finding you the best driver" state, shown while the
/// backend looks for a nearby driver to accept the booking.
///
/// Presentation only — it owns no polling and no ride state. The screen that
/// hosts it keeps its existing tracking logic and simply shows this while
/// the booking is still unassigned, so the search behaviour is unchanged and
/// only what the rider sees is different.
class FindingDriverView extends StatelessWidget {
  /// Back action. Hidden entirely when null rather than shown inert, since a
  /// dead back arrow on a waiting screen is worse than none.
  final VoidCallback? onBack;

  /// Abandons the booking. Rendered as its own explicit button rather than
  /// being folded into the back arrow: this is the only way out of a pending
  /// search, and the previous design had a full-width "Cancel Ride" button,
  /// so hiding that behind a back chevron would quietly remove the one
  /// control a waiting rider actually needs.
  final VoidCallback? onCancelRide;

  const FindingDriverView({super.key, this.onBack, this.onCancelRide});

  // Matched to car_tracking_radar.gif's own baked-in card background
  // (sampled directly from its pixels: ~rgb(16,30,81) at the top of the
  // card down to ~rgb(22,41,102) near the bottom) rather than an
  // independently-chosen navy — the GIF is a pre-rendered image with its
  // own fixed background baked into every frame, so the only way for the
  // page behind it to look seamless with it is to copy its colours, not
  // the other way around.
  static const Color _navyTop = Color(0xFF101E51);
  static const Color _navyBottom = Color(0xFF162966);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_navyTop, _navyBottom],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              // Back arrow row, kept at a fixed height whether or not the
              // arrow is shown, so the content below doesn't shift position
              // depending on whether a back action was passed in.
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    if (onBack != null)
                      IconButton(
                        onPressed: onBack,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Finding you\nthe best driver",
                textAlign: TextAlign.center,
                style: PoppinsSemiBold.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Please wait a moment...",
                textAlign: TextAlign.center,
                style: PoppinsReguler.copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 13,
                ),
              ),

              // Expanded + Center rather than fixed spacing above and below:
              // the radar then sits optically centred in whatever vertical
              // room is left, on a small phone and a tall one alike.
              Expanded(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Bounded by the narrower of the two axes so the radar
                      // can never overflow its slot in landscape or on a
                      // short screen. Same clamp range the hand-drawn radar
                      // this replaced used, so the swap doesn't change how
                      // much of the screen it claims on any given device.
                      final double available = constraints.maxWidth <
                              constraints.maxHeight
                          ? constraints.maxWidth
                          : constraints.maxHeight;
                      final double size = available.clamp(180.0, 300.0);
                      // car_tracking_radar.gif is a pre-rendered, square,
                      // self-contained rings-and-cars radar with its own
                      // baked-in card background (transparent only at its
                      // four true corners). _navyTop/_navyBottom above are
                      // matched to that same baked-in background rather
                      // than chosen independently, so the page behind the
                      // GIF's transparent corners reads as one continuous
                      // surface instead of two different navies meeting at
                      // a visible seam.
                      return Image.asset(
                        'assets/images/car_tracking_radar.gif',
                        width: size,
                        height: size,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => SizedBox(
                          width: size,
                          height: size,
                          child: const Icon(
                            Icons.radar_rounded,
                            color: Colors.white24,
                            size: 64,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const _SearchingStatusCard(),

              if (onCancelRide != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: onCancelRide,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Cancel Ride",
                      style: PoppinsSemiBold.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

/// The bottom "Searching in your area" panel.
class _SearchingStatusCard extends StatelessWidget {
  const _SearchingStatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Searching in your area",
                  style: PoppinsSemiBold.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "We're looking for nearby drivers\nto confirm your ride.",
                  style: PoppinsReguler.copyWith(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
