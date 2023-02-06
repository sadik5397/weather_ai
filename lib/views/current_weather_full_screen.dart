import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrentWeatherBigScreen extends StatefulWidget {
  const CurrentWeatherBigScreen({Key? key, required this.pController, required this.panelPosition}) : super(key: key);
  final PanelController pController;
  final double panelPosition;

  @override
  State<CurrentWeatherBigScreen> createState() => _CurrentWeatherBigScreenState();
}

class _CurrentWeatherBigScreenState extends State<CurrentWeatherBigScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color(0xff2D3259) ,image: DecorationImage(image: AssetImage("assets/background.png"), fit: BoxFit.cover)),
        child: Container(
            decoration:
                BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [const Color(0xff2E335A).withOpacity(.05), const Color(0xff1C1B33).withOpacity(.75)])),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Image.asset("assets/house.png"),
              Column(children: [
                const Expanded(child: SizedBox()),
                const Text("Montreal", style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
                Text(widget.panelPosition.toStringAsFixed(2), style: TextStyle(fontSize: 96, color: Colors.white, fontWeight: FontWeight.w100, height: 1), textAlign: TextAlign.center),
                Text("Mostly Clear", style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                const Text("High: 24°  |  Low: 19°", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400, height: 1.25), textAlign: TextAlign.center),
                const Expanded(flex: 4, child: SizedBox())
              ])
            ])));
  }
}
