import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String icon;
  final List<WeatherForecast> forecast;
  final List<WeatherForecast> hourlyForecast;
  final double maxTemp;
  final double minTemp;

  const WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.forecast,
    required this.hourlyForecast,
    required this.maxTemp,
    required this.minTemp,
  });

  factory WeatherModel.fromJson(
      Map<String, dynamic> currentWeather, Map<String, dynamic> forecastData) {
    // Extract current weather data
    final weather = currentWeather['weather'][0];
    final main = currentWeather['main'];

    // Process hourly forecast data
    final List<WeatherForecast> hourlyForecastList = [];
    double maxTemp = double.negativeInfinity;
    double minTemp = double.infinity;

    if (forecastData.containsKey('list')) {
      final List<dynamic> list = forecastData['list'];
      final now = DateTime.now();
      final next24Hours = now.add(const Duration(hours: 24));

      // Get forecasts for each hour and calculate max/min temperatures
      for (var item in list) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        if (date.isAfter(now) && date.isBefore(next24Hours)) {
          final temp = (item['main']['temp'] as num).toDouble();
          maxTemp = temp > maxTemp ? temp : maxTemp;
          minTemp = temp < minTemp ? temp : minTemp;
          hourlyForecastList.add(WeatherForecast.fromJson(item));
        }
      }

      // Sort by hour to ensure sequential display
      hourlyForecastList.sort((a, b) => a.date.compareTo(b.date));
    }

    // Process daily forecast data
    final List<WeatherForecast> forecastList = [];
    if (forecastData.containsKey('list')) {
      final List<dynamic> list = forecastData['list'];
      final Map<String, WeatherForecast> dailyForecasts = {};

      for (var item in list) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final String dayKey = '${date.year}-${date.month}-${date.day}';

        // Only take the forecast for 12:00 (noon) for each day
        if (date.hour == 12 && !dailyForecasts.containsKey(dayKey)) {
          dailyForecasts[dayKey] = WeatherForecast.fromJson(item);
        }
      }

      forecastList.addAll(dailyForecasts.values);
      // Sort forecasts by date
      forecastList.sort((a, b) => a.date.compareTo(b.date));
      // Take only the next 5 days
      if (forecastList.length > 5) {
        forecastList.removeRange(5, forecastList.length);
      }
    }

    return WeatherModel(
      cityName: currentWeather['name'],
      temperature: (main['temp'] as num).toDouble(),
      description: weather['description'],
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'],
      windSpeed: (currentWeather['wind']['speed'] as num).toDouble(),
      icon: weather['icon'],
      forecast: forecastList,
      hourlyForecast: hourlyForecastList,
      maxTemp: maxTemp,
      minTemp: minTemp,
    );
  }

  @override
  List<Object?> get props => [
        cityName,
        temperature,
        description,
        feelsLike,
        humidity,
        windSpeed,
        icon,
        forecast,
        hourlyForecast,
        maxTemp,
        minTemp,
      ];
}

class WeatherForecast extends Equatable {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  const WeatherForecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }

  @override
  List<Object?> get props => [date, temperature, description, icon];
}
