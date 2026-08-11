import 'dart:async';

import 'package:myrideuser/config/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/colors.dart';

/// Splash animation on the brand gradient (#292B84 → #0004CF). The source
/// clip ("transparent final.mov") is ProRes 4444 with a real alpha
/// channel — a format Android's video player can't decode at all, so it
/// can't be played directly (it would fail to load and skip straight
/// past the splash). Since the background here is always this exact
/// gradient anyway, the alpha video was composited onto it once (ffmpeg,
/// baked frame-by-frame) and re-exported as a normal H.264 MP4
/// (splash_animation.mp4) — pixel-identical to true transparency on
/// screen, but a format every device can actually decode.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoReady = false;
  bool _hasNavigated = false;

  /// Hard cap so a failed/slow video load can never strand the user on
  /// the splash screen indefinitely.
  static const Duration _maxSplashDuration = Duration(seconds: 8);

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(
      'assets/images/splash_animation.mp4',
    );

    _videoController
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() => _isVideoReady = true);
          _videoController.setLooping(false);
          _videoController.play();
          _videoController.addListener(_onVideoProgress);
        })
        .catchError((e) {
          debugPrint("Splash video error: $e");
          _navigateAfterDelay();
        });

    Future.delayed(_maxSplashDuration, _navigateAfterDelay);
  }

  void _onVideoProgress() {
    final value = _videoController.value;
    if (value.isInitialized &&
        !value.isPlaying &&
        value.position >= value.duration &&
        value.duration > Duration.zero) {
      _navigateAfterDelay();
    }
  }

  Future<void> _navigateAfterDelay() async {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(ApiConstants.token);
    final String? userId = prefs.getString(ApiConstants.profileid);

    customerId = userId?.toString();

    if (token != null && token.isNotEmpty) {
      // Always ask the server — never trust a stale local bookingid.
      Get.offAllNamed(RouteHelper.getAppEntryRouter());
    } else {
      final bool hasSeenOnboarding =
          prefs.getBool('has_seen_onboarding') ?? false;
      if (hasSeenOnboarding) {
        Get.toNamed(RouteHelper.getLestMyRideStartedScreenRoute());
      } else {
        Get.toNamed(RouteHelper.getOnboardingRoute());
      }
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_onVideoProgress);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Matches the video's own baked-in gradient so any letterboxing
        // (if the screen's aspect ratio differs from the video's 9:16)
        // blends in seamlessly instead of showing a visible video edge.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: ColorResources.primaryGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _isVideoReady
              ? AspectRatio(
                  // BoxFit.contain (never crops) — fits the video to the
                  // full screen width/height without cutting anything off.
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
