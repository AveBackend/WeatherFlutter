import 'package:app_1/data/city.dart';
import 'package:app_1/widget/city_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_1/widget/city_weather_widget.dart';

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

    // Запуск функции обновления времени каждую секунду
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CitySelectionWidget(
                  onCitySelected: (city) {
                    setState(() {
                      selectedCity = city;
                    });
                  },
                ),
                if (selectedCity != null)
                  WeatherDisplayWidget(
                    latitude: selectedCity!.latitude,
                    longitude: selectedCity!.longitude,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
