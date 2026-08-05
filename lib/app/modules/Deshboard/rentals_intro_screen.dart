import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:myrideuser/app/modules/Deshboard/rentals_duration_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';

/// Entry screen for the N Ride Rentals flow. No backend exists for rentals
/// yet, so this screen (and the two after it) are UI/navigation only —
/// nothing here is fabricated data, just the flow structure.
class RentalsIntroScreen extends StatelessWidget {
  const RentalsIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 12),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorResources.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ColorResources.blackcolor11,
                  ),
                ),
              ),
            ),
            // Matches the banner's own aspect ratio (1920x916) instead of a
            // fixed height, so BoxFit.cover never needs to crop the sides
            // to fill a differently-shaped box.
            AspectRatio(
              aspectRatio: 1920 / 916,
              child: Image.asset(
                'assets/images/Banner.jpg.jpeg',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "N Ride Rentals",
                      style: PoppinsSemiBold.copyWith(
                        fontSize: 24,
                        color: ColorResources.blackcolor11,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Fills the remaining space instead of clustering at the
                    // top with large fixed gaps under it.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _bullet(
                            Icons.hourglass_bottom_rounded,
                            "Keep a car and driver for up to 12 hours",
                          ),
                          _bullet(
                            Icons.work_outline_rounded,
                            "Ideal for business meetings, tourist travel and "
                            "multiple stop trips",
                          ),
                          _bullet(
                            Icons.bolt_rounded,
                            "Book now and get going instantly",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomPrimaryDyanamicButton(
                text: "Get started",
                onTap: () => Get.to(() => const RentalsDurationScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: ColorResources.blueeebutton),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: PoppinsReguler.copyWith(
              fontSize: 14,
              color: ColorResources.blackcolor11,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
