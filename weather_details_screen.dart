import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/widgets/weather_chart.dart';
import 'package:weather_app/widgets/weather_info_card.dart';
import 'package:weather_app/widgets/weather_forecast.dart';
import 'package:weather_app/widgets/weather_map.dart';
import 'package:weather_app/utils/weather_background.dart';

class WeatherDetailsScreen extends StatefulWidget {
  final String cityName;
  final String temperature;
  final String condition;

  const WeatherDetailsScreen({
    Key? key,
    required this.cityName,
    required this.temperature,
    required this.condition,
  }) : super(key: key);

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    // Update the screen every minute to check for day/night changes
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNight = WeatherBackground.isNightTime();

    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: WeatherBackground.getIconTheme(context),
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.cityName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: WeatherBackground.getTextColor(context),
                      ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      WeatherBackground.getBackgroundImage(),
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: WeatherBackground.getBackgroundGradient(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'weather_card',
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.temperature,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                      ),
                                      Text(
                                        widget.condition,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    isNight
                                        ? Icons.nightlight_round
                                        : Icons.wb_sunny,
                                    size: 64,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Hourly Forecast',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      height: 200,
                      child: WeatherChart(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Weather Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: const [
                        WeatherInfoCard(
                          title: 'Humidity',
                          value: '75%',
                          icon: Icons.water_drop,
                        ),
                        WeatherInfoCard(
                          title: 'Wind Speed',
                          value: '5.3 km/h',
                          icon: Icons.air,
                        ),
                        WeatherInfoCard(
                          title: 'Pressure',
                          value: '1012 hPa',
                          icon: Icons.speed,
                        ),
                        WeatherInfoCard(
                          title: 'UV Index',
                          value: '3',
                          icon: Icons.wb_sunny,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const WeatherForecast(),
                    const SizedBox(height: 24),
                    const WeatherMap(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
