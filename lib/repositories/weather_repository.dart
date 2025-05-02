import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  final String apiKey = 'ed60fcfbd110ee65c7150605ea8aceea';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherModel> getWeatherByCity(String city) async {
    return WeatherService.getWeatherByCity(city);
  }

  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    return WeatherService.getWeatherByLocation(lat, lon);
  }
}
