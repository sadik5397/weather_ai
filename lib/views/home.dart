import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather_ai/views/weather_detail.dart';

import 'current_weather_full_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  final pController = PanelController();
  double panelPosition = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff2D3259),
        body: SlidingUpPanel(
            parallaxEnabled: true,
            color: Colors.transparent,
            boxShadow: null,
            controller: pController,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            maxHeight: MediaQuery.of(context).size.height - 100,
            minHeight: 220,
            parallaxOffset: 0.25,
            onPanelSlide: (position) => setState(() => panelPosition = position),
            body: CurrentWeatherBigScreen(pController: pController, panelPosition: panelPosition),
            panelBuilder: (controller) => WeatherDetail(controller: controller, pController: pController)));
  }
}
