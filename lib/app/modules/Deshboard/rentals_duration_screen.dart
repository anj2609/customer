import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:myrideuser/app/modules/Deshboard/rentals_location_screen.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/widgets/custom_button.dart';

/// Duration picker for N Ride Rentals. Only "Leave now" is offered — no
/// "Leave later" scheduling, per product decision. Only real user-chosen
/// state (the hour count) is shown; no price/km-allowance is displayed
/// since there's no backend rate to calculate it from yet.
class RentalsDurationScreen extends StatefulWidget {
  const RentalsDurationScreen({super.key});

  @override
  State<RentalsDurationScreen> createState() => _RentalsDurationScreenState();
}

class _RentalsDurationScreenState extends State<RentalsDurationScreen> {
  static const int _minHours = 1;
  static const int _maxHours = 12;
  int _hours = 1;

  void _decrement() {
    if (_hours > _minHours) setState(() => _hours--);
  }

  void _increment() {
    if (_hours < _maxHours) setState(() => _hours++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "How much time do you need?",
                style: PoppinsBold.copyWith(
                  fontSize: 24,
                  color: ColorResources.blackcolor11,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _stepperButton(
                  icon: Icons.remove_rounded,
                  enabled: _hours > _minHours,
                  onTap: _decrement,
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    _hours == 1 ? "1 hour" : "$_hours hours",
                    textAlign: TextAlign.center,
                    style: PoppinsBold.copyWith(
                      fontSize: 32,
                      color: ColorResources.blackcolor11,
                    ),
                  ),
                ),
                _stepperButton(
                  icon: Icons.add_rounded,
                  enabled: _hours < _maxHours,
                  onTap: _increment,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: ColorResources.blueeebutton,
                  inactiveTrackColor: ColorResources.greycolorborder,
                  thumbColor: ColorResources.blueeebutton,
                  overlayColor: ColorResources.blueeebutton.withValues(alpha: 0.15),
                ),
                child: Slider(
                  value: _hours.toDouble(),
                  min: _minHours.toDouble(),
                  max: _maxHours.toDouble(),
                  divisions: _maxHours - _minHours,
                  onChanged: (value) => setState(() => _hours = value.round()),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: ColorResources.blueeebutton.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 18, color: ColorResources.blueeebutton),
                    const SizedBox(width: 6),
                    Text(
                      "Leave now",
                      style: PoppinsMedium.copyWith(
                        fontSize: 14,
                        color: ColorResources.blueeebutton,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomPrimaryDyanamicButton(
                text: "Choose a ride",
                onTap: () => Get.to(() => RentalsLocationScreen(hours: _hours)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: ColorResources.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: enabled
              ? ColorResources.blackcolor11
              : ColorResources.TextColorForGrey,
        ),
      ),
    );
  }
}
