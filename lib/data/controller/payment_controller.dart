import 'dart:async';
import 'package:get/get.dart';
import 'package:myrideuser/config/route.dart';
import 'package:myrideuser/data/repository/booking_repo.dart';

enum PaymentState { loading, waiting, paid, error }

class PaymentController extends GetxController {
  final BookingRepo bookingRepo;

  PaymentController({required this.bookingRepo});

  final Rx<PaymentState> state = PaymentState.loading.obs;
  final RxString errorMessage = ''.obs;

  Timer? _pollTimer;
  String? _bookingId;
  bool _initialized = false;

  Future<void> init(String bookingId) async {
    if (_initialized && _bookingId == bookingId) return;
    _bookingId = bookingId;
    _initialized = true;
    _pollTimer?.cancel();
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
        final isPaid = data['is_paid'] as bool? ?? false;
        if (isPaid) {
          _onPaid();
        } else {
          state.value = PaymentState.waiting;
          _startPolling();
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

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (state.value != PaymentState.waiting) {
        _pollTimer?.cancel();
        return;
      }
      try {
        final response = await bookingRepo.getPaymentStatus(bookingId: _bookingId!);
        if (response.statusCode == 200 &&
            response.body is Map &&
            response.body['code']?.toString() == '200') {
          final data = response.body['data'] as Map<String, dynamic>? ?? {};
          final isPaid = data['is_paid'] as bool? ?? false;
          if (isPaid) _onPaid();
        }
      } catch (_) {}
    });
  }

  void _onPaid() async {
    _pollTimer?.cancel();
    state.value = PaymentState.paid;
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(RouteHelper.getmainNavigationScreen());
  }

  Future<void> retryInit() async {
    _initialized = false;
    if (_bookingId != null) await init(_bookingId!);
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}
