import 'dart:async';

import 'package:myrideuser/config/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/colors.dart';

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
      'assets/images/nride_gif_cropped.mp4',
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
        // Matches the video's own background gradient so the letterboxing
        // above/below the (wider-than-tall) clip blends in seamlessly
        // instead of showing a visible video "frame" edge.
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
                  // BoxFit.contain (never crops) — the clip is wider than
                  // the screen, so this fits it to the full screen width.
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
