import 'package:intl/intl.dart';

class WeatherUtils {
  static String getWeatherIcon(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  static String formatTemperature(double temp) {
    return '${temp.round()}°C';
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDay(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getWeatherBackground(String iconCode) {
    // First digit of icon code represents weather condition
    // Second digit represents day (d) or night (n)
    String condition = iconCode[0];
    String timeOfDay = iconCode[2];
    bool isNight = timeOfDay == 'n';

    // Night time background
    if (isNight) {
      return 'assets/images/night.jpg';
    }

    // Day time backgrounds based on weather condition
    switch (condition) {
      case '01': // clear sky
      case '02': // few clouds
      case '03': // scattered clouds
        return 'assets/images/_Q9Hv6YhH.gif';
      case '04': // broken clouds
      case '09': // shower rain
      case '10': // rain
      case '11': // thunderstorm
        return 'assets/images/_Q9Hv6YhH.gif';
      case '13': // snow
      case '50': // mist
      default:
        return 'assets/images/_Q9Hv6YhH.gif';
    }
  }

  static String getWeatherDescription(String description) {
    // Capitalize first letter of each word
    return description.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
