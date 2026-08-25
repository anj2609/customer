import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/data/controller/payment_controller.dart';
import 'package:myrideuser/data/modal/trackride_model.dart';
import 'package:myrideuser/data/modal/trip_detail_model.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:myrideuser/widgets/price_breakdown_card.dart';

class CompletedRideSheet extends StatefulWidget {
  final String bookingId;
  final DatTrackRideDetails? rideData;
  final Map<String, dynamic> tripDetails;
  final String dropAddress;
  final VoidCallback onTimerCancel;

  const CompletedRideSheet({
    Key? key,
    required this.bookingId,
    required this.rideData,
    required this.tripDetails,
    required this.dropAddress,
    required this.onTimerCancel,
  }) : super(key: key);

  @override
  State<CompletedRideSheet> createState() => _CompletedRideSheetState();
}

class _CompletedRideSheetState extends State<CompletedRideSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PaymentController>().init(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Parsed once and reused for both the stats row and the price card
    // below — was previously built twice: this fresh parse here, plus a
    // second one inside the Builder further down. Same map, same result,
    // just duplicated work and a second place for the two to drift apart.
    final TripDetailData tripData = TripDetailData.fromJson(
      Map<String, dynamic>.from(widget.tripDetails),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// TOP ARRIVAL ICON
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: ColorResources.textColorRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'You have arrived!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 10),

                /// DRIVER NAME
                Text(
                  widget.rideData?.driverInfo?.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                /// DROP ADDRESS
                Text(
                  widget.dropAddress,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 20),

                /// TRIP STATS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Builder(
                    builder: (_) {
                      final duration = tripData.rideStats?.duration;
                      final distance = tripData.rideStats?.distance;
                      // km/h from the same two figures already shown, rather
                      // than a separate (and previously wrong — this tile
                      // used to just repeat the distance figure under an
                      // "Avg. Speed" label) backend field. Left blank rather
                      // than a divide-by-zero guess when duration isn't
                      // known yet.
                      final String avgSpeedText =
                          (duration != null && duration > 0 && distance != null && distance > 0)
                              ? '${(distance / (duration / 60)).toStringAsFixed(0)} km/h'
                              : '-';

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _TripInfoTile(
                            icon: Icons.access_time,
                            title: formatTripDuration(duration),
                            subtitle: 'Duration',
                          ),
                          _TripInfoTile(
                            icon: Icons.route,
                            title: formatTripDistance(distance),
                            subtitle: 'Distance',
                          ),
                          _TripInfoTile(
                            icon: Icons.speed,
                            title: avgSpeedText,
                            subtitle: 'Avg. Speed',
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                /// PRICE/PAYMENT — real figures from /trip-detail. A live
                /// completed booking was found to return a "payment"
                /// object (total/final fare, discounts, wallet used), not
                /// the richer "price_breakdown" the UI originally only
                /// looked for — PriceBreakdownCard now renders whichever
                /// one is actually present, nothing if neither is.
                if (tripData.priceBreakdown != null || tripData.payment != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: PriceBreakdownCard(tripData: tripData),
                  ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                /// PAYMENT STATUS
                Obx(() {
                  final ps = Get.find<PaymentController>().state.value;
                  return _buildPaymentStatus(ps);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentStatus(PaymentState ps) {
    switch (ps) {
      case PaymentState.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text(
                'Checking payment status…',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );

      case PaymentState.waiting:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              CircularProgressIndicator(color: ColorResources.appColor),
              const SizedBox(height: 16),
              const Text(
                'Waiting for payment confirmation…',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Please complete payment to the driver.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );

      case PaymentState.paid:
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorResources.greencolor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ColorResources.greencolor.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(Icons.check_circle, color: ColorResources.greencolor, size: 48),
              SizedBox(height: 12),
              Text(
                'Thank you for choosing us!',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Text(
                'Payment confirmed. Redirecting…',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );

      case PaymentState.error:
        final ctrl = Get.find<PaymentController>();
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorResources.textColorRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ColorResources.textColorRed.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: ColorResources.textColorRed, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => Text(
                      ctrl.errorMessage.value.isNotEmpty
                          ? ctrl.errorMessage.value
                          : 'Something went wrong.',
                      style: const TextStyle(fontSize: 13),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomPrimaryButton(
              text: 'Try Again',
              onTap: () => ctrl.retryInit(),
            ),
            const SizedBox(height: 24),
          ],
        );
    }
  }
}

class _TripInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TripInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.black54),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
