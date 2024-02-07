import 'package:dio/dio.dart';

class WeatherApiClient {
  final Dio _dio = Dio();

  Future<WeatherData> getWeatherForecast(
      double latitude, double longitude) async {
    try {
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'hourly': 'temperature_2m,wind_speed_10m',
        },
      );
      return WeatherData(response.data);
    } catch (error) {
      throw Exception('Failed to load weather forecast: $error');
    }
  }
}

class WeatherData {
  final Map<String, dynamic> _data;
  WeatherData(this._data);
  double get latitude => _data['latitude'];
  double get longitude => _data['longitude'];
  double get generationTime => _data['generationtime_ms'];
  Map<String, dynamic> get hourlyUnits => _data['hourly_units'];
  List<String> get timelist => (_data['hourly']['time'] as List).cast<String>();
  List<double> get temperatureList =>
      (_data['hourly']['temperature_2m'] as List).cast<double>();
  List<double> get windSpeedList => _data['hourly']['wind_speed_10m'];
}
