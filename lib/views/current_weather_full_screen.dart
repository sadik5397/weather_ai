import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_ai/views/home.dart';
import 'package:weather_ai/views/locations.dart';

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
        decoration: const BoxDecoration(color: Color(0xff2D3259)),
        child: Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [const Color(0xff2E335A).withOpacity(.05), const Color(0xff1C1B33).withOpacity(.75)])),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Opacity(
                  opacity: .5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("https://source.unsplash.com/random/?${Uri.encodeFull('Norway ${Random(1)}')}"), fit: BoxFit.cover)),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(.25), Colors.black.withOpacity(0)])),
              ),
              Column(children: [
                AppBar(actions: [Padding(padding: const EdgeInsets.only(right: 12), child: IconButton(onPressed: () => route(context, const Locations()), icon: const SizedBox(height: 40, width: 40, child: const Icon(Icons.place_outlined, color: Colors.white))))], backgroundColor: Colors.transparent),
                const Spacer(),
                const Text("Montreal", style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
                Text(widget.panelPosition.toStringAsFixed(2), style: const TextStyle(fontSize: 96, color: Colors.white, fontWeight: FontWeight.w100, height: 1), textAlign: TextAlign.center),
                Text("Mostly Clear", style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                const Text("High: 24°  |  Low: 19°", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400, height: 1.25), textAlign: TextAlign.center),
                const Spacer(flex: 6)
              ])
            ])));
  }
}
