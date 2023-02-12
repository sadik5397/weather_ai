import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:weather_ai/components.dart';
import 'package:weather_ai/views/locations.dart';
import 'package:weather_ai/views/weather_detail.dart';

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
  Map currentWeatherDetail = {};
  Map todayWeather = {};
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

  Future<void> getCurrentBasicWeather({required double lat, required double lng}) async {
    var response = await http.get(
        Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current_weather=true&temperature_unit=celsius&windspeed_unit=kmh&precipitation_unit=mm&timeformat=iso8601&timezone=auto"));
    Map result = jsonDecode(response.body);
    setState(() => currentWeather = result["current_weather"]);
  }

  Future<void> getCurrentAdvancedWeather({required double lat, required double lng, required int currentHour}) async {
    var response = await http
        .get(Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&temperature_unit=celsius&windspeed_unit=kmh&precipitation_unit=mm&timeformat=iso8601&timezone=auto&hourly=cloudcover,"
            "relativehumidity_2m,dewpoint_2m,apparent_temperature,surface_pressure,cloudcover_high,cloudcover_mid,cloudcover_low,windspeed_10m,windspeed_80m,windspeed_120m,windspeed_180m,winddirection_10m,"
            "winddirection_80m,winddirection_120m,winddirection_180m,shortwave_radiation,direct_radiation,direct_normal_irradiance,diffuse_radiation,cape,evapotranspiration,precipitation,snowfall,rain,"
            "showers,snow_depth,visibility,soil_temperature_0cm,soil_moisture_0_1cm"));
    Map result = jsonDecode(response.body);
    setState(() => currentWeatherDetail = {
          "Humidity": result["hourly"]["relativehumidity_2m"][currentHour],
          "Dew Point": result["hourly"]["dewpoint_2m"][currentHour],
          "Feels Like": result["hourly"]["apparent_temperature"][currentHour],
          "Atmospheric Pressure": result["hourly"]["surface_pressure"][currentHour],
          "Cloud-cover": result["hourly"]["cloudcover"][currentHour],
          "Cloud-cover Low": result["hourly"]["cloudcover_low"][currentHour],
          "Cloud-cover Mid": result["hourly"]["cloudcover_mid"][currentHour],
          "Cloud-cover High": result["hourly"]["cloudcover_high"][currentHour],
          "windspeed_10m": result["hourly"]["windspeed_10m"][currentHour],
          "windspeed_80m": result["hourly"]["windspeed_80m"][currentHour],
          "windspeed_120m": result["hourly"]["windspeed_120m"][currentHour],
          "windspeed_180m": result["hourly"]["windspeed_180m"][currentHour],
          "winddirection_10m": result["hourly"]["winddirection_10m"][currentHour],
          "winddirection_80m": result["hourly"]["winddirection_80m"][currentHour],
          "winddirection_120m": result["hourly"]["winddirection_120m"][currentHour],
          "winddirection_180m": result["hourly"]["winddirection_180m"][currentHour],
          "shortwave_radiation": result["hourly"]["shortwave_radiation"][currentHour],
          "direct_radiation": result["hourly"]["direct_radiation"][currentHour],
          "direct_normal_irradiance": result["hourly"]["direct_normal_irradiance"][currentHour],
          "diffuse_radiation": result["hourly"]["diffuse_radiation"][currentHour],
          "cape": result["hourly"]["cape"][currentHour],
          "evapotranspiration": result["hourly"]["evapotranspiration"][currentHour],
          "precipitation": result["hourly"]["precipitation"][currentHour],
          "snowfall": result["hourly"]["snowfall"][currentHour],
          "rain": result["hourly"]["rain"][currentHour],
          "showers": result["hourly"]["showers"][currentHour],
          "snow_depth": result["hourly"]["snow_depth"][currentHour],
          "visibility": result["hourly"]["visibility"][currentHour],
          "soil_temperature_0cm": result["hourly"]["soil_temperature_0cm"][currentHour],
          "soil_moisture_0_1cm": result["hourly"]["soil_moisture_0_1cm"][currentHour],
        });
    print("----------------");
    print("$lat,$lng");
    print(currentHour);
    print(currentWeatherDetail);
  }

  Future<void> getHourlyAndWeekly({required double lat, required double lng}) async {
    List temp = [];
    var response = await http
        .get(Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&temperature_unit=celsius&windspeed_unit=kmh&precipitation_unit=mm&timeformat=iso8601&timezone=auto&past_days=2&daily"
            "=temperature_2m_max,temperature_2m_min,weathercode&hourly=temperature_2m,weathercode"));
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

  Future<void> getDetailWeatherOfToday({required double lat, required double lng, required String date}) async {
    var response = await http
        .get(Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&temperature_unit=celsius&windspeed_unit=kmh&precipitation_unit=mm&timeformat=iso8601&timezone=auto&start_date=$date"
            "&end_date=$date&daily=temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_sum,precipitation_hours,weathercode,sunrise,sunset,"
            "shortwave_radiation_sum,rain_sum,showers_sum,snowfall_sum,uv_index_max,uv_index_clear_sky_max"));
    Map result = jsonDecode(response.body);
    setState(() => todayWeather = result["daily"]);
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
    await getCurrentBasicWeather(lat: latitude, lng: longitude);
    await getHourlyAndWeekly(lat: latitude, lng: longitude);
    await getCurrentAdvancedWeather(lat: latitude, lng: longitude, currentHour: DateTime.now().hour);
    await getDetailWeatherOfToday(lat: latitude, lng: longitude, date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
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
                weather: currentWeather.isEmpty ? "Loading...": weatherCodeToStatus(currentWeather["weathercode"]),
                temp: currentWeather["temperature"] ?? 0,
                maxTemp: todayWeather["temperature_2m_max"] == null ? 0 : todayWeather["temperature_2m_max"][0],
                minTemp: todayWeather["temperature_2m_min"] == null ? 0 : todayWeather["temperature_2m_min"][0]),
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
                  weeklyWeatherCode: weeklyWeatherCode,
                  optionalData: currentWeatherDetail,
                  weatherDetails: [
                    {"Feels Like Max": todayWeather["apparent_temperature_max"] == null ? "" : todayWeather["apparent_temperature_max"][0]},
                    {"Feels Like Min": todayWeather["apparent_temperature_min"] == null ? "" : todayWeather["apparent_temperature_min"][0]},
                    {"Precipitation": todayWeather["precipitation_sum"] == null ? "" : todayWeather["precipitation_sum"][0]},
                    {"Sunrise": todayWeather["sunrise"] == null ? "" : todayWeather["sunrise"][0]},
                    {"Sunset": todayWeather["sunset"] == null ? "" : todayWeather["sunset"][0]},
                    {"Shortwave Radiation": todayWeather["shortwave_radiation_sum"] == null ? "" : todayWeather["shortwave_radiation_sum"][0]},
                    {"Rain": todayWeather["rain_sum"] == null ? "" : todayWeather["rain_sum"][0]},
                    {"Shower": todayWeather["showers_sum"] == null ? "" : todayWeather["showers_sum"][0]},
                    {"Snowfall": todayWeather["showers_sum"] == null ? "" : todayWeather["showers_sum"][0]},
                    {"UV Index": todayWeather["uv_index_max"] == null ? "" : todayWeather["uv_index_max"][0]},
                    {"UV Index Clear Sky": todayWeather["uv_index_clear_sky_max"] == null ? "" : todayWeather["uv_index_clear_sky_max"][0]},
                  ],
                )));
  }
}
