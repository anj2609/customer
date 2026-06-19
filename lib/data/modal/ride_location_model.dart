/// Model representing a recent ride location (pickup or drop-off).
///
/// Extracted from completed ride history and deduplicated by address string.
class RideLocation {
  final int? bookingId;
  final String address;
  final double? lat;
  final double? lng;
  final String? createdAt;

  const RideLocation({
    this.bookingId,
    required this.address,
    this.lat,
    this.lng,
    this.createdAt,
  });

  /// Extracts a short place name from a full address.
  ///
  /// Takes everything before the first comma, or the full string if no comma.
  String get placeName {
    final parts = address.split(',');
    return parts.first.trim();
  }

  /// Returns the secondary portion of the address (after the first comma),
  /// or an empty string if there is none.
  String get secondaryText {
    final idx = address.indexOf(',');
    if (idx == -1 || idx + 1 >= address.length) return '';
    return address.substring(idx + 1).trim();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideLocation &&
          runtimeType == other.runtimeType &&
          address == other.address;

  @override
  int get hashCode => address.hashCode;
}
