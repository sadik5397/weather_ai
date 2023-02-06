import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CurrentWeatherBigScreen extends StatefulWidget {
  const CurrentWeatherBigScreen({Key? key, required this.pController}) : super(key: key);
  final PanelController pController;

  @override
  State<CurrentWeatherBigScreen> createState() => _CurrentWeatherBigScreenState();
}

class _CurrentWeatherBigScreenState extends State<CurrentWeatherBigScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Placeholder(),
        Placeholder(),
        Placeholder(),
        Placeholder(),
      ],
    );
  }
}