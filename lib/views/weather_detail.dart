import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../components.dart';

class WeatherDetail extends StatefulWidget {
  const WeatherDetail(
      {Key? key,
      required this.controller,
      required this.pController,
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.weeklyDayNames,
      required this.weeklyAvgTemp,
      required this.weeklyWeatherCode,
      required this.hourlyTimes,
      required this.hourlyTemp,
      required this.hourlyWeatherCode,
      required this.weatherDetails,
      required this.optionalData})
      : super(key: key);
  final ScrollController controller;
  final PanelController pController;
  final double latitude;
  final double longitude;
  final double altitude;
  final List weeklyDayNames;
  final List weeklyAvgTemp;
  final List weeklyWeatherCode;
  final List hourlyTimes;
  final List hourlyTemp;
  final List hourlyWeatherCode;
  final List<Map<String, dynamic>> weatherDetails;
  final Map optionalData;

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> with SingleTickerProviderStateMixin {
  //variables
  late TabController tabController;

  //API

  //Functions
  togglePanel() => widget.pController.isPanelOpen ? widget.pController.close() : widget.pController.open();

  Future defaultInit() async {}

  //Initiate
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WeatherDetailPanel(
        onPanelCloseTap: togglePanel,
        hourly: List.generate(
            widget.hourlyTimes.isEmpty ? 0 : 24,
            (index) => TemperaturePill(
                selected: index == DateTime.now().hour, dateOrTime: hrToHour(int.parse(widget.hourlyTimes[index])), weatherCode: widget.hourlyWeatherCode[index], avgTemp: widget.hourlyTemp[index])),
        weekly: List.generate(widget.weeklyDayNames.length,
            (index) => TemperaturePill(selected: index == 3, dateOrTime: widget.weeklyDayNames[index], weatherCode: widget.weeklyWeatherCode[index], avgTemp: widget.weeklyAvgTemp[index])),
        controller: widget.controller,
        pController: widget.pController,
        tabController: tabController,
        children: [
          Column(children: List.generate(widget.weatherDetails.length, (index) => Text("${widget.weatherDetails[index].keys}: ${widget.weatherDetails[index].values}"))),
          Text(widget.optionalData.toString()),
          const PaddedRow(children: [AirQuality(value: 7, status: "Airing")]),
          PaddedRow(children: [const UvIndex(status: "Better", value: 2), SunLine(status: "06:47 PM", value: 100, size: size)]),
          PaddedRow(children: [const WindSpeed(status: "Better", value: 2, direction: 0), SunLine(status: "06:47 PM", value: 100, size: size)])
        ]);
  }
}
