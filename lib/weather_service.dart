import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = 'ed60fcfbd110ee65c7150605ea8aceea';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      // Get current weather
      final currentWeatherResponse = await http.get(
        Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric'),
      );

      if (currentWeatherResponse.statusCode == 404) {
        throw Exception('المدينة غير موجودة. برجاء التأكد من اسم المدينة');
      } else if (currentWeatherResponse.statusCode == 401) {
        throw Exception('خطأ في مفتاح API. برجاء التواصل مع الدعم الفني');
      } else if (currentWeatherResponse.statusCode != 200) {
        throw Exception(
            'حدث خطأ في جلب بيانات الطقس: ${currentWeatherResponse.statusCode}');
      }

      // Get forecast data
      final forecastResponse = await http.get(
        Uri.parse('$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric'),
      );

      if (forecastResponse.statusCode != 200) {
        throw Exception(
            'حدث خطأ في جلب بيانات التوقعات: ${forecastResponse.statusCode}');
      }

      final currentWeatherData = json.decode(currentWeatherResponse.body);
      final forecastData = json.decode(forecastResponse.body);

      return WeatherModel.fromJson(currentWeatherData, forecastData);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  static Future<WeatherModel> getWeatherByLocation(
      double latitude, double longitude) async {
    try {
      // Get current weather
      final currentWeatherResponse = await http.get(
        Uri.parse(
            '$_baseUrl/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (currentWeatherResponse.statusCode == 401) {
        throw Exception('خطأ في مفتاح API. برجاء التواصل مع الدعم الفني');
      } else if (currentWeatherResponse.statusCode != 200) {
        throw Exception(
            'حدث خطأ في جلب بيانات الطقس: ${currentWeatherResponse.statusCode}');
      }

      // Get forecast data
      final forecastResponse = await http.get(
        Uri.parse(
            '$_baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric'),
      );

      if (forecastResponse.statusCode != 200) {
        throw Exception(
            'حدث خطأ في جلب بيانات التوقعات: ${forecastResponse.statusCode}');
      }

      final currentWeatherData = json.decode(currentWeatherResponse.body);
      final forecastData = json.decode(forecastResponse.body);

      return WeatherModel.fromJson(currentWeatherData, forecastData);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }
}
