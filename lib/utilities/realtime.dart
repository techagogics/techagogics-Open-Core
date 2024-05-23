import 'dart:convert';
import 'dart:math';
import 'dart:ui';

/// Handy extension method to create random colors
extension RandomColor on Color {
  static Color getRandom() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  /// Quick and dirty method to create a random color from the userID
  static Color getRandomFromId(String id) {
    final seed = utf8.encode(id).reduce((value, element) => value + element);
    return Color((Random(seed).nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }
}