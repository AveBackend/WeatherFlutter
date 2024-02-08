import 'package:app_1/data/city.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  runApp(const FlutterTutorialApp());
}

class FlutterTutorialApp extends StatelessWidget {
  const FlutterTutorialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String formattedTime = '';
  City? selectedCity;

  @override
  void initState() {
    super.initState();
    updateFormattedTime();
  }

  void updateFormattedTime() {
    setState(() {
      DateTime now = DateTime.now();
      formattedTime = "${now.hour}:${now.minute}";
    });

    // Запуск функции обновления времени каждую секунд
    if (mounted)
      Future.delayed(const Duration(seconds: 1), updateFormattedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Погода \n$formattedTime ${selectedCity?.name ?? ''}'),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          ElevatedButton(
            onPressed: () {},
            child: Text('Add'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BackgroundForAppWeather.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: CitySelectionWidget(onCitySelected: (city) {
              setState(() {
                selectedCity = city;
              });
            }),
          ),
        ),
      ),
    );
  }
}

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
