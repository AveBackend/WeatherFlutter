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
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isLoading) CircularProgressIndicator(),
          if (_errorMessage.isNotEmpty) Text(_errorMessage),
          if (!_isLoading && _errorMessage.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temperature for the next 24 hours:',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_weatherData.temperatureList.length,
                      (index) {
                    final hour = DateTime.now().add(Duration(
                        hours: index + 1)); // Добавляем час к текущему времени
                    final temperature = _weatherData.temperatureList[index];
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        '${hour.hour.toString().padLeft(2, '0')}:00 - ${temperature.toString()}°C',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  }),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
