import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather_ai/views/weather_detail.dart';

import 'current_weather_full_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final pController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: pController,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        maxHeight: MediaQuery.of(context).size.height - 150,
        minHeight: 200,
        parallaxOffset: 0.5,
        body: CurrentWeatherBigScreen(pController: pController),
        panelBuilder: (controller) => WeatherDetail(controller: controller, pController: pController)
      )
    );
  }
}
