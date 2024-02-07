import 'package:flutter_test/flutter_test.dart';
import 'package:app_1/data/city.dart';
import 'package:app_1/data/city_weather.dart';

void main() {
  group('CityApiClient Tests', () {
    test('getcityname returns a list of City objects', () async {
      final cityApiClient = CityApiClient();
      final cityDataList = await cityApiClient.getCities('Москва');
      final weatherApiClient = WeatherApiClient();
      expect(cityDataList, isA<List<City>>());
      expect(cityDataList, isNotEmpty);

      for (final city in cityDataList) {
        final weatherData = await weatherApiClient.getWeatherForecast(
            city.latitude, city.longitude);
        print('City: ${city.name}');
        print('Latitude: ${city.latitude}');
        print('Longitude: ${city.longitude}');
        print('------------------');
      }
    });

    test('getcityname handles errors', () async {
      final cityApiClient = CityApiClient();

      try {
        await cityApiClient.getCities('NonexistentCity');
      } catch (error) {
        expect(error, isA<Exception>());
        expect(error.toString(), contains('Failed to load weather forecast'));
      }
    });
  });
}
