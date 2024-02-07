import 'package:flutter_test/flutter_test.dart';
import 'package:app_1/data/city_weather.dart';

void main() {
  test('test', () async {
    final weatherApiClient = WeatherApiClient();
    try {
      final weatherData =
          await weatherApiClient.getWeatherForecast(59.57, 30.19);
      for (int i = 0; i < 24; i++) {
        print('temperaturelist: ${weatherData.temperatureList[i]}');
        print('timelist: ${weatherData.timelist[i]}');
      }
    } catch (error) {
      print('Error: $error');
      ;
    }
  });
}
