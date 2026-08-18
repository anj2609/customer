import 'package:flutter_test/flutter_test.dart';
import 'package:myrideuser/data/modal/ride_location_model.dart';

void main() {
  group('RideLocation', () {
    test('two locations with the same address are equal', () {
      // fetchRecentLocations() relies on this to deduplicate: the same
      // destination reached on three different trips must collapse to one row.
      const a = RideLocation(bookingId: 1, address: 'Noida Sector 62');
      const b = RideLocation(bookingId: 99, address: 'Noida Sector 62');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('a Set dedups by address while preserving insertion order', () {
      final unique = <RideLocation>{};
      unique.add(const RideLocation(address: 'Noida Sector 59'));
      unique.add(const RideLocation(address: 'Noida Sector 62'));
      unique.add(const RideLocation(bookingId: 7, address: 'Noida Sector 59'));

      expect(unique.length, 2);
      expect(
        unique.map((location) => location.address).toList(),
        ['Noida Sector 59', 'Noida Sector 62'],
      );
    });

    test('splits an address into place name and secondary text', () {
      const location = RideLocation(
        address: 'Sector 62, Noida, Uttar Pradesh 201309',
      );

      expect(location.placeName, 'Sector 62');
      expect(location.secondaryText, 'Noida, Uttar Pradesh 201309');
    });

    test('handles an address with no comma', () {
      const location = RideLocation(address: 'Noida');

      expect(location.placeName, 'Noida');
      // The widget only renders secondaryText when it is non-empty, so this
      // must be '' rather than a repeat of the place name.
      expect(location.secondaryText, '');
    });

    test('handles a trailing comma without going out of range', () {
      const location = RideLocation(address: 'Noida,');

      expect(location.placeName, 'Noida');
      expect(location.secondaryText, '');
    });
  });
}
