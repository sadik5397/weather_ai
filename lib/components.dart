// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Future<dynamic> route(BuildContext context, Widget widget) => Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

dynamic routeBack(BuildContext context) => Navigator.pop(context);

String weatherCodeToStatus(int weathercode) {
  if (weathercode == 0) return "Clear Sky";
  if (weathercode == 1) return "Mainly Clear";
  if (weathercode == 2) return "Partly Cloudy";
  if (weathercode == 3) return "Overcast";
  if (weathercode == 45) return "Fog";
  if (weathercode == 48) return "Depositing Rime Fog";
  if (weathercode == 51) return "Light Drizzle";
  if (weathercode == 53) return "Moderate Drizzle";
  if (weathercode == 55) return "Dense Drizzle";
  if (weathercode == 56) return "Light Freezing Drizzle";
  if (weathercode == 57) return "Dense Freezing Drizzle";
  if (weathercode == 61) return "Slight Rain";
  if (weathercode == 63) return "Moderate Rain";
  if (weathercode == 65) return "Heavy Rain";
  if (weathercode == 66) return "Light Freezing Rain";
  if (weathercode == 67) return "Heavy Freezing Rain";
  if (weathercode == 71) return "Slight Snow Fall";
  if (weathercode == 73) return "Moderate Snow Fall";
  if (weathercode == 75) return "Heavy Snow Fall";
  if (weathercode == 77) return "Snow Grains";
  if (weathercode == 80) return "Slight Rain Showers";
  if (weathercode == 81) return "Moderate Rain Showers";
  if (weathercode == 82) return "Violent Rain Showers";
  if (weathercode == 85) return "Slight Snow Showers";
  if (weathercode == 86) return "Heavy Snow Showers";
  if (weathercode == 95) return "Thunderstorm";
  if (weathercode == 96) return "Slight Hail Thunderstorm";
  if (weathercode == 99) return "Heavy Hail Thunderstorm";
  return "Weather.ai";
}

String airPollutionCodeToStatus(int airPollutionCode) {
  if (airPollutionCode == 1) return "Good";
  if (airPollutionCode == 2) return "Fair";
  if (airPollutionCode == 3) return "Moderate";
  if (airPollutionCode == 4) return "Poor";
  if (airPollutionCode == 5) return "Violent";
  return "Undefined";
}

String hrToHour(int hr) {
  if (hr == 0) return "12 AM";
  if (hr > 0 && hr < 12) return "$hr AM";
  if (hr == 12) return "12 PM";
  if (hr > 12 && hr < 24) return "${hr - 12} PM";
  return "Weather.ai";
}

String toolTip(String title) {
  if (title == "Air Quality") {
    return "Besides basic Air Quality Index, you can see data about polluting gases, such as Carbon monoxide (CO), Nitrogen monoxide (NO), Nitrogen dioxide (NO2), Ozone (O3), Sulphur dioxide (SO2), Ammonia (NH3), and particulates (PM2.5 and PM10).";
  }
  if (title == "Rel. Humidity") return "Relative humidity at 2 meters above ground and Dew point temperature at 2 meters above ground";
  if (title == "Feels Like") {
    return "Apparent temperature is the perceived feels-like temperature combining wind chill factor, relative humidity and solar radiation. Moreover, Maximum and minimum daily air temperature at 2 meters above ground";
  }
  if (title == "Wind") {
    return "Wind speed at 10 or 100 meters above ground. Wind speed on 10 meters is the standard level and Wind direction at 10 or 100 meters above ground. Gusts at 10 meters above ground as a maximum of the preceding hour";
  }
  if (title == "Precipitation") {
    return "Total precipitation (rain, showers, snow) sum of the preceding hour. Data is stored with a 0.1 mm precision. If precipitation data is summed up to monthly sums, there might be small inconsistencies with the total precipitation amount.";
  }
  if (title == "Visibility") {
    return "Visibility is a measure of the horizontal opacity of the atmosphere at the point of observation and is expressed in terms of the horizontal distance at which a person should be able to see and identify";
  }
  if (title == "Shortwave Solar Radiation") return "Shortwave solar radiation as average of the preceding hour. This is equal to the total global horizontal irradiation";
  if (title == "Soil Temp.")
    // ignore: curly_braces_in_flow_control_structures
    return "Average temperature of different soil levels below ground (0-7cm depths) and Average soil water content as volumetric mixing ratio at 0-7cm depths.";
  if (title == "Sun") return "Sun rise and set times of current day";
  if (title == "Evapotranspiration") return "ET₀ Reference Evapotranspiration of a well watered grass field. Based on FAO-56 Penman-Monteith equations";
  if (title == "Surface Pressure") {
    return "	Atmospheric air pressure reduced to mean sea level (msl) or pressure at surface. Typically pressure on mean sea level is used in meteorology. Surface pressure gets lower with increasing elevation.";
  }
  if (title == "Snow Depth") return "Snow Depth (total depth of snow on the ground) is reported to the nearest WHOLE INCH (such as 11''). It is typically reported at 7am.";
  return "Weather.ai";
}

class CurrentTemp extends StatelessWidget {
  const CurrentTemp({Key? key, required this.location, required this.weather, required this.temp, required this.maxTemp, required this.minTemp}) : super(key: key);
  final String location;
  final String weather;
  final double temp;
  final double maxTemp;
  final double minTemp;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(location, style: const TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w300, height: 1.05), textAlign: TextAlign.center),
      Text("$temp°", style: const TextStyle(fontSize: 96, color: Colors.white, fontWeight: FontWeight.w100, height: 1.15), textAlign: TextAlign.center),
      SvgPicture.asset("assets/icons/$weather.svg", height: 72, fit: BoxFit.fitHeight),
      Text(weather, style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400), textAlign: TextAlign.center),
      const SizedBox(height: 6),
      Text("High: $maxTemp°  |  Low: $minTemp°", style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400, height: 1.25), textAlign: TextAlign.center)
    ]);
  }
}

class ContainerBox extends StatelessWidget {
  const ContainerBox({Key? key, required this.children, this.width, this.horizontalPadding, this.onTap, this.height, required this.tooltipInfo}) : super(key: key);
  final List<Widget> children;
  final double? width, height, horizontalPadding;
  final String tooltipInfo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Tooltip(
      message: tooltipInfo,
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20),
      enableFeedback: true,
      showDuration: const Duration(seconds: 5),
      verticalOffset: -80,
      textAlign: TextAlign.center,
      child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(20).copyWith(right: horizontalPadding ?? 20, left: horizontalPadding ?? 20),
          width: width == null ? null : width! - 16,
          height: height == null ? 190 : height! - 16,
          decoration: BoxDecoration(
              color: const Color(0xff2D2258).withOpacity(.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.2), width: 1, strokeAlign: BorderSide.strokeAlignOutside)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children)),
    ));
  }
}

class ColorfulIndicatorBar extends StatelessWidget {
  const ColorfulIndicatorBar({Key? key, required this.value, required this.maxValue}) : super(key: key);
  final int value;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
          height: 6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xff3759B1), Color(0xffE74395)]))),
      Row(children: [Spacer(flex: value + 1), const CircleAvatar(radius: 7, backgroundColor: Colors.white), Spacer(flex: maxValue - value + 1)])
    ]);
  }
}

class PaddedRow extends StatelessWidget {
  const PaddedRow({Key? key, required this.children}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Row(children: children));
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({Key? key, required this.location, required this.weather, required this.temp, required this.time, required this.size, required this.onTap}) : super(key: key);
  final String location;
  final String weather;
  final int temp;
  final String time;
  final Size size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Bounceable(
            onTap: () {},
            onTapUp: (value) => onTap.call(),
            child: Stack(alignment: Alignment.center, fit: StackFit.loose, children: [
              SvgPicture.asset("assets/trapisium_tile.svg", width: size.width - 32, fit: BoxFit.contain),
              Padding(
                  padding: const EdgeInsets.all(32),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("$temp°", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 72, height: 1.2)),
                      Text("Time - $time", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w400, fontSize: 17)),
                      Text(location, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 17, height: 1))
                    ]),
                    Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      const FlutterLogo(size: 94),
                      const SizedBox(height: 16),
                      Text(weather, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 17, height: 1))
                    ])
                  ]))
            ])));
  }
}

class AirQuality extends StatelessWidget {
  const AirQuality({Key? key, required this.value, required this.components}) : super(key: key);
  final int value;
  final Map components;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(tooltipInfo: toolTip("Air Quality"), children: [
      Text("Air Quality", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      const Spacer(flex: 2),
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
          Text(airPollutionCodeToStatus(value), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 22))
        ]),
        Container(height: 72, width: 1, color: Colors.white, margin: const EdgeInsets.symmetric(horizontal: 12)),
        Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  AirComponents(value: components["co"], gas: "CO"),
                  AirComponents(value: components["no"], gas: "NO"),
                  AirComponents(value: components["no2"], gas: "NO₂"),
                  AirComponents(value: components["o3"], gas: "O₃"),
                  AirComponents(value: components["so2"], gas: "SO₂"),
                  AirComponents(value: components["pm2_5"], gas: "PM₂.₅"),
                  AirComponents(value: components["pm10"], gas: "PM₁₀"),
                  AirComponents(value: components["nh3"], gas: "NH₃")
                ])))
      ]),
      const Spacer(flex: 2),
      ColorfulIndicatorBar(value: value, maxValue: 5),
      const Spacer()
    ]);
  }
}

class AirComponents extends StatelessWidget {
  const AirComponents({Key? key, required this.value, required this.gas}) : super(key: key);
  final num value;
  final String gas;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(children: [
          CircleAvatar(radius: 18, backgroundColor: Colors.white.withOpacity(.15), child: Text(gas, style: const TextStyle(color: Colors.white))),
          const SizedBox(height: 4),
          Text(value.toString(), textScaleFactor: .8)
        ]));
  }
}

class Precipitation extends StatelessWidget {
  const Precipitation(
      {Key? key,
      required this.value,
      required this.valueSum,
      required this.snowfall,
      required this.snowfallSum,
      required this.rain,
      required this.rainSum,
      required this.shower,
      required this.showerSum})
      : super(key: key);
  final num? value, valueSum, snowfall, snowfallSum, rain, rainSum, shower, showerSum;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(height: 460, tooltipInfo: toolTip("Precipitation"), children: [
      Text("Precipitation", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      const Spacer(flex: 2),
      Text('$value%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
      const Spacer(),
      ColorfulIndicatorBar(value: value!.toInt(), maxValue: 100),
      const Spacer(flex: 2),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Today's Total", style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1.5)),
        Text('$valueSum%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1))
      ]),
      const Spacer(),
      PrecipitationComponent(current: rain ?? 0, sum: rainSum ?? 0, component: "Rain"),
      PrecipitationComponent(current: snowfall ?? 0, sum: snowfallSum ?? 0, component: "Snowfall"),
      PrecipitationComponent(current: shower ?? 0, sum: showerSum ?? 0, component: "Shower"),
    ]);
  }
}

class PrecipitationComponent extends StatelessWidget {
  const PrecipitationComponent({Key? key, required this.current, required this.sum, required this.component}) : super(key: key);
  final num current, sum;
  final String component;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      const Divider(color: Colors.white),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Image.asset("assets/png/${component.toLowerCase()}.png", width: 40, fit: BoxFit.fitWidth),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(component, style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1.25)),
          Text('$current%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 24, height: 1.25)),
          Text('Total: $sum%', style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1.25))
        ]))
      ])
    ]);
  }
}

class Humidity extends StatelessWidget {
  const Humidity({Key? key, required this.hum, required this.dewPoint}) : super(key: key);
  final num hum, dewPoint;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(tooltipInfo: toolTip("Rel. Humidity"), children: [
      Text("Rel. Humidity", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      const Spacer(flex: 2),
      Text('$hum%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
      const Spacer(),
      ColorfulIndicatorBar(value: hum.toInt(), maxValue: 100),
      const Spacer(flex: 2),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Dew Point", style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1.5)),
        Text('${dewPoint.toString()}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1))
      ])
    ]);
  }
}

class SoilTemperature extends StatelessWidget {
  const SoilTemperature({Key? key, required this.temp, required this.moist, required this.vapor, required this.screenSize}) : super(key: key);
  final num temp, moist, vapor;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: screenSize.width / 2 - 10,
        child: ContainerBox(tooltipInfo: toolTip("Soil Temp."), children: [
          Text("Soil Temp.", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
          const Spacer(flex: 2),
          Text('$temp°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
          const Spacer(flex: 2),
          const Divider(height: 6, thickness: 2),
          RadiationComponent(value: moist, component: "Moisture"),
          const Divider(height: 6, thickness: 2),
          RadiationComponent(value: vapor, component: "Vapor Pressure"),
        ]));
  }
}

class VisibilityDistance extends StatelessWidget {
  const VisibilityDistance({Key? key, required this.value, required this.screenSize}) : super(key: key);
  final num value;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 135,
        width: screenSize.width / 2 - 10,
        child: ContainerBox(tooltipInfo: toolTip("Visibility"), children: [
          Text("Visibility", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
          const Spacer(flex: 2),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text((value / 1000).toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
            const Padding(padding: EdgeInsets.only(bottom: 4), child: Text(" KM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1)))
          ]),
          const Spacer(),
        ]));
  }
}

class CloudCover extends StatelessWidget {
  const CloudCover({Key? key, required this.value, required this.low, required this.mid, required this.high, required this.screenSize}) : super(key: key);
  final num value, low, mid, high;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 325,
        width: screenSize.width / 2 - 10,
        child: ContainerBox(tooltipInfo: toolTip("Cloud Cover"), children: [
          Text("Cloud Cover", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
          const Spacer(flex: 2),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('$value%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
            Padding(padding: const EdgeInsets.only(left: 8, top: 4), child: Icon(Icons.cloud, color: Colors.white.withOpacity(value / 100), size: 20))
          ]),
          const Spacer(),
          ColorfulIndicatorBar(value: value.toInt(), maxValue: 100),
          const Spacer(flex: 2),
          CloudCoverComponent(value: low, component: "Low"),
          CloudCoverComponent(value: mid, component: "Mid"),
          CloudCoverComponent(value: high, component: "High"),
        ]));
  }
}

class CloudCoverComponent extends StatelessWidget {
  const CloudCoverComponent({Key? key, required this.value, required this.component}) : super(key: key);
  final num value;
  final String component;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      const Divider(color: Colors.white),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(component, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18, height: 1.25)),
        Text('$value%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 24, height: 1.25))
      ])
    ]);
  }
}

class FeelsLike extends StatelessWidget {
  const FeelsLike({Key? key, required this.current, required this.max, required this.min, required this.temp}) : super(key: key);
  final num temp, current, max, min;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(tooltipInfo: toolTip("Feels Like"), children: [
      Text("Feels Like", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      const Spacer(flex: 2),
      Text('$current°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
      Text("(${(current - temp).toStringAsFixed(2)}°C higher)", style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1.5)),
      const Spacer(flex: 3),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Today's Min: $min°C", style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1.5)),
        Text('Max: $max°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1))
      ])
    ]);
  }
}

class WindSpeed extends StatelessWidget {
  const WindSpeed(
      {Key? key,
      required this.value0,
      required this.direction0,
      required this.value10,
      required this.value80,
      required this.value120,
      required this.value180,
      required this.direction10,
      required this.direction80,
      required this.direction120,
      required this.direction180})
      : super(key: key);
  final num value0, value10, value80, value120, value180, direction0, direction10, direction80, direction120, direction180;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(tooltipInfo: toolTip("Wind"), children: [
      Text("Wind: $value0 KM/h", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      Row(children: [
        SizedBox(
            height: 110,
            width: 110,
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(width: 116, height: 116, child: SvgPicture.asset("assets/compass.svg")),
              Transform.rotate(
                  angle: (direction0 - 90) * ((2 * 3.1415926535897932) / 360),
                  child: Center(
                      child: Row(children: [
                    const Spacer(flex: 10),
                    Expanded(flex: 3, child: Container(height: 6, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white))),
                    const Spacer(flex: 2)
                  ]))),
              Text('${direction0.toInt().toString()}°', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
            ])),
        Expanded(
            child: Stack(alignment: Alignment.center, children: [
          Container(
              margin: const EdgeInsets.only(left: 6),
              height: 120,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(0), Colors.white.withOpacity(.1)]))),
          Column(
              children: [
            WindSpeedAtHeight(height: 0, speed: value0, direction: direction0),
            WindSpeedAtHeight(height: 10, speed: value10, direction: direction10),
            WindSpeedAtHeight(height: 80, speed: value80, direction: direction80),
            WindSpeedAtHeight(height: 120, speed: value120, direction: direction120),
            WindSpeedAtHeight(height: 180, speed: value180, direction: direction180)
          ].reversed.toList())
        ]))
      ])
    ]);
  }
}

class WindSpeedAtHeight extends StatelessWidget {
  const WindSpeedAtHeight({Key? key, required this.height, required this.speed, required this.direction}) : super(key: key);
  final num height, speed, direction;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 3, 0, 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Image.asset("assets/png/fog.png", height: 16),
          Expanded(child: Text("  ${height}m :", textScaleFactor: .9, style: TextStyle(color: Colors.white.withOpacity(.75)))),
          Text("$speed km/h ", textScaleFactor: .9),
          Transform.rotate(angle: direction * ((2 * 3.1415926535897932) / 360), child: const Icon(Icons.navigation_rounded, size: 16)),
          Text(" ${direction.toInt()}° ", textScaleFactor: .9)
        ]));
  }
}

class Others extends StatelessWidget {
  const Others({Key? key, required this.evapotranspiration, required this.surfacePressure, required this.snowDepth}) : super(key: key);
  final num evapotranspiration, surfacePressure, snowDepth;

  @override
  Widget build(BuildContext context) {
    return PaddedRow(children: [
      ContainerBox(
          horizontalPadding: 12,
          height: 168,
          tooltipInfo: toolTip("Evapotranspiration"),
          children: [OthersComponents(component: "Evapotrans\npiration", value: evapotranspiration)]),
      ContainerBox(
          horizontalPadding: 12, height: 168, tooltipInfo: toolTip("Surface Pressure"), children: [OthersComponents(component: "Surface\n Pressure", value: surfacePressure)]),
      ContainerBox(horizontalPadding: 12, height: 168, tooltipInfo: toolTip("Snow Depth"), children: [OthersComponents(component: "Snow\n Depth", value: snowDepth)]),
    ]);
  }
}

class OthersComponents extends StatelessWidget {
  const OthersComponents({Key? key, required this.component, required this.value}) : super(key: key);
  final String component;
  final num value;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 110,
            child: Column(children: [
              Image.asset("assets/png/${component.replaceAll("\n", "")}.png", height: 32, fit: BoxFit.fitWidth),
              const Spacer(flex: 2),
              Text(component, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 14, height: 1.2)),
              const Spacer(),
              Text(value.toString(), textAlign: TextAlign.end, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 24, height: 1))
            ])));
  }
}

class SolarRadiation extends StatelessWidget {
  const SolarRadiation(
      {Key? key, required this.shortWaveRad, required this.shortWaveRadSum, required this.directRad, required this.directNorIrr, required this.diffRad, required this.cape})
      : super(key: key);
  final num shortWaveRad, shortWaveRadSum, directRad, directNorIrr, diffRad, cape;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(height: 214, tooltipInfo: toolTip("Shortwave Solar Radiation"), children: [
      Text("Shortwave Solar Radiation", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      Row(children: [
        Stack(children: [
          Opacity(opacity: .15, child: Image.asset("assets/png/planet.png", width: 110, fit: BoxFit.fitWidth)),
          SizedBox(
              height: 124,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Spacer(flex: 2),
                Text('Current', style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1)),
                Text('$shortWaveRad', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
                const Spacer(flex: 2),
                Text("Today's Total", style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1.5)),
                Text('$shortWaveRadSum', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1)),
                const Spacer()
              ]))
        ]),
        Container(height: 100, width: 1, color: Colors.white, margin: const EdgeInsets.symmetric(horizontal: 12)),
        Expanded(
            child: SizedBox(
                height: 120,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  RadiationComponent(value: directRad, component: "Direct Radiation"),
                  const Divider(color: Colors.white, height: 2),
                  RadiationComponent(value: directNorIrr, component: "Direct Normal Irradiance"),
                  const Divider(color: Colors.white, height: 2),
                  RadiationComponent(value: diffRad, component: "Diffuse Radiation"),
                  const Divider(color: Colors.white, height: 2),
                  RadiationComponent(value: cape, component: "CAPE")
                ])))
      ])
    ]);
  }
}

class RadiationComponent extends StatelessWidget {
  const RadiationComponent({Key? key, required this.value, required this.component}) : super(key: key);
  final num value;
  final String component;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(child: Text(component, textScaleFactor: .8, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 16, height: 1.2))),
      const SizedBox(width: 12),
      Text('$value', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15, height: 1.2))
    ]);
  }
}

class SunLine extends StatelessWidget {
  const SunLine({Key? key, required this.sunrise, required this.size, required this.sunset}) : super(key: key);
  final String sunrise, sunset;
  final Size size;

  @override
  Widget build(BuildContext context) {
    Duration nowBetweenSunrise = DateTime.now().difference(DateTime.parse(sunrise));
    Duration nowBetweenSunset = DateTime.now().difference(DateTime.parse(sunset));
    int sunriseBetweenSunsetInSecond = (DateTime.parse(sunrise).difference(DateTime.parse(sunset))).inSeconds.abs();
    int nowBetweenSunriseInSecond = (DateTime.now().difference(DateTime.parse(sunrise))).inSeconds.abs();
    int nowBetweenSunsetInSecond = (DateTime.now().difference(DateTime.parse(sunset))).inSeconds.abs();

    return Stack(alignment: Alignment.bottomCenter, children: [
      ContainerBox(tooltipInfo: toolTip("Sun"), height: 190 + 16, width: size.width / 2 - 14, children: [
        Text(nowBetweenSunrise > const Duration(milliseconds: 0) ? "Sunset" : "Sunrise",
            style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
        const Spacer(flex: 3),
        Align(
            alignment: Alignment.center,
            child: Text(
                nowBetweenSunrise > const Duration(milliseconds: 0) ? DateFormat('hh:mm a').format(DateTime.parse(sunset)) : DateFormat('hh:mm a').format(DateTime.parse(sunrise)),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 17),
                textAlign: TextAlign.center)),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(nowBetweenSunset > const Duration(milliseconds: 0) ? "Next Sunset" : "Next Sunrise",
              style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 12, height: 1.5)),
          Text(nowBetweenSunset > const Duration(milliseconds: 0) ? DateFormat('hh:mm a').format(DateTime.parse(sunset)) : DateFormat('hh:mm a').format(DateTime.parse(sunrise)),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1))
        ])
      ]),
      SizedBox(
          height: 132,
          width: size.width / 2 - 32,
          child:
          SizedBox()
          // AnimatedRadialGauge(
          //     alignment: Alignment.topCenter,
          //     duration: const Duration(seconds: 3),
          //     curve: Curves.elasticOut,
          //     value: 0,
          //     progressBar: const GaugeRoundedProgressBar(color: Colors.transparent),
          //     axis: GaugeAxis(
          //         segments: nowBetweenSunrise > const Duration(milliseconds: 0)
          //             ? [GaugeSegment(from: nowBetweenSunriseInSecond.toDouble(), to: nowBetweenSunriseInSecond + (sunriseBetweenSunsetInSecond / 24), color: Colors.white)]
          //             : [GaugeSegment(from: nowBetweenSunsetInSecond.toDouble(), to: nowBetweenSunsetInSecond + (sunriseBetweenSunsetInSecond / 24), color: Colors.white)],
          //         min: 0,
          //         max: sunriseBetweenSunsetInSecond.toDouble() + (sunriseBetweenSunsetInSecond / 24),
          //         degrees: 120,
          //         style: GaugeAxisStyle(thickness: 6, background: Colors.white.withOpacity(.2)),
          //         pointer: NeedlePointer(size: const Size(16, 100), borderRadius: 16, backgroundColor: Colors.transparent)))
      )
    ]);
  }
}

class TemperaturePill extends StatelessWidget {
  const TemperaturePill({Key? key, required this.selected, required this.dateOrTime, required this.weatherCode, required this.avgTemp}) : super(key: key);
  final bool selected;
  final String dateOrTime;
  final int weatherCode;
  final double avgTemp;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: weatherCodeToStatus(weatherCode),
        child: Container(
            margin: const EdgeInsets.all(6).copyWith(bottom: 16),
            padding: const EdgeInsets.symmetric(vertical: 20),
            width: 72,
            height: 160,
            decoration: BoxDecoration(
                color: const Color(0xff48319D),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withOpacity(.2), width: 1, strokeAlign: BorderSide.strokeAlignOutside),
                gradient: selected
                    ? null
                    : LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                        const Color(0xff48319D).withOpacity(.1),
                        const Color(0xff48319D).withOpacity(.2),
                        const Color(0xff48319D).withOpacity(.2),
                        const Color(0xff48319D).withOpacity(.3)
                      ], stops: const [
                        0.1,
                        0.2,
                        0.8,
                        0.9
                      ]),
                boxShadow: [BoxShadow(color: const Color(0xff000000).withOpacity(.25), offset: const Offset(0, 10), spreadRadius: 0, blurRadius: 8)]),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(dateOrTime, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17)),
              SvgPicture.asset("assets/icons/${weatherCodeToStatus(weatherCode)}.svg", height: 48, fit: BoxFit.fitHeight),
              Text("${avgTemp.toStringAsFixed(1)}°", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1))
            ])));
  }
}

class TemperaturePillBlank extends StatelessWidget {
  const TemperaturePillBlank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(6).copyWith(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: 72,
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xff48319D),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(.2), width: 1, strokeAlign: BorderSide.strokeAlignOutside),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
              const Color(0xff48319D).withOpacity(.1),
              const Color(0xff48319D).withOpacity(.2),
              const Color(0xff48319D).withOpacity(.2),
              const Color(0xff48319D).withOpacity(.3)
            ], stops: const [
              0.1,
              0.2,
              0.8,
              0.9
            ]),
            boxShadow: [BoxShadow(color: const Color(0xff000000).withOpacity(.25), offset: const Offset(0, 10), spreadRadius: 0, blurRadius: 8)]),
        child: const CircularProgressIndicator());
  }
}

class CurrentWeather extends StatelessWidget {
  const CurrentWeather(
      {Key? key,
      required this.location,
      required this.weather,
      required this.temp,
      required this.maxTemp,
      required this.minTemp,
      required this.country,
      required this.time,
      required this.address})
      : super(key: key);
  final String location;
  final String country;
  final String address;
  final String weather;
  final String time;
  final double temp;
  final double maxTemp;
  final double minTemp;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color(0xff2D3259)),
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [const Color(0xff2E335A).withOpacity(.05), const Color(0xff1C1B33).withOpacity(.75)])),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Opacity(
                  opacity: .5,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: FadeInImage.assetNetwork(
                          placeholder: "assets/background.png", image: "https://source.unsplash.com/random/?${Uri.encodeFull('$country ${Random(1)}')}", fit: BoxFit.cover))),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(.25), Colors.black.withOpacity(0)]))),
              Column(children: [
                AppBar(backgroundColor: Colors.transparent),
                const Spacer(),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12), child: CurrentTemp(location: location, weather: weather, temp: temp, maxTemp: maxTemp, minTemp: minTemp)),
                Text("Last Updated on $time", style: TextStyle(color: Colors.white.withOpacity(.75), height: 2.5, fontWeight: FontWeight.w300, fontSize: 12)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child:
                        Text(address, style: TextStyle(color: Colors.white.withOpacity(.75), height: 1, fontWeight: FontWeight.w300, fontSize: 12), textAlign: TextAlign.center)),
                const Spacer(flex: 10)
              ])
            ])));
  }
}

class WeatherDetailPanel extends StatelessWidget {
  const WeatherDetailPanel(
      {Key? key,
      required this.onPanelCloseTap,
      required this.children,
      required this.hourly,
      required this.weekly,
      required this.controller,
      required this.pController,
      required this.tabController})
      : super(key: key);
  final VoidCallback onPanelCloseTap;
  final List<Widget> children;
  final List<Widget> hourly;
  final List<Widget> weekly;
  final ScrollController controller;
  final PanelController pController;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Stack(fit: StackFit.expand, children: [
          BackdropFilter(
              filter: ImageFilter.blur(tileMode: TileMode.repeated, sigmaX: 15, sigmaY: 15), child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(.1)))),
          Padding(
              padding: const EdgeInsets.only(top: 2.5),
              child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(tileMode: TileMode.repeated, sigmaX: 15, sigmaY: 15),
                      child: Container(decoration: BoxDecoration(color: const Color(0xff1b0f3b).withOpacity(.5)))))),
          Column(children: [
            InkWell(
                onTap: onPanelCloseTap,
                child: Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12))))),
            Expanded(
                child: ListView(controller: controller, shrinkWrap: true, padding: const EdgeInsets.only(bottom: 24), primary: false, children: [
              TabBar(
                  indicator: UnderlineTabIndicator(
                      borderSide: const BorderSide(strokeAlign: BorderSide.strokeAlignOutside, width: 1, color: Colors.white),
                      insets: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3.5)),
                  controller: tabController,
                  tabs: const [Padding(padding: EdgeInsets.only(bottom: 6), child: Text("Hourly")), Padding(padding: EdgeInsets.only(bottom: 6), child: Text("Weekly"))],
                  indicatorPadding: const EdgeInsets.all(24).copyWith(bottom: 0)),
              SizedBox(
                  height: 190,
                  child: TabBarView(controller: tabController, children: [
                    SingleChildScrollView(padding: const EdgeInsets.all(16).copyWith(bottom: 0), scrollDirection: Axis.horizontal, child: Row(children: hourly)),
                    SingleChildScrollView(padding: const EdgeInsets.all(16).copyWith(bottom: 0), scrollDirection: Axis.horizontal, child: Row(children: weekly)),
                  ])),...children]))])]));
}}

class Footer extends StatelessWidget {
  const Footer({Key? key, required this.time}) : super(key: key);
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text("Last Updated on $time",
              style: TextStyle(color: Colors.white.withOpacity(.75), height: 2.5, fontWeight: FontWeight.w300, fontSize: 12), textAlign: TextAlign.center)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 12), child: Divider(height: 4, color: Colors.white.withOpacity(.5))),
      Text("Data Source", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17), textAlign: TextAlign.center),
      const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
              "ERA5 (Global), ERA5-Land (Global), CERRA(Europe), National Weather Service, Weather Underground, The Weather Channel, AccuWeather, DarkSky, WeatherBug, Weatherspark, OpenWeatherMap,"
              "Google Weather, Google Earth Engine, Weatherbit, Open-Meteo Historical Weather and Google Earth Engine",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.5))),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text("© weather.ai | created with ❤️ by S.a. Sadik",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(.75), fontWeight: FontWeight.w400, fontSize: 13, height: 1)))
    ]);
  }
}
