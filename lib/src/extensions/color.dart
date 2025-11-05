import 'package:flutter/material.dart';

extension ColorExtention on Color {
  Color withShade(double factor) => ColorMisc.withShade(this, factor);

  Color withTint(double factor) => ColorMisc.withTint(this, factor);

  Color get contrastText => ColorMisc.contrastText(this);

  static Color fromHex(String hexString) => ColorMisc.fromHex(hexString);

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${a.round().toRadixString(16).padLeft(2, '0')}'
      '${r.round().toRadixString(16).padLeft(2, '0')}'
      '${g.round().toRadixString(16).padLeft(2, '0')}'
      '${b.round().toRadixString(16).padLeft(2, '0')}';

  Color withOpacity(double opacity) => withAlpha((255.0 * opacity).round());
}

class ColorMisc {
  ///This class Applies values to colors and return either a darker shade or lighter tone of the same color

  ///shade_factor < 1.0
  static Color withShade(Color color, num shadeFactor) {
    var r = ((color.r * 255)) * (1 - shadeFactor);
    var g = ((color.g * 255)) * (1 - shadeFactor);
    var b = ((color.b * 255)) * (1 - shadeFactor);
    return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), color.a);
  }

  ///tint_factor < 1.0
  static Color withTint(Color color, num tintFactor) {
    var r = ((color.r * 255) + (255 - (color.r * 255)) * tintFactor);
    var g = ((color.g * 255) + (255 - (color.g * 255)) * tintFactor);
    var b = ((color.b * 255) + (255 - (color.b * 255)) * tintFactor);
    return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), color.a);
  }

  static Color contrastText(Color bgColor) {
    return bgColor.computeLuminance() > 0.4 ? Colors.black : Colors.white;
  }

  static Color nameToColor(String name) {
    if (name.length <= 1) name += "aa";
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    if (hexString.length < 6) return Colors.white;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String toHex(Color color, {bool leadingHashSign = true}) {
    // ignore: deprecated_member_use
    final hex = color.value.toRadixString(16).padLeft(8, '0');
    return (leadingHashSign ? '#' : '') + hex.substring(2);
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
}
