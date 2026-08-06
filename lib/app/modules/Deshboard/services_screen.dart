import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:myrideuser/app/modules/Deshboard/outstation_trip_screen.dart';
import 'package:myrideuser/app/modules/Deshboard/rentals_intro_screen.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/constants.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/booking_controller.dart';
import 'package:myrideuser/data/modal/vehicle_type_model.dart';

/// "Services" tab — the real vehicle catalog from vehical-type-list (same
/// data already shown on the home screen), browsable outside a booking
/// flow, plus the same quick-actions and rentals/outstation shortcuts
/// available on the home screen. Tapping a vehicle, or Home/Work/Airport,
/// switches to the Home tab and opens the destination search there (same
/// signal used for vehicle taps) since picking one still needs a real
/// pickup/drop before anything can be booked; Saved opens the saved
/// addresses screen directly, same as on Home.
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();

    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Same header format as Activity/Account: N Ride logo top-left,
            // title centered in the row via matching Spacers on both sides.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/splashscreen.png',
                      height: 20,
                      color: ColorResources.blueeebutton,
                    ),
                  ),
                  Text(
                    "Services",
                    style: PoppinsSemiBold.copyWith(
                      fontSize: 16,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _quickActionsRow(bookingController),
                      const SizedBox(height: 24),
                      _forYouSection(),
                      const SizedBox(height: 24),
                      Text(
                        "Choose a vehicle",
                        style: PoppinsSemiBold.copyWith(
                          fontSize: 14,
                          color: ColorResources.blackcolor11,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GetBuilder<BookingController>(
                        builder: (bc) {
                          if (bc.isVehicleTypeLoading && bc.vehicleTypeList.isEmpty) {
                            return _grid(List.generate(6, (_) => _cardSkeleton()));
                          }
                          if (bc.vehicleTypeList.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(
                                  "No vehicles available right now",
                                  style: PoppinsMedium.copyWith(
                                    fontSize: 14,
                                    color: ColorResources.TextColorForGrey,
                                  ),
                                ),
                              ),
                            );
                          }
                          return _grid(
                            bc.vehicleTypeList
                                .map((type) => _vehicleCard(type, bookingController))
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQuickAction(String type, BookingController bookingController) {
    switch (type) {
      case 'saved':
        Get.toNamed(RouteHelper.getsavedAddressScreen());
        break;
      default:
        // home / work / airport — same signal a vehicle tap uses: switch to
        // Home and open destination search there. Auto-filling a saved
        // address or a fixed "Agartala Airport" search (like the Home
        // screen's own quick actions do) needs DashboardScreen's own
        // pickup/geocoding state, which this screen doesn't have — so this
        // opens search rather than guessing/duplicating that logic.
        bookingController.pendingOpenSearch.value = true;
        bookingController.bottomNavIndex.value = 0;
    }
  }

  Widget _quickActionsRow(BookingController bookingController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickActionItem(
          icon: Icons.home_rounded,
          label: "Home",
          onTap: () => _onQuickAction('home', bookingController),
        ),
        _quickActionItem(
          icon: Icons.work_rounded,
          label: "Work",
          onTap: () => _onQuickAction('work', bookingController),
        ),
        _quickActionItem(
          icon: Icons.flight_takeoff_rounded,
          label: "Airport",
          onTap: () => _onQuickAction('airport', bookingController),
        ),
        _quickActionItem(
          icon: Icons.bookmark_rounded,
          label: "Saved",
          onTap: () => _onQuickAction('saved', bookingController),
        ),
      ],
    );
  }

  Widget _quickActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ColorResources.blueeebutton.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: ColorResources.blueeebutton, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: PoppinsMedium.copyWith(
                fontSize: 12,
                color: ColorResources.blackcolor11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "For you",
          style: PoppinsSemiBold.copyWith(
            fontSize: 14,
            color: ColorResources.blackcolor11,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _forYouItem(
              icon: Icons.time_to_leave_rounded,
              label: "Rentals",
              onTap: () => Get.to(() => const RentalsIntroScreen()),
            ),
            const SizedBox(width: 20),
            _forYouItem(
              icon: Icons.luggage_rounded,
              label: "Outstation",
              onTap: () => Get.to(() => const OutstationTripScreen()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _forYouItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ColorResources.blueeebutton.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ColorResources.blueeebutton, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: PoppinsMedium.copyWith(
              fontSize: 12,
              color: ColorResources.blackcolor11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _grid(List<Widget> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final itemWidth = (constraints.maxWidth - spacing * 2) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: cards.map((card) => SizedBox(width: itemWidth, child: card)).toList(),
        );
      },
    );
  }

  Widget _vehicleCard(VehicleTypeModel type, BookingController bookingController) {
    return GestureDetector(
      onTap: () {
        bookingController.pendingOpenSearch.value = true;
        bookingController.bottomNavIndex.value = 0;
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorResources.greycolorborder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: _vehicleImage(type.image),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              type.name ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PoppinsMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackcolor11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Same "never crop, whatever the source template" approach used
  /// elsewhere for this catalog's images.
  Widget _vehicleImage(String? image) {
    if (image == null || image.isEmpty) {
      return Container(
        color: ColorResources.backgroundColor,
        child: Center(
          child: Image.asset('assets/images/cart.png', height: 26),
        ),
      );
    }
    return Container(
      color: ColorResources.backgroundColor,
      child: Image.network(
        '${ApiConstants.imageurl}$image',
        fit: BoxFit.contain,
        alignment: Alignment.center,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 1.6),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Image.asset('assets/images/cart.png', height: 26),
          );
        },
      ),
    );
  }

  Widget _cardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorResources.greycolorborder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Container(color: ColorResources.blueeebutton.withValues(alpha: 0.08)),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 70,
            height: 12,
            decoration: BoxDecoration(
              color: ColorResources.blueeebutton.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
