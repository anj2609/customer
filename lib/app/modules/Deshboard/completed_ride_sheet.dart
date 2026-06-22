import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/config/utils/colors.dart';
import 'package:myrideuser/data/controller/payment_controller.dart';
import 'package:myrideuser/data/modal/trackride_model.dart';
import 'package:myrideuser/widgets/custom_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

class _CompletedRideSheetState extends State<CompletedRideSheet>
    with WidgetsBindingObserver {
  int _selectedMood = -1;

  final List<IconData> _moodIcons = [
    Icons.sentiment_very_dissatisfied,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_satisfied,
    Icons.sentiment_very_satisfied,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PaymentController>().init(widget.bookingId);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<PaymentController>().checkNowIfQrActive();
    }
  }

  bool _isPaymentResolved(PaymentState state) =>
      state == PaymentState.cashDone ||
      state == PaymentState.onlinePaid ||
      state == PaymentState.walletDone;

  @override
  Widget build(BuildContext context) {
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
                  decoration: const BoxDecoration(
                    color: Colors.red,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TripInfoTile(
                        icon: Icons.access_time,
                        title: widget.tripDetails['estimated_time']?.toString() ??
                            '0.0',
                        subtitle: 'Duration',
                      ),
                      _TripInfoTile(
                        icon: Icons.route,
                        title: widget.tripDetails['total_fare']?.toString() ??
                            '0.0',
                        subtitle: 'Distance',
                      ),
                      _TripInfoTile(
                        icon: Icons.speed,
                        title: widget.tripDetails['distance_km']?.toString() ??
                            '0.0',
                        subtitle: 'Avg. Speed',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                /// PAYMENT SECTION
                Obx(() {
                  final payCtrl = Get.find<PaymentController>();
                  final ps = payCtrl.state.value;
                  return _buildPaymentSection(context, payCtrl, ps);
                }),

                /// MOOD + FINISH — shown only when payment is done
                Obx(() {
                  final ps = Get.find<PaymentController>().state.value;
                  if (!_isPaymentResolved(ps)) return const SizedBox.shrink();
                  return _buildMoodAndFinish(context);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentSection(
    BuildContext context,
    PaymentController payCtrl,
    PaymentState ps,
  ) {
    switch (ps) {
      case PaymentState.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Checking payment status…', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );

      case PaymentState.cash:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payments_outlined, color: Colors.orange, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cash Payment',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Please hand cash to the driver.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomPrimaryButton(
              text: 'Confirm Cash Payment',
              onTap: () => payCtrl.confirmCashPayment(),
            ),
            const SizedBox(height: 24),
          ],
        );

      case PaymentState.cashConfirming:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: CustomOtpButton(
            text: 'Confirming…',
            onTap: null,
            isLoading: true,
          ),
        );

      case PaymentState.cashDone:
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text(
                'Cash payment confirmed',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
        );

      case PaymentState.onlineComingSoon:
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.purple.shade200),
          ),
          child: const Column(
            children: [
              Icon(Icons.smartphone_outlined, color: Colors.purple, size: 40),
              SizedBox(height: 12),
              Text(
                'Online Payment',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              SizedBox(height: 6),
              Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Online payment will be available soon. Please use cash or wallet.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );

      case PaymentState.wallet:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.blue, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Wallet Payment',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Available Balance: ₹${payCtrl.walletBalance.value.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomPrimaryButton(
              text: 'Pay via Wallet',
              onTap: () => payCtrl.confirmWalletPayment(),
            ),
            const SizedBox(height: 24),
          ],
        );

      case PaymentState.walletConfirming:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: CustomOtpButton(
            text: 'Processing…',
            onTap: null,
            isLoading: true,
          ),
        );

      case PaymentState.walletDone:
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wallet Payment Successful!',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Balance: ₹${payCtrl.walletBalance.value.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )),
              ),
            ],
          ),
        );

      case PaymentState.onlineLoadingQr:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Generating QR code…', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );

      case PaymentState.onlineQrReady:
        return _buildQrSection(context, payCtrl);

      case PaymentState.onlineQrExpired:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.timer_off_outlined, color: Colors.red, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'QR code has expired',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomPrimaryButton(
              text: 'Generate New QR',
              onTap: () => payCtrl.regenerateQr(),
            ),
            const SizedBox(height: 24),
          ],
        );

      case PaymentState.onlinePaid:
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Successful!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Thank you for using MyRide',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );

      case PaymentState.error:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      payCtrl.errorMessage.value.isNotEmpty
                          ? payCtrl.errorMessage.value
                          : 'Something went wrong.',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomPrimaryButton(
              text: 'Try Again',
              onTap: () => payCtrl.retryInit(),
            ),
            const SizedBox(height: 24),
          ],
        );
    }
  }

  Widget _buildQrSection(BuildContext context, PaymentController payCtrl) {
    return Column(
      children: [
        const Text(
          'Scan to pay',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Obx(() {
          final amountVal = payCtrl.amount.value;
          return Text(
            '₹${amountVal.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: ColorResources.appColor,
            ),
          );
        }),
        const SizedBox(height: 12),

        /// QR IMAGE
        Obx(() {
          final url = payCtrl.qrImageUrl.value;
          if (url.isEmpty) return const SizedBox.shrink();
          return Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(10),
            child: QrImageView(
              data: url,
              version: QrVersions.auto,
              size: 200,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          );
        }),

        const SizedBox(height: 12),

        /// EXPIRY COUNTDOWN
        Obx(() {
          final expires = payCtrl.expiresAt.value;
          if (expires == null) return const SizedBox.shrink();
          final left = payCtrl.timeLeft.value;
          final minutes = left.inMinutes.remainder(60).toString().padLeft(2, '0');
          final seconds = left.inSeconds.remainder(60).toString().padLeft(2, '0');
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Expires in $minutes:$seconds',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          );
        }),
        const SizedBox(height: 8),

        const Text(
          'Scan with any UPI app to complete payment',
          style: TextStyle(color: Colors.grey, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMoodAndFinish(BuildContext context) {
    final details = widget.tripDetails;
    final data = widget.rideData;

    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'How was your mood during this trip?',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            5,
            (index) => GestureDetector(
              onTap: () => setState(() => _selectedMood = index),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: _selectedMood == index
                    ? Colors.blue.shade50
                    : Colors.transparent,
                child: Icon(
                  _moodIcons[index],
                  color: _selectedMood == index ? Colors.blue : Colors.black54,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        CustomPrimaryButton(
          text: 'Finish',
          onTap: () {
            if (_selectedMood == -1) {
              Get.snackbar(
                'Selection Required',
                'Please select your experience',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
            widget.onTimerCancel();
            Get.offAndToNamed(
              RouteHelper.getdriverRatingScreen(),
              arguments: {
                'booking_id': widget.bookingId,
                'drivername': data?.driverInfo?.name ?? '',
                'details': details['distance_km'] ?? '0.0',
                'estimatetime': details['estimated_time'] ?? '0.0',
                'distance': details['total_fare'] ?? '0.0',
                'distancekillo': details['distance_km'] ?? '0.0',
                'base_fare': details['base_fare'],
                'discount': details['discount_fare'],
                'total': details['total_fare'],
                'profile': data?.driverInfo?.profileImage ?? '',
              },
            );
          },
        ),
        const SizedBox(height: 12),
      ],
    );
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
