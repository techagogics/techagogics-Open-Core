import 'package:flutter/material.dart';

class MediaQueryUtil {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static int getCrossAxisCount(BuildContext context) {
    // Ermitteln der Bildschirmbreite
    double screenWidth = MediaQuery.of(context).size.width;
    // Anpassen der Anzahl der Spalten basierend auf der Bildschirmbreite
    return screenWidth > 600 ? 2 : 1;
  }

  static bool isSmartphoneView(BuildContext context) {
    // Ermitteln der Bildschirmbreite
    double screenWidth = MediaQuery.of(context).size.width;
    // Anpassen der Anzahl der Spalten basierend auf der Bildschirmbreite
    return screenWidth > 600 ? true : false;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }
}
