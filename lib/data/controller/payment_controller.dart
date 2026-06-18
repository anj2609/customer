import 'dart:async';
import 'package:get/get.dart';
import 'package:myrideuser/data/repository/booking_repo.dart';

enum PaymentState {
  loading,
  cash,
  cashConfirming,
  cashDone,
  onlinePaid,
  onlineLoadingQr,
  onlineQrReady,
  onlineQrExpired,
  error,
}

class PaymentController extends GetxController {
  final BookingRepo bookingRepo;

  PaymentController({required this.bookingRepo});

  final Rx<PaymentState> state = PaymentState.loading.obs;
  final RxString errorMessage = ''.obs;
  final RxString qrImageUrl = ''.obs;
  final RxDouble amount = 0.0.obs;
  final Rx<DateTime?> expiresAt = Rx<DateTime?>(null);
  final Rx<Duration> timeLeft = Duration.zero.obs;

  Timer? _pollTimer;
  Timer? _countdownTimer;
  String? _bookingId;
  bool _initialized = false;

  Future<void> init(String bookingId) async {
    if (_initialized && _bookingId == bookingId) return;
    _bookingId = bookingId;
    _initialized = true;
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    state.value = PaymentState.loading;
    await _checkPaymentStatus();
  }

  Future<void> _checkPaymentStatus() async {
    try {
      final response = await bookingRepo.getPaymentStatus(bookingId: _bookingId!);
      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['code']?.toString() == '200') {
        final data = response.body['data'] as Map<String, dynamic>? ?? {};
        final paymentType = data['payment_type']?.toString() ?? '';
        final isPaid = data['is_paid'] as bool? ?? false;

        if (paymentType == 'online') {
          if (isPaid) {
            state.value = PaymentState.onlinePaid;
          } else {
            await _generateQr();
          }
        } else {
          // cash or any other type
          state.value = PaymentState.cash;
        }
      } else {
        errorMessage.value = (response.body is Map)
            ? (response.body['message']?.toString() ?? 'Unable to check payment status.')
            : 'Unable to check payment status.';
        state.value = PaymentState.error;
      }
    } catch (_) {
      errorMessage.value = 'Connection error. Please try again.';
      state.value = PaymentState.error;
    }
  }

  Future<void> confirmCashPayment() async {
    state.value = PaymentState.cashConfirming;
    try {
      final response = await bookingRepo.completeRide(bookingId: _bookingId!);
      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['code']?.toString() == '200') {
        state.value = PaymentState.cashDone;
      } else {
        errorMessage.value = (response.body is Map)
            ? (response.body['message']?.toString() ?? 'Failed to confirm payment.')
            : 'Failed to confirm payment.';
        state.value = PaymentState.cash;
      }
    } catch (_) {
      errorMessage.value = 'Connection error. Please try again.';
      state.value = PaymentState.cash;
    }
  }

  Future<void> _generateQr() async {
    state.value = PaymentState.onlineLoadingQr;
    // Up to 4 attempts: immediate + 3 retries with increasing delay
    const retryDelays = [0, 1500, 3000, 5000];

    for (int attempt = 0; attempt < retryDelays.length; attempt++) {
      if (attempt > 0) {
        await Future.delayed(Duration(milliseconds: retryDelays[attempt]));
      }
      try {
        final response = await bookingRepo.generateQrPayment(bookingId: _bookingId!);
        if (response.statusCode == 200 &&
            response.body is Map &&
            response.body['code']?.toString() == '200') {
          final data = response.body['data'] as Map<String, dynamic>? ?? {};
          final imageUrl = data['image_url']?.toString();

          if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null') {
            qrImageUrl.value = imageUrl;
            amount.value = (data['amount'] as num?)?.toDouble() ?? 0.0;
            final expiresAtStr = data['expires_at']?.toString();
            if (expiresAtStr != null &&
                expiresAtStr.isNotEmpty &&
                expiresAtStr != 'null') {
              expiresAt.value = DateTime.tryParse(expiresAtStr);
              _startCountdown();
            }
            state.value = PaymentState.onlineQrReady;
            _startPolling();
            return;
          }
          // image_url was null — fall through to retry
        } else {
          errorMessage.value = (response.body is Map)
              ? (response.body['message']?.toString() ?? 'Failed to generate QR code.')
              : 'Failed to generate QR code.';
          state.value = PaymentState.error;
          return;
        }
      } catch (_) {
        if (attempt == retryDelays.length - 1) {
          errorMessage.value = 'Connection error. Please try again.';
          state.value = PaymentState.error;
          return;
        }
      }
    }

    errorMessage.value = 'QR code is not available. Please try again.';
    state.value = PaymentState.error;
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (state.value == PaymentState.onlineQrReady) {
        _pollPaymentStatus();
      } else {
        _pollTimer?.cancel();
      }
    });
  }

  Future<void> _pollPaymentStatus() async {
    try {
      final response = await bookingRepo.getPaymentStatus(bookingId: _bookingId!);
      if (response.statusCode == 200 &&
          response.body is Map &&
          response.body['code']?.toString() == '200') {
        final data = response.body['data'] as Map<String, dynamic>? ?? {};
        final isPaid = data['is_paid'] as bool? ?? false;
        if (isPaid) {
          _pollTimer?.cancel();
          _countdownTimer?.cancel();
          state.value = PaymentState.onlinePaid;
        }
      }
    } catch (_) {}
  }

  void checkNowIfQrActive() {
    if (state.value == PaymentState.onlineQrReady) {
      _pollPaymentStatus();
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    if (expiresAt.value == null) return;
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (expiresAt.value == null) return;
    final remaining = expiresAt.value!.difference(DateTime.now());
    if (remaining.isNegative || remaining.inSeconds <= 0) {
      _countdownTimer?.cancel();
      _pollTimer?.cancel();
      timeLeft.value = Duration.zero;
      if (state.value == PaymentState.onlineQrReady) {
        state.value = PaymentState.onlineQrExpired;
      }
    } else {
      timeLeft.value = remaining;
    }
  }

  Future<void> regenerateQr() async {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    expiresAt.value = null;
    timeLeft.value = Duration.zero;
    await _generateQr();
  }

  Future<void> retryInit() async {
    _initialized = false;
    if (_bookingId != null) await init(_bookingId!);
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    super.onClose();
  }
}
