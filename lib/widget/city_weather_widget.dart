import 'package:flutter/material.dart';
import 'package:app_1/data/city_weather.dart';

class WeatherDisplayWidget extends StatefulWidget {
  final double latitude;
  final double longitude;

  const WeatherDisplayWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _WeatherDisplayWidgetState createState() => _WeatherDisplayWidgetState();
}

class _WeatherDisplayWidgetState extends State<WeatherDisplayWidget> {
  late WeatherData _weatherData;
  late bool _isLoading;
  late String _errorMessage;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _errorMessage = '';
    _fetchWeatherData();
  }

  @override
  void didUpdateWidget(covariant WeatherDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _fetchWeatherData();
    }
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherApiClient = WeatherApiClient();
      final data = await weatherApiClient.getWeatherForecast(
        widget.latitude,
        widget.longitude,
      );
      setState(() {
        _weatherData = data;
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load weather data: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0), // добавляем отступы для виджета
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isLoading) CircularProgressIndicator(),
          if (_errorMessage.isNotEmpty) Text(_errorMessage),
          if (!_isLoading && _errorMessage.isEmpty)
            Text(
              'Temperature: ${_weatherData.temperatureList.first}°C',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
