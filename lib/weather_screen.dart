import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../models/weather_model.dart';
import '../services/location_service.dart';
import '../utils/weather_utils.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _cloudController;
  String? _lastCity; // Store last searched city
  double? _lastLat; // Store last latitude
  double? _lastLon; // Store last longitude

  @override
  void initState() {
    super.initState();
    _setupCloudAnimation();
    _getCurrentLocation();
  }

  void _setupCloudAnimation() {
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  // Add refresh method
  void _refreshWeather() {
    if (_lastCity != null) {
      context.read<WeatherBloc>().add(GetWeatherByCity(_lastCity!));
    } else if (_lastLat != null && _lastLon != null) {
      context.read<WeatherBloc>().add(
            GetWeatherByLocation(
              latitude: _lastLat!,
              longitude: _lastLon!,
            ),
          );
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      if (position != null && mounted) {
        _lastLat = position.latitude;
        _lastLon = position.longitude;
        _lastCity = null;
        context.read<WeatherBloc>().add(
              GetWeatherByLocation(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const SizedBox.shrink(),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          // Determine if it's day or night based on current time
          final currentHour = DateTime.now().hour;
          final isNight = currentHour < 6 || currentHour >= 18;

          // Default background based on time of day
          String backgroundImage = isNight
              ? 'assets/images/night.jpg'
              : 'assets/images/_Q9Hv6YhH.gif';

          // Update background based on weather state if available
          if (state is WeatherLoaded) {
            final weatherIcon = state.weather.icon;
            // Only update background if the weather icon matches the current time of day
            if ((isNight && weatherIcon.endsWith('n')) ||
                (!isNight && weatherIcon.endsWith('d'))) {
              backgroundImage = WeatherUtils.getWeatherBackground(weatherIcon);
            }
          }

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(isNight ? 0.2 : 0.3),
                    Colors.black.withOpacity(isNight ? 0.4 : 0.5),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Animated clouds in the background
                  const AnimatedClouds(numberOfClouds: 6),

                  // Main content
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: _getCurrentLocation,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildSearchBar(),
                                ),
                                const SizedBox(width: 8),
                                if (state is WeatherLoaded) ...[
                                  IconButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface
                                                .withOpacity(0.9),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(20)),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 4,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.info_outline,
                                                    color: Colors.blue),
                                                title: Text(
                                                  'Weather Details',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _showWeatherDetails(
                                                      context, state.weather);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.share,
                                                    color: Colors.green),
                                                title: Text(
                                                  'Share',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _shareWeather(state.weather);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.warning_amber_rounded,
                                                    color: Colors.orange),
                                                title: Text(
                                                  'Alerts',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _showWeatherAlerts(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.air,
                                                    color: Colors.purple),
                                                title: Text(
                                                  'Air Quality',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _showAirQuality(context);
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                IconButton(
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: _refreshWeather,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (state is WeatherLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            else if (state is WeatherLoaded)
                              _buildWeatherInfo(state.weather)
                            else if (state is WeatherError)
                              Center(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            else
                              const Center(
                                child: Text(
                                  'Enter a city name or use location',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: _cityController,
        focusNode: _focusNode,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter city name',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            _lastCity = value;
            _lastLat = null;
            _lastLon = null;
            context.read<WeatherBloc>().add(GetWeatherByCity(value));
            _cityController.clear();
            _focusNode.unfocus();
          }
        },
      ),
    );
  }

  Widget _buildWeatherInfo(WeatherModel weather) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          WeatherUtils.formatDate(DateTime.now()),
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 20),
        Image.network(
          WeatherUtils.getWeatherIcon(weather.icon),
          width: 100,
          height: 100,
          color: Colors.white,
        ),
        const SizedBox(height: 20),
        Text(
          WeatherUtils.formatTemperature(weather.temperature),
          style: GoogleFonts.poppins(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          WeatherUtils.getWeatherDescription(weather.description),
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        _buildWeatherDetails(weather),
        const SizedBox(height: 30),
        // Add hourly forecast section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hourly Forecast',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    DateTime.now().hour >= 6 && DateTime.now().hour < 18
                        ? Icons.wb_sunny
                        : Icons.nightlight_round,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weather.hourlyForecast.length,
                  itemBuilder: (context, index) {
                    final hour = weather.hourlyForecast[index];
                    final isDay = hour.date.hour >= 6 && hour.date.hour < 18;
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                WeatherUtils.formatTime(hour.date),
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                isDay ? Icons.wb_sunny : Icons.nightlight_round,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Image.network(
                            WeatherUtils.getWeatherIcon(hour.icon),
                            width: 60,
                            height: 60,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            WeatherUtils.formatTemperature(hour.temperature),
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            WeatherUtils.getWeatherDescription(
                                hour.description),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          height: 320,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Row(
                  children: [
                    Text(
                      'Daily Forecast',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      DateTime.now().hour >= 6 && DateTime.now().hour < 18
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                      color: Colors.white,
                      size: 28,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weather.forecast.length,
                  itemBuilder: (context, index) {
                    final day = weather.forecast[index];
                    final isDay = day.date.hour >= 6 && day.date.hour < 18;
                    return Container(
                      width: 190,
                      margin: EdgeInsets.only(
                        right: index == weather.forecast.length - 1 ? 16 : 16,
                        left: index == 0 ? 16 : 0,
                      ),
                      padding: const EdgeInsets.all(19),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                WeatherUtils.formatDay(day.date),
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isDay ? Icons.wb_sunny : Icons.nightlight_round,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Image.network(
                            WeatherUtils.getWeatherIcon(day.icon),
                            width: 70,
                            height: 70,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            WeatherUtils.formatTemperature(day.temperature),
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            WeatherUtils.getWeatherDescription(day.description),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetails(WeatherModel weather) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildDetailItem(
            Icons.thermostat_outlined,
            'Feels like',
            WeatherUtils.formatTemperature(weather.feelsLike),
          ),
          const SizedBox(width: 24),
          _buildDetailItem(
            Icons.arrow_upward,
            'Max Temp',
            WeatherUtils.formatTemperature(weather.maxTemp),
          ),
          const SizedBox(width: 24),
          _buildDetailItem(
            Icons.arrow_downward,
            'Min Temp',
            WeatherUtils.formatTemperature(weather.minTemp),
          ),
          const SizedBox(width: 24),
          _buildDetailItem(
            Icons.water_drop_outlined,
            'Humidity',
            '${weather.humidity}%',
          ),
          const SizedBox(width: 24),
          _buildDetailItem(
            Icons.air,
            'Wind',
            '${weather.windSpeed} m/s',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showWeatherDetails(BuildContext context, WeatherModel weather) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Weather Details',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Temperature', '${weather.temperature}°C'),
              _buildDetailRow('Feels Like', '${weather.feelsLike}°C'),
              _buildDetailRow('Humidity', '${weather.humidity}%'),
              _buildDetailRow('Wind Speed', '${weather.windSpeed} m/s'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _shareWeather(WeatherModel weather) async {
    try {
      final String shareText = '''
Weather in ${weather.cityName}:
${WeatherUtils.getWeatherDescription(weather.description)}
Temperature: ${WeatherUtils.formatTemperature(weather.temperature)}
Feels Like: ${WeatherUtils.formatTemperature(weather.feelsLike)}
Humidity: ${weather.humidity}%
Wind Speed: ${weather.windSpeed} m/s

Shared from Weather App
''';

      if (!mounted) return;

      await Share.share(
        shareText,
        subject: 'Weather in ${weather.cityName}',
      ).then((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Weather information shared successfully'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing weather: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showWeatherAlerts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Weather Alerts',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'No weather alerts at this time',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAirQuality(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Air Quality',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.eco,
              color: Colors.green,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Good Air Quality',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Air Quality Index: 45',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _cityController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class CloudPainter extends CustomPainter {
  final double opacity;
  final double scale;

  CloudPainter({
    this.opacity = 1.0,
    this.scale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width * scale;
    final height = size.height * scale;

    // Center the cloud when scaled
    canvas.translate((size.width - width) / 2, (size.height - height) / 2);

    // Draw cloud shape
    path.moveTo(width * 0.2, height * 0.5);
    path.quadraticBezierTo(
        width * 0.1, height * 0.3, width * 0.3, height * 0.3);
    path.quadraticBezierTo(
        width * 0.3, height * 0.1, width * 0.5, height * 0.1);
    path.quadraticBezierTo(
        width * 0.5, height * 0.2, width * 0.7, height * 0.2);
    path.quadraticBezierTo(
        width * 0.9, height * 0.2, width * 0.9, height * 0.4);
    path.quadraticBezierTo(
        width * 1.1, height * 0.4, width * 0.9, height * 0.6);
    path.quadraticBezierTo(
        width * 0.9, height * 0.8, width * 0.7, height * 0.8);
    path.quadraticBezierTo(
        width * 0.7, height * 0.9, width * 0.5, height * 0.9);
    path.quadraticBezierTo(
        width * 0.3, height * 0.9, width * 0.3, height * 0.7);
    path.quadraticBezierTo(
        width * 0.1, height * 0.7, width * 0.2, height * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CloudPainter oldDelegate) =>
      opacity != oldDelegate.opacity || scale != oldDelegate.scale;
}

class AnimatedClouds extends StatefulWidget {
  final int numberOfClouds;

  const AnimatedClouds({
    Key? key,
    this.numberOfClouds = 6,
  }) : super(key: key);

  @override
  State<AnimatedClouds> createState() => _AnimatedCloudsState();
}

class _AnimatedCloudsState extends State<AnimatedClouds>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _positions;
  late List<Animation<double>> _scales;
  late List<Animation<double>> _opacities;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.numberOfClouds,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(
          seconds: 20 + (index * 5), // Different speeds for each cloud
        ),
      )..repeat(),
    );

    _positions = List.generate(
      widget.numberOfClouds,
      (index) => Tween<double>(
        begin: -0.2,
        end: 1.2, // Move beyond screen for smooth loop
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.linear,
        ),
      ),
    );

    _scales = List.generate(
      widget.numberOfClouds,
      (index) => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 0.8 + (index % 3) * 0.2,
            end: 1.0 + (index % 3) * 0.2,
          ),
          weight: 50.0,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0 + (index % 3) * 0.2,
            end: 0.8 + (index % 3) * 0.2,
          ),
          weight: 50.0,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeInOut,
        ),
      ),
    );

    _opacities = List.generate(
      widget.numberOfClouds,
      (index) => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.7, end: 1.0),
          weight: 50.0,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.7),
          weight: 50.0,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: List.generate(widget.numberOfClouds, (index) {
            return AnimatedBuilder(
              animation: _controllers[index],
              builder: (context, child) {
                return Positioned(
                  left: constraints.maxWidth * _positions[index].value,
                  top: 50.0 + (index * 40), // Distribute clouds vertically
                  child: Transform.scale(
                    scale: _scales[index].value,
                    child: Opacity(
                      opacity: _opacities[index].value,
                      child: SizedBox(
                        width: 120,
                        height: 72,
                        child: CustomPaint(
                          painter: CloudPainter(
                            opacity: _opacities[index].value,
                            scale: _scales[index].value,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}
