import 'package:app_1/data/city.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CitySelectionWidget extends StatefulWidget {
  final Function(City) onCitySelected; // Добавление именованного параметра

  CitySelectionWidget({required this.onCitySelected});

  @override
  State<CitySelectionWidget> createState() => _CitySelectionWidgetState();
}

class _CitySelectionWidgetState extends State<CitySelectionWidget> {
  late final CityApiClient cityApiClient = CityApiClient();

  // Создание экземпляра CityApiClient
  @override
  Widget build(BuildContext context) {
    return TypeAheadField<City>(
      suggestionsCallback: (pattern) async {
        final cities = await cityApiClient.getCities(pattern);
        return cities;
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.name),
        );
      },
      onSelected: (City suggestion) {
        widget.onCitySelected(suggestion);
        print('Selected city: ${suggestion.name}');
      },
    );
  }
}
