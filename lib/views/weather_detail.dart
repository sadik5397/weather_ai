import 'package:flutter/foundation.dart';
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
      required this.weatherDetails})
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
  final Map weatherDetails;

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
          if(kDebugMode) SelectableText(widget.weatherDetails.toString().replaceAll("{", "").replaceAll("}", "").replaceAll(", ", "\n")),
          PaddedRow(children: [AirQuality(value: widget.weatherDetails["aq_index"], components: widget.weatherDetails["aqi_components"])]),
          PaddedRow(children: [
            Humidity(hum: widget.weatherDetails["relativehumidity_2m"], dewPoint: widget.weatherDetails["dewpoint_2m"]),
            FeelsLike(
                temp: widget.weatherDetails["actual_temperature"],
                current: widget.weatherDetails["apparent_temperature"],
                max: widget.weatherDetails["apparent_temperature_max"],
                min: widget.weatherDetails["apparent_temperature_min"])
          ]),
          PaddedRow(children: [
            WindSpeed(
                value0: widget.weatherDetails["windspeed_0m"],
                value10: widget.weatherDetails["windspeed_10m"],
                value80: widget.weatherDetails["windspeed_80m"],
                value120: widget.weatherDetails["windspeed_120m"],
                value180: widget.weatherDetails["windspeed_180m"],
                direction0: widget.weatherDetails["winddirection_0m"],
                direction10: widget.weatherDetails["winddirection_10m"],
                direction80: widget.weatherDetails["winddirection_80m"],
                direction120: widget.weatherDetails["winddirection_120m"],
                direction180: widget.weatherDetails["winddirection_180m"])
          ])
        ]);
  }
}
