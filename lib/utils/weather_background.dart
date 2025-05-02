import 'package:flutter/material.dart';

class WeatherBackground {
  static bool isNightTime() {
    final now = DateTime.now();
    final hour = now.hour;
    // Consider night time between 7 PM (19) and 5 AM
    return hour >= 19 || hour < 5;
  }

  static String getBackgroundImage() {
    return isNightTime()
        ? 'assets/images/_Q9Hv6YhH.gif'
        : 'assets/images/_Q9Hv6YhH.gif';
  }

  static Color getGradientOverlayColor() {
    return isNightTime()
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.3);
  }

  static LinearGradient getBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        isNightTime()
            ? Colors.black.withOpacity(0.7)
            : Colors.black.withOpacity(0.5),
      ],
    );
  }

  static Color getTextColor(BuildContext context) {
    return isNightTime()
        ? Colors.white
        : Theme.of(context).colorScheme.onPrimary;
  }

  static IconThemeData getIconTheme(BuildContext context) {
    return IconThemeData(
      color:
          isNightTime() ? Colors.white : Theme.of(context).colorScheme.primary,
    );
  }
}
