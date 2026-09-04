import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Builds the draggable pickup pin's [BitmapDescriptor] from an image asset.
///
/// This exists because the supplied artwork
/// (`assets/images/location marker.jpg`) is a **JPEG**, and JPEG has no alpha
/// channel — confirmed on the file itself: `components 3`, no transparency.
/// What looks like a transparent background in an image viewer is the
/// checkerboard *drawn into the pixels* as real light-grey and white squares,
/// the way stock-icon sites render their transparency preview before the file
/// was saved as JPEG. Handed to Google Maps unprocessed, that is a 300x300
/// opaque grey-checkered tile with a pin in the middle, not a pin.
///
/// So the checkerboard is keyed out here at load time rather than asking for
/// a re-exported asset. Runs once per process (see [_cache]).
class PickupMarkerIcon {
  PickupMarkerIcon._();

  static final Map<String, BitmapDescriptor> _cache = {};

  /// A pixel is treated as background when it is both near-greyscale and
  /// light. That separates the checkerboard from every part of this pin:
  /// the ball is saturated red and the stick, while low-saturation, is dark.
  /// Anti-aliased edge pixels keep enough of the pin's chroma to survive.
  static const int _maxBackgroundChroma = 32;
  static const int _minBackgroundLuminance = 150;

  /// Loads [assetPath] as a marker icon [targetWidth] device pixels wide.
  ///
  /// The default is sized to match the car marker's on-map footprint rather
  /// than picked by eye. That car asset is 125x234 rendered at width 20, so
  /// it stands 234 * 20/125 = ~37px tall. This pin crops to 160x282, so
  /// width 22 puts it at 282 * 22/160 = ~39px — the same footprint, give or
  /// take a pixel. (It was 110, which worked out at ~194px tall: over five
  /// times the car, which is what "way too big" was.)
  ///
  /// Never throws: any failure (asset missing, decode error, unsupported
  /// format) falls back to [BitmapDescriptor.defaultMarker] so the map still
  /// gets a usable pin rather than losing the marker entirely.
  static Future<BitmapDescriptor> load(
    String assetPath, {
    int targetWidth = 22,
  }) async {
    final String cacheKey = '$assetPath@$targetWidth';
    final BitmapDescriptor? cached = _cache[cacheKey];
    if (cached != null) return cached;

    try {
      final ByteData raw = await rootBundle.load(assetPath);
      final ui.Codec codec =
          await ui.instantiateImageCodec(raw.buffer.asUint8List());
      final ui.FrameInfo frame = await codec.getNextFrame();
      final ui.Image source = frame.image;

      final ByteData? rgba =
          await source.toByteData(format: ui.ImageByteFormat.rawRgba);
      source.dispose();
      if (rgba == null) return BitmapDescriptor.defaultMarker;

      final Uint8List pixels = rgba.buffer.asUint8List();
      final int width = source.width;
      final int height = source.height;

      // Only key out the background on artwork that is fully opaque. A
      // properly authored PNG already carries its own alpha, and running the
      // key over it would punch holes in any legitimately light, unsaturated
      // part of that icon — so if this asset is ever replaced with a real
      // transparent PNG, this step correctly does nothing.
      if (_isFullyOpaque(pixels)) {
        _keyOutBackground(pixels);
      }

      final _Bounds bounds = _opaqueBounds(pixels, width, height);
      if (bounds.isEmpty) {
        // Everything was keyed away — the asset isn't what we assumed.
        // Better a stock pin than an invisible one.
        debugPrint(
          '[PickupMarkerIcon] "$assetPath" had no opaque pixels after '
          'background removal — falling back to the default marker.',
        );
        return BitmapDescriptor.defaultMarker;
      }

      // Cropping to the pin's own bounds is what makes the anchor honest:
      // the caller anchors at bottom-centre so the tip sits on the
      // coordinate, and that is only true once the asset's dead padding
      // (here, ~10% of the canvas) is gone.
      final Uint8List cropped = _crop(pixels, width, bounds);

      final Uint8List? png = await _encodePng(
        cropped,
        bounds.width,
        bounds.height,
      );
      if (png == null) return BitmapDescriptor.defaultMarker;

      final Uint8List scaled = await _resizePng(png, targetWidth) ?? png;

      final BitmapDescriptor descriptor = BitmapDescriptor.bytes(scaled);
      _cache[cacheKey] = descriptor;
      return descriptor;
    } catch (e) {
      debugPrint('[PickupMarkerIcon] load failed for "$assetPath": $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  static bool _isFullyOpaque(Uint8List pixels) {
    for (int i = 3; i < pixels.length; i += 4) {
      if (pixels[i] != 255) return false;
    }
    return true;
  }

  static void _keyOutBackground(Uint8List pixels) {
    for (int i = 0; i < pixels.length; i += 4) {
      final int r = pixels[i];
      final int g = pixels[i + 1];
      final int b = pixels[i + 2];

      final int max = r > g ? (r > b ? r : b) : (g > b ? g : b);
      final int min = r < g ? (r < b ? r : b) : (g < b ? g : b);

      if (max - min <= _maxBackgroundChroma && max >= _minBackgroundLuminance) {
        pixels[i + 3] = 0;
      }
    }
  }

  static _Bounds _opaqueBounds(Uint8List pixels, int width, int height) {
    int left = width, top = height, right = -1, bottom = -1;

    for (int y = 0; y < height; y++) {
      final int rowStart = y * width * 4;
      for (int x = 0; x < width; x++) {
        if (pixels[rowStart + x * 4 + 3] == 0) continue;
        if (x < left) left = x;
        if (x > right) right = x;
        if (y < top) top = y;
        if (y > bottom) bottom = y;
      }
    }

    if (right < left || bottom < top) return const _Bounds.empty();
    return _Bounds(left, top, right, bottom);
  }

  static Uint8List _crop(Uint8List pixels, int sourceWidth, _Bounds bounds) {
    final Uint8List out = Uint8List(bounds.width * bounds.height * 4);
    int cursor = 0;
    for (int y = bounds.top; y <= bounds.bottom; y++) {
      final int rowStart = (y * sourceWidth + bounds.left) * 4;
      out.setRange(
        cursor,
        cursor + bounds.width * 4,
        pixels.sublist(rowStart, rowStart + bounds.width * 4),
      );
      cursor += bounds.width * 4;
    }
    return out;
  }

  static Future<Uint8List?> _encodePng(
    Uint8List rgba,
    int width,
    int height,
  ) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      rgba,
      width,
      height,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    final ui.Image image = await completer.future;
    final ByteData? png = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return png?.buffer.asUint8List();
  }

  static Future<Uint8List?> _resizePng(Uint8List png, int targetWidth) async {
    final ui.Codec codec = await ui.instantiateImageCodec(
      png,
      targetWidth: targetWidth,
    );
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ByteData? out =
        await frame.image.toByteData(format: ui.ImageByteFormat.png);
    frame.image.dispose();
    return out?.buffer.asUint8List();
  }
}

class _Bounds {
  const _Bounds(this.left, this.top, this.right, this.bottom);
  const _Bounds.empty() : left = 0, top = 0, right = -1, bottom = -1;

  final int left;
  final int top;
  final int right;
  final int bottom;

  bool get isEmpty => right < left || bottom < top;
  int get width => right - left + 1;
  int get height => bottom - top + 1;
}
