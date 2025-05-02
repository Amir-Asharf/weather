import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String temperature;
  final String condition;
  final String location;
  final IconData weatherIcon;
  final VoidCallback onTap;
  final String feelsLike;
  final String maxTemp;
  final String minTemp;
  final String humidity;
  final String windSpeed;

  const WeatherCard({
    Key? key,
    required this.temperature,
    required this.condition,
    required this.location,
    required this.weatherIcon,
    required this.onTap,
    required this.feelsLike,
    required this.maxTemp,
    required this.minTemp,
    required this.humidity,
    required this.windSpeed,
  }) : super(key: key);

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'weather_card',
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          temperature,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          condition,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Icon(
                      weatherIcon,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailItem(
                        Icons.thermostat_outlined,
                        'Feels like',
                        feelsLike,
                      ),
                      _buildDetailItem(
                        Icons.arrow_upward,
                        'Max Temp',
                        maxTemp,
                      ),
                      _buildDetailItem(
                        Icons.arrow_downward,
                        'Min Temp',
                        minTemp,
                      ),
                      _buildDetailItem(
                        Icons.water_drop_outlined,
                        'Humidity',
                        humidity,
                      ),
                      _buildDetailItem(
                        Icons.air,
                        'Wind',
                        windSpeed,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
