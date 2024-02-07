import 'package:dio/dio.dart';

class CityApiClient {
  final Dio _dio = Dio();

  Future<List<City>> getCities(String name) async {
    try {
      final response = await _dio.get(
          'https://geocoding-api.open-meteo.com/v1/search',
          queryParameters: {
            'name': name,
            'count': 10,
            'language': 'ru',
          });
      print(response.data);
      return (response.data['results'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => City(e))
          .toList();
    } catch (error) {
      throw Exception('Failed to load weather forecast: $error');
    }
  }
}

class City {
  final Map<String, dynamic> _data;
  City(this._data);
  double get latitude => _data['latitude'];
  double get longitude => _data['longitude'];
  String get name => _data['name'];
}
