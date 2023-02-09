import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather_ai/components.dart';
import 'package:weather_ai/views/locations.dart';
import 'package:weather_ai/views/weather_detail.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //variables
  final pController = PanelController();
  double panelPosition = 0;
  Map currentWeather = {};
  String location = "", country = "", address = "";
  double latitude = 0, longitude = 0, altitude = 0;
  Map weeklyWeather = {};
  Map hourlyWeather = {};
  List weeklyDayNames = [];
  List weeklyAvgTemp = [];
  List weeklyWeatherCode = [];
  List hourlyTimes = [];
  List hourlyTemp = [];
  List hourlyWeatherCode = [];

  //APIs
  Future<Position> getMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) Future.error('Location services are disabled.');
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) Future.error('Location permissions are permanently denied, we cannot request permissions.');
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocation({required double lat, required double lng}) async {
    var response = await http.get(Uri.parse("https://api.opencagedata.com/geocode/v1/json?key=0aabe27b107d496db971d4aa5acad6c0&q=$lat,$lng&limit=1&address_only=1&no_annotations=1"));
    Map result = jsonDecode(response.body);
    setState(() => address = '${result["results"][0]["formatted"]}');
    setState(() => location =
        result["results"][0]["formatted"].toString().split(", ").length > 1 ? result["results"][0]["formatted"].toString().split(", ")[1] : result["results"][0]["formatted"].toString().split(", ")[0]);
    setState(() => country = result["results"][0]["formatted"].toString().split(", ")[result["results"][0]["formatted"].toString().split(",").length - 1]);
  }

  Future<void> getWeatherOfCurrentLocation({required double lat, required double lng}) async {
    var response = await http.get(
        Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current_weather=true&temperature_unit=celsius&windspeed_unit=kmh&precipitation_unit=mm&timeformat=iso8601&timezone=auto"));
    Map result = jsonDecode(response.body);
    setState(() => currentWeather = result["current_weather"]);
  }

  Future<void> getDetailWeatherOfCurrentLocation({required double lat, required double lng}) async {
    List temp = [];
    var response = await http.get(Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&temperature_unit=celsius&windspeed_unit=kmh&precipitation_unit=mm&timeformat=iso8601&timezone=GMT&past_days=2&daily=temperature_2m_max,temperature_2m_min,weathercode&hourly=temperature_2m,weathercode"));
    Map result = jsonDecode(response.body);
    Map hourly = result["hourly"];
    //
    temp = [];
    for (int i = 0; i < hourly["time"].length; i++) {
      temp.add(hourly["time"][i].toString().split("T")[1].split(":")[0]);
    }
    setState(() => hourlyTimes = temp);
    //
    temp = [];
    for (int i = 0; i < hourly["time"].length; i++) {
      temp.add(hourly["temperature_2m"][i]);
    }
    setState(() => hourlyTemp = temp);
    temp = [];
    for (int i = 0; i < hourly["time"].length; i++) {
      temp.add(hourly["weathercode"][i]);
    }
    setState(() => hourlyWeatherCode = temp);
    ////
    Map daily = result["daily"];
    //
    temp = [];
    for (int i = 0; i < daily["time"].length; i++) {
      temp.add(DateFormat('EEE').format(DateTime.parse(daily["time"][i])));
    }
    setState(() => weeklyDayNames = temp);
    //
    temp = [];
    for (int i = 0; i < daily["time"].length; i++) {
      temp.add((daily["temperature_2m_max"][i] + daily["temperature_2m_min"][i]) / 2);
    }
    setState(() => weeklyAvgTemp = temp);
    //
    temp = [];
    for (int i = 0; i < daily["time"].length; i++) {
      temp.add(daily["weathercode"][i]);
    }
    setState(() => weeklyWeatherCode = temp);
  }

  //Functions
  Future defaultInit() async {
    Position gps = await getMyLocation();
    setState(() {
      latitude = gps.latitude;
      longitude = gps.longitude;
      altitude = gps.altitude;
    });
    await getLocation(lat: latitude, lng: longitude);
    await getWeatherOfCurrentLocation(lat: latitude, lng: longitude);
    await getDetailWeatherOfCurrentLocation(lat: latitude, lng: longitude);
  }

  //Initiate
  @override
  void initState() {
    super.initState();
    defaultInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const Locations(),
        backgroundColor: const Color(0xff2D3259),
        body: SlidingUpPanel(
            parallaxEnabled: true,
            color: Colors.transparent,
            boxShadow: null,
            controller: pController,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            maxHeight: MediaQuery.of(context).size.height - 100,
            minHeight: 260,
            parallaxOffset: 0.25,
            onPanelSlide: (position) => setState(() => panelPosition = position),
            body: CurrentWeather(
                location: location,
                country: country,
                address: address,
                time: currentWeather["time"].toString().replaceAll("T", " at "),
                weather: currentWeather["weathercode"].toString(),
                temp: currentWeather["temperature"] ?? 0,
                maxTemp: currentWeather["temperature"] ?? 0,
                minTemp: currentWeather["temperature"] ?? 0),
            panelBuilder: (controller) => WeatherDetail(
                controller: controller,
                pController: pController,
                latitude: latitude,
                longitude: longitude,
                altitude: altitude,
                hourlyTimes: hourlyTimes,
                hourlyTemp: hourlyTemp,
                hourlyWeatherCode: hourlyWeatherCode,
                weeklyDayNames: weeklyDayNames,
                weeklyAvgTemp: weeklyAvgTemp,
                weeklyWeatherCode: weeklyWeatherCode)));
  }
}
