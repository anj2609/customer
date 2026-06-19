import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/config/utils/style.dart';
import 'package:myrideuser/data/controller/profile_controller.dart';
import 'package:myrideuser/data/modal/ride_location_model.dart';

/// A reusable widget that shows the user's recent ride locations
/// inside the dashboard bottom sheet.
///
/// Handles four states: loading, success (has data), empty, and error.
/// Uses [GetBuilder<ProfileController>] to react to state changes,
/// consistent with the rest of the app.
class RecentLocationsList extends StatefulWidget {
  /// Optional callback fired after the user taps a location.
  /// Receives the tapped [RideLocation].
  final void Function(RideLocation)? onLocationSelected;

  const RecentLocationsList({super.key, this.onLocationSelected});

  @override
  State<RecentLocationsList> createState() => _RecentLocationsListState();
}

class _RecentLocationsListState extends State<RecentLocationsList> {
  @override
  void initState() {
    super.initState();
    // Defer to after the first frame to avoid calling update() during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fetchRecentLocations();
    });
  }

  void _fetchRecentLocations() {
    if (!mounted) return;
    Get.find<ProfileController>().fetchRecentLocations();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        debugPrint('🔍 [RecentLocationsList] BUILD called — '
            'loading=${controller.isRecentLocationsLoading}, '
            'error=${controller.recentLocationsError}, '
            'count=${controller.recentLocations.length}');

        // ── Loading state ──────────────────────────────────
        if (controller.isRecentLocationsLoading) {
          debugPrint('   → Rendering SHIMMER (loading)');
          return _buildShimmer();
        }

        // ── Error state ────────────────────────────────────
        if (controller.recentLocationsError != null) {
          debugPrint('   → Rendering ERROR: ${controller.recentLocationsError}');
          return _buildError(controller.recentLocationsError!);
        }

        // ── Empty state ────────────────────────────────────
        if (controller.recentLocations.isEmpty) {
          debugPrint('   → Rendering EMPTY ("No trips yet")');
          return _buildEmpty();
        }

        // ── Success state ──────────────────────────────────
        debugPrint('   → Rendering LIST with ${controller.recentLocations.length} items');
        return _buildList(controller.recentLocations);
      },
    );
  }

  // ═════════════════════════════════════════════════════════════
  //  LOADING — 3 skeleton rows
  // ═════════════════════════════════════════════════════════════

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(3, (_) => _shimmerRow()),
    );
  }

  Widget _shimmerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Icon placeholder
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 140,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  //  ERROR — short message + Retry button
  // ═════════════════════════════════════════════════════════════

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 28,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: PoppinsReguler.copyWith(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _fetchRecentLocations,
              child: Text(
                "Retry",
                style: PoppinsMedium.copyWith(
                  fontSize: 13,
                  color: ColorResources.appColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  //  EMPTY — friendly message
  // ═════════════════════════════════════════════════════════════

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 32,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              "No trips yet",
              style: PoppinsMedium.copyWith(
                fontSize: 14,
                color: ColorResources.blackcolor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Search for a destination above to add it to your recent list.",
              style: PoppinsReguler.copyWith(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  //  SUCCESS — list of recent locations
  // ═════════════════════════════════════════════════════════════

  Widget _buildList(List<RideLocation> locations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Recent",
          style: PoppinsMedium.copyWith(
            fontSize: 13,
            color: ColorResources.textdetailsColor,
          ),
        ),
        const SizedBox(height: 4),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: locations.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: Colors.grey.shade100),
          itemBuilder: (context, index) {
            return _locationTile(locations[index]);
          },
        ),
      ],
    );
  }

  Widget _locationTile(RideLocation location) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        if (widget.onLocationSelected != null) {
          widget.onLocationSelected!(location);
        } else {
          // Default: navigate to search screen with the address pre-filled
          Get.toNamed(
            RouteHelper.getsearchLocationScreen(),
            arguments: {'addressdata': location.address},
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // ── Pin icon ──
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ColorResources.appColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.location_on_rounded,
                size: 20,
                color: ColorResources.appColor,
              ),
            ),
            const SizedBox(width: 12),
            // ── Address text ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.placeName,
                    style: PoppinsMedium.copyWith(
                      fontSize: 14,
                      color: ColorResources.blackcolor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (location.secondaryText.isNotEmpty)
                    Text(
                      location.secondaryText,
                      style: PoppinsReguler.copyWith(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // ── Trailing arrow ──
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
