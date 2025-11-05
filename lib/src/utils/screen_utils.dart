import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

/// ## Problem: Devices Have Different Screen Sizes
///
/// - Phones, tablets, and desktops all have different dimensions and pixel densities.
/// - Hardcoding values such as `fontSize: 16`, `offset: Offset(20, 10)`, or `alignment: Alignment(1, -1)`
///   can result in inconsistent appearance and behavior across devices.
///
/// ### Example
/// - `fontSize: 16` may look appropriate on a phone, but appear too small on a tablet.
/// - `offset(30, 0)` might move a widget too far on small screens and not enough on large screens.
///
/// ---
///
/// ## Goal: Normalize UI Behavior Across Devices
///
/// The objective is to create a system where UI elements feel proportional regardless of screen size:
/// - Fonts scale naturally
/// - Icons remain readable
/// - Transforms and alignment are consistent
/// - Spacing is balanced
///
/// ---
///
/// ## How ScreenUtils Solves This
///
/// 1. Detects the screen size to enable responsive scaling and layout adjustments.
/// 	•	This gets the screen size (in logical pixels) without needing a BuildContext.
/// 	•	We normalize it so that width is always the shorter side (portrait logic).
/// 2. Create a “Scale Factor” Based on a Design Baseline
/// 	•	You design in Figma or Sketch for a standard device (e.g. 360×640).
///	  •	baseWidth tells you how much wider the screen is compared to your design.
///	  •	baseHeight does the same for height.
///	  •	The average gives you a general scale factor.
/// 3. Detect Tablets
/// 	•	If the device is more than 1.2x bigger than normal, or if the short side is ≥ 600, it’s a tablet.
/// 	•	This helps tweak font/icon scaling and layout.
/// 4. Calculate the Final Scalling Factor
/// 	•	This is the multiplier you use to scale values.
/// 	•	It’s slightly reduced for tablets (0.4) to avoid huge elements, and standard on phones (0.5).

class ScreenUtils {
  static final ScreenUtils instance = ScreenUtils._internal();

  late final double width;
  late final double height;
  late final double baseSize;
  late final double scaleFactor;
  late final bool isTablet;

  static const double _guidelineBaseWidth = 360.0;
  static const double _guidelineBaseHeight = 640.0;

  ScreenUtils._internal() {
    final size = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    ).size;

    width = min(size.width, size.height);
    height = max(size.width, size.height);

    final baseWidth = width / _guidelineBaseWidth;
    final baseHeight = height / _guidelineBaseHeight;
    final averageBase = (baseWidth + baseHeight) / 2;

    isTablet = _detectTablet(averageBase, width);
    baseSize = (baseWidth + baseHeight) * (isTablet ? 0.4 : 0.5);
    scaleFactor = baseSize;
  }

  // General scalar
  double scale(double size) => (size * scaleFactor).ceilToDouble();

  // Fonts
  double font(double size) => scale(size * _fontMultiplier());
  double _fontMultiplier() => isTablet ? 0.9 : 1.0;

  // Icons
  double icon(double size) => scale(size * _iconMultiplier());
  double _iconMultiplier() => isTablet ? 1.1 : 1.0;

  // Offsets (e.g. for animated positions)
  Offset offset(double dx, double dy) => Offset(scale(dx), scale(dy));

  // Alignment regulation (makes 0.0 - 1.0 adjustable for larger screens)
  Alignment alignment(double x, double y) {
    // e.g. shrink center bias a bit on tablets
    final factor = isTablet ? 0.85 : 1.0;
    return Alignment(x * factor, y * factor);
  }

  // Scaled padding/insets
  EdgeInsets padding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.fromLTRB(scale(left), scale(top), scale(right), scale(bottom));

  bool get isAndroid => Platform.isAndroid;
  bool get isIos => Platform.isIOS;
  bool get isWeb => kIsWeb;
  bool get isTV => false;
  bool get isPad => isIos && isTablet;

  bool _detectTablet(double base, double width) {
    return base > 1.2 || width >= 600;
  }
}

// Shorthand helpers
double scale(double size) => ScreenUtils.instance.scale(size);
double fontSize(double size) => ScreenUtils.instance.font(size);
double iconSize(double size) => ScreenUtils.instance.icon(size);
Offset offset(double x, double y) => ScreenUtils.instance.offset(x, y);
Alignment align(double x, double y) => ScreenUtils.instance.alignment(x, y);
EdgeInsets padding({
  double left = 0,
  double top = 0,
  double right = 0,
  double bottom = 0,
}) =>
    ScreenUtils.instance.padding(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
bool get isTablet => ScreenUtils.instance.isTablet;
