import 'package:flutter/material.dart';

class WeatherForecast extends StatelessWidget {
  const WeatherForecast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DailyForecast> dailyData = [
      DailyForecast(
        day: 'Today',
        maxTemp: 27,
        minTemp: 20,
        icon: Icons.wb_sunny,
        precipitation: 10,
      ),
      DailyForecast(
        day: 'Tomorrow',
        maxTemp: 25,
        minTemp: 18,
        icon: Icons.wb_cloudy,
        precipitation: 30,
      ),
      DailyForecast(
        day: 'Wednesday',
        maxTemp: 23,
        minTemp: 17,
        icon: Icons.cloud,
        precipitation: 60,
      ),
      DailyForecast(
        day: 'Thursday',
        maxTemp: 22,
        minTemp: 16,
        icon: Icons.water_drop,
        precipitation: 80,
      ),
      DailyForecast(
        day: 'Friday',
        maxTemp: 24,
        minTemp: 18,
        icon: Icons.wb_cloudy,
        precipitation: 40,
      ),
    ];

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '5-Day Forecast',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const Divider(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyData.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final forecast = dailyData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        forecast.day,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Icon(
                      forecast.icon,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${forecast.precipitation}%',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${forecast.minTemp}°',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7),
                                  ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${forecast.maxTemp}°',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DailyForecast {
  final String day;
  final int maxTemp;
  final int minTemp;
  final IconData icon;
  final int precipitation;

  const DailyForecast({
    required this.day,
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
    required this.precipitation,
  });
}
