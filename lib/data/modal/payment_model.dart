class PaymentStatusModel {
  final String code;
  final bool isPaid;
  final String status;
  final String paymentType;

  PaymentStatusModel({
    required this.code,
    required this.isPaid,
    required this.status,
    required this.paymentType,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return PaymentStatusModel(
      code: json['code']?.toString() ?? '',
      isPaid: data['is_paid'] as bool? ?? false,
      status: data['status']?.toString() ?? '',
      paymentType: data['payment_type']?.toString() ?? '',
    );
  }
}

class QrPaymentModel {
  final int? bookingId;
  final String qrId;
  final String? imageUrl;
  final double amount;
  final DateTime? expiresAt;

  QrPaymentModel({
    this.bookingId,
    required this.qrId,
    this.imageUrl,
    required this.amount,
    this.expiresAt,
  });

  factory QrPaymentModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final expiresAtStr = data['expires_at']?.toString();
    return QrPaymentModel(
      bookingId: data['booking_id'] as int?,
      qrId: data['qr_id']?.toString() ?? '',
      imageUrl: data['image_url']?.toString(),
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      expiresAt: (expiresAtStr != null && expiresAtStr.isNotEmpty && expiresAtStr != 'null')
          ? DateTime.tryParse(expiresAtStr)
          : null,
    );
  }
}
