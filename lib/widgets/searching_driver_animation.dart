import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The "Finding you the best driver" radar: concentric pulsing rings with
/// car icons orbiting the rider's own position at the centre.
///
/// Self-contained and purely decorative — it takes no ride data and makes no
/// calls, so it can be dropped onto any waiting screen. One AnimationController
/// drives both the ring pulse and the orbit so the two never drift out of
/// phase with each other.
class SearchingDriverAnimation extends StatefulWidget {
  /// Outer diameter of the whole radar, including the widest ring.
  final double size;

  /// Cars placed around the orbit, evenly spaced.
  final int carCount;

  const SearchingDriverAnimation({
    super.key,
    this.size = 260,
    this.carCount = 3,
  });

  @override
  State<SearchingDriverAnimation> createState() =>
      _SearchingDriverAnimationState();
}

class _SearchingDriverAnimationState extends State<SearchingDriverAnimation>
    with TickerProviderStateMixin {
  /// One full orbit. Slow on purpose: this sits on screen for as long as the
  /// search takes, and a fast spin reads as agitation rather than progress.
  late final AnimationController _orbit = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  /// The rings' expand-and-fade cycle, independent of the orbit so the two
  /// can have different natural rhythms.
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  @override
  void dispose() {
    _orbit.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ---- Pulsing rings ----
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) {
              return CustomPaint(
                size: Size.square(widget.size),
                painter: _RadarRingsPainter(progress: _pulse.value),
              );
            },
          ),

          // ---- Orbiting cars ----
          AnimatedBuilder(
            animation: _orbit,
            builder: (context, _) {
              final double orbitRadius = widget.size * 0.34;
              return Stack(
                alignment: Alignment.center,
                children: List.generate(widget.carCount, (i) {
                  // Evenly spaced around the circle, then advanced together
                  // by the controller so the whole formation rotates.
                  final double angle =
                      (2 * math.pi / widget.carCount) * i +
                          (_orbit.value * 2 * math.pi);

                  return Transform.translate(
                    offset: Offset(
                      orbitRadius * math.cos(angle),
                      orbitRadius * math.sin(angle),
                    ),
                    // Kept horizontal at every position around the ring,
                    // deliberately not rotated to face the direction of
                    // travel the way an earlier version of this did — a
                    // fixed, single reorientation applied identically to
                    // all three cars, regardless of orbit angle.
                    //
                    // sedan_car_top_view_cropped.png is a top-down car
                    // photo shot nose-up (portrait) — RotatedBox (not
                    // Transform.rotate) is what's needed for a *static* 90°
                    // turn like this: it rotates the layout footprint
                    // itself, swapping width/height, so a 26-wide portrait
                    // image becomes a properly ~26-tall horizontal one
                    // instead of a 26-wide box with a horizontal car
                    // painted inside it (and potentially clipped at the
                    // sides). The crop this asset went through trims it
                    // tight to the car's own silhouette — no padding — the
                    // same convention ridecar.png already followed, so the
                    // rendered size stays comparable to what was here
                    // before at the same width.
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Image.asset(
                        'assets/images/sedan_car_top_view_cropped.png',
                        width: 26,
                        fit: BoxFit.contain,
                        // The source is a full-colour illustration (white
                        // body, dark glass, red mirrors) — srcIn recolours
                        // every non-transparent pixel to a flat white
                        // silhouette, matching the plain white car icons in
                        // the reference design rather than the asset's own
                        // colouring.
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.local_taxi_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // ---- Centre: the rider ----
          Container(
            width: widget.size * 0.29,
            height: widget.size * 0.29,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 18,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.person_pin_circle_rounded,
              size: widget.size * 0.16,
              color: const Color(0xFF123EBC),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three concentric rings that expand outward and fade as they go, so the
/// group reads as a radar sweep radiating from the centre.
class _RadarRingsPainter extends CustomPainter {
  final double progress;

  const _RadarRingsPainter({required this.progress});

  static const int _ringCount = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < _ringCount; i++) {
      // Each ring is offset a third of a cycle from the last, so one is
      // always near the centre as another is fading out at the edge —
      // continuous motion rather than all three blinking together.
      final double t = (progress + (i / _ringCount)) % 1.0;

      // Starts at 30% of the radius rather than 0 so rings emerge from
      // behind the centre badge instead of appearing inside it.
      final double radius = maxRadius * (0.3 + 0.7 * t);
      final double fade = (1.0 - t).clamp(0.0, 1.0);

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = Colors.white.withValues(alpha: 0.30 * fade),
      );

      // A very faint fill under each ring gives the rings some body against
      // the dark background without muddying the ones behind them.
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white.withValues(alpha: 0.03 * fade),
      );
    }
  }

  @override
  bool shouldRepaint(_RadarRingsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
