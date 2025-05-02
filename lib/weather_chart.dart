import 'package:flutter/material.dart';

class WeatherChart extends StatelessWidget {
  const WeatherChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for the chart
    final List<HourlyForecast> hourlyData = [
      HourlyForecast(hour: '12 PM', temp: 25, icon: Icons.wb_sunny),
      HourlyForecast(hour: '1 PM', temp: 26, icon: Icons.wb_sunny),
      HourlyForecast(hour: '2 PM', temp: 27, icon: Icons.wb_cloudy),
      HourlyForecast(hour: '3 PM', temp: 26, icon: Icons.wb_cloudy),
      HourlyForecast(hour: '4 PM', temp: 25, icon: Icons.cloud),
      HourlyForecast(hour: '5 PM', temp: 24, icon: Icons.cloud),
      HourlyForecast(hour: '6 PM', temp: 23, icon: Icons.wb_twilight),
    ];

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyData.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemBuilder: (context, index) {
          final forecast = hourlyData[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  forecast.hour,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Icon(
                  forecast.icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  '${forecast.temp}°',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                _buildTemperatureBar(context, forecast.temp),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTemperatureBar(BuildContext context, int temperature) {
    return Container(
      width: 4,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            Theme.of(context).colorScheme.primary,
          ],
          stops: [0, temperature / 35],
        ),
      ),
    );
  }
}

class HourlyForecast {
  final String hour;
  final int temp;
  final IconData icon;

  const HourlyForecast({
    required this.hour,
    required this.temp,
    required this.icon,
  });
}
