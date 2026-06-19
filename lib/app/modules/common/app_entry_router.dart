import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/widgets/toaster_animation.dart';

class AppEntryRouter extends StatefulWidget {
  const AppEntryRouter({super.key});

  @override
  State<AppEntryRouter> createState() => _AppEntryRouterState();
}

class _AppEntryRouterState extends State<AppEntryRouter> {
  @override
  void initState() {
    super.initState();
    // Run after the first frame so the loading UI is visible before async work.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndRoute());
  }

  Future<void> _checkAndRoute() async {
    final controller = Get.find<BookingController>();

    try {
      await controller.checkActiveBookingApi();
    } catch (_) {
      _routeToHome(showError: true);
      return;
    }

    if (!mounted) return;
    _routeBasedOnState(controller.activeBookingState.value);
  }

  void _routeBasedOnState(BookingActiveState state) {
    switch (state.status) {
      case BookingStatus.pending:
      case BookingStatus.accepted:
      case BookingStatus.arrived:
      case BookingStatus.ongoing:
        // Always validate booking_id before routing to a ride screen.
        if (state.bookingId != null && state.bookingId!.isNotEmpty) {
          Get.offAllNamed(
            RouteHelper.getfindingDriverUI(),
            arguments: {'booking_id': state.bookingId},
          );
        } else {
          _routeToHome();
        }
        break;
      case BookingStatus.completed:
      case BookingStatus.cancelled:
      case BookingStatus.none:
      case BookingStatus.unknown:
        _routeToHome();
        break;
    }
  }

  void _routeToHome({bool showError = false}) {
    Get.offAllNamed(RouteHelper.getmainNavigationScreen());
    if (showError) {
      Future.microtask(() {
        final ctx = Get.context;
        if (ctx != null) {
          AnimatedTopToast.show(
            context: ctx,
            message:
                "Couldn't check your ride status. Please check your connection.",
            backgroundColor: Colors.orange,
            icon: Icons.wifi_off_rounded,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2DA6C4),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
      ),
    );
  }
}
