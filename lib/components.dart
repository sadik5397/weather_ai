import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Future<dynamic> route(BuildContext context, Widget widget) => Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

dynamic routeBack(BuildContext context) => Navigator.pop(context);

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
      Text(weather, style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w400), textAlign: TextAlign.center),
      Text("High: $maxTemp°  |  Low: $minTemp°", style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400, height: 1.25), textAlign: TextAlign.center)
    ]);
  }
}

class ContainerBox extends StatelessWidget {
  const ContainerBox({Key? key, required this.children, this.width, this.onTap, this.height}) : super(key: key);
  final List<Widget> children;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Material(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                    splashColor: Colors.black.withOpacity(.25),
                    borderRadius: BorderRadius.circular(16),
                    onTap: onTap,
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        width: width == null ? null : width! - 16,
                        height: height == null ? 190 : height! - 16,
                        decoration: BoxDecoration(
                            color: const Color(0xff2D2258).withOpacity(.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(.2), width: 1, strokeAlign: StrokeAlign.inside)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children))))));
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
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xff3759B1), Color(0xffE74395)]))),
      Row(children: [Spacer(flex: value), const CircleAvatar(radius: 7, backgroundColor: Colors.white), Spacer(flex: maxValue - value + 1)])
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
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [const FlutterLogo(size: 94), const SizedBox(height: 16), Text(weather, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 17, height: 1))])
                  ]))
            ])));
  }
}

class AirQuality extends StatelessWidget {
  const AirQuality({Key? key, required this.value, required this.status}) : super(key: key);
  final int value;
  final String status;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(children: [
      Text("Air Quality", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      const Spacer(flex: 2),
      Text(value.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
      Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 22)),
      const Spacer(flex: 2),
      ColorfulIndicatorBar(value: value, maxValue: 10),
      const Spacer()
    ]);
  }
}

class UvIndex extends StatelessWidget {
  const UvIndex({Key? key, required this.value, required this.status}) : super(key: key);
  final int value;
  final String status;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(children: [
      Text("UV Index", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      const Spacer(flex: 2),
      Text(value.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
      Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 22)),
      const Spacer(flex: 2),
      ColorfulIndicatorBar(value: value, maxValue: 10),
      const Spacer()
    ]);
  }
}

class WindSpeed extends StatelessWidget {
  const WindSpeed({Key? key, required this.value, required this.direction, required this.status}) : super(key: key);
  final double value;
  final double direction;
  final String status;

  @override
  Widget build(BuildContext context) {
    return ContainerBox(children: [
      Text("Wind: $value KM/h", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      Center(
          child: SizedBox(
              height: 110,
              width: 110,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(width: 116, height: 116, child: CircularProgressIndicator(value: 1, strokeWidth: 2, color: Colors.white.withOpacity(.5))),
                Transform.rotate(
                    angle: (direction - 90) * ((2 * 3.1415926535897932) / 360),
                    child: Center(
                        child: Row(children: [
                      const Spacer(flex: 8),
                      Expanded(flex: 3, child: Container(height: 6, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white))),
                      const Spacer()
                    ]))),
                Text(direction.toInt().toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
              ])))
    ]);
  }
}

class SunLine extends StatelessWidget {
  const SunLine({Key? key, required this.status, required this.size, required this.value}) : super(key: key);
  final String status;
  final Size size;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      ContainerBox(height: 190 + 16, width: size.width / 2 - 12, children: [
        Text("Sunrise", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
        const Spacer(flex: 3),
        const Align(alignment: Alignment.center, child: Text("04:12 AM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 17), textAlign: TextAlign.center)),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Sunset", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 1.5)),
          Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1))
        ])
      ]),
      SizedBox(
          height: 132,
          width: size.width / 2 - 32,
          child: AnimatedRadialGauge(
              alignment: Alignment.topCenter,
              duration: const Duration(seconds: 3),
              curve: Curves.elasticOut,
              value: 0,
              progressBar: const GaugeRoundedProgressBar(color: Colors.transparent),
              axis: GaugeAxis(
                  segments: [GaugeSegment(from: value.toDouble(), to: value + 3, color: Colors.white)],
                  min: 0,
                  max: 103,
                  degrees: 120,
                  style: GaugeAxisStyle(thickness: 6, background: Colors.white.withOpacity(.2)),
                  pointer: NeedlePointer(size: const Size(16, 100), borderRadius: 16, backgroundColor: Colors.transparent))))
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
    return Material(
        color: Colors.transparent,
        child: Padding(
            padding: const EdgeInsets.all(6).copyWith(bottom: 16),
            child: InkWell(
                splashColor: Colors.black.withOpacity(.25),
                borderRadius: BorderRadius.circular(40),
                onTap: () {},
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    width: 72,
                    height: 160,
                    decoration: BoxDecoration(
                        color: const Color(0xff48319D),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white.withOpacity(.2), width: 1, strokeAlign: StrokeAlign.inside),
                        gradient: selected
                            ? null
                            : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [const Color(0xff48319D).withOpacity(.1), const Color(0xff48319D).withOpacity(.2), const Color(0xff48319D).withOpacity(.2), const Color(0xff48319D).withOpacity(.3)],
                                stops: const [0.1, 0.2, 0.8, 0.9]),
                        boxShadow: [BoxShadow(color: const Color(0xff000000).withOpacity(.25), offset: const Offset(0, 10), spreadRadius: 0, blurRadius: 8)]),
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(dateOrTime, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17)),
                      const FlutterLogo(),
                      Text("${avgTemp.toStringAsFixed(1)}°", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1))
                    ])))));
  }
}

class CurrentWeather extends StatelessWidget {
  const CurrentWeather(
      {Key? key, required this.location, required this.weather, required this.temp, required this.maxTemp, required this.minTemp, required this.country, required this.time, required this.address})
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
            decoration:
                BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [const Color(0xff2E335A).withOpacity(.05), const Color(0xff1C1B33).withOpacity(.75)])),
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Opacity(
                  opacity: .5,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: FadeInImage.assetNetwork(placeholder: "assets/background.png", image: "https://source.unsplash.com/random/?${Uri.encodeFull('$country ${Random(1)}')}", fit: BoxFit.cover))),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withOpacity(.25), Colors.black.withOpacity(0)]))),
              Column(children: [
                AppBar(backgroundColor: Colors.transparent),
                const Spacer(),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: CurrentTemp(location: location, weather: weather, temp: temp, maxTemp: maxTemp, minTemp: minTemp)),
                Text("Last Updated on $time", style: TextStyle(color: Colors.white.withOpacity(.75), height: 2.5, fontWeight: FontWeight.w300, fontSize: 12)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(address, style: TextStyle(color: Colors.white.withOpacity(.75), height: 1, fontWeight: FontWeight.w300, fontSize: 12), textAlign: TextAlign.center)),
                const Spacer(flex: 10)
              ])
            ])));
  }
}

class WeatherDetailPanel extends StatelessWidget {
  const WeatherDetailPanel(
      {Key? key, required this.onPanelCloseTap, required this.children, required this.hourly, required this.weekly, required this.controller, required this.pController, required this.tabController})
      : super(key: key);
  final VoidCallback onPanelCloseTap;
  final List<Widget> children;
  final List<TemperaturePill> hourly;
  final List<TemperaturePill> weekly;
  final ScrollController controller;
  final PanelController pController;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Stack(fit: StackFit.expand, children: [
          BackdropFilter(filter: ImageFilter.blur(tileMode: TileMode.repeated, sigmaX: 15, sigmaY: 15), child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(.1)))),
          Padding(
              padding: const EdgeInsets.only(top: 2.5),
              child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(tileMode: TileMode.repeated, sigmaX: 15, sigmaY: 15), child: Container(decoration: BoxDecoration(color: const Color(0xff1b0f3b).withOpacity(.5)))))),
          Column(children: [
            InkWell(
                onTap: onPanelCloseTap,
                child: Center(
                    child: Container(margin: const EdgeInsets.symmetric(vertical: 16), width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12))))),
            Expanded(
                child: ListView(controller: controller, shrinkWrap: true, padding: const EdgeInsets.only(bottom: 24), primary: false, children: [
              TabBar(
                  indicator: UnderlineTabIndicator(
                      borderSide: const BorderSide(strokeAlign: StrokeAlign.outside, width: 1, color: Colors.white), insets: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3.5)),
                  controller: tabController,
                  tabs: const [Padding(padding: EdgeInsets.only(bottom: 6), child: Text("Hourly")), Padding(padding: EdgeInsets.only(bottom: 6), child: Text("Weekly"))],
                  indicatorPadding: const EdgeInsets.all(24).copyWith(bottom: 0)),
              SizedBox(
                  height: 190,
                  child: TabBarView(controller: tabController, children: [
                    SingleChildScrollView(padding: const EdgeInsets.all(16).copyWith(bottom: 0), scrollDirection: Axis.horizontal, child: Row(children: hourly)),
                    SingleChildScrollView(padding: const EdgeInsets.all(16).copyWith(bottom: 0), scrollDirection: Axis.horizontal, child: Row(children: weekly)),
                  ])),
              ...children,
            ]))
          ])
        ]));
  }
}
