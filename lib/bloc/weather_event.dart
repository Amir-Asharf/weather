import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class GetWeatherByCity extends WeatherEvent {
  final String city;

  const GetWeatherByCity(this.city);

  @override
  List<Object?> get props => [city];
}

class GetWeatherByLocation extends WeatherEvent {
  final double latitude;
  final double longitude;

  const GetWeatherByLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
