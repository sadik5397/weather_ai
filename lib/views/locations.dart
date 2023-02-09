import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff2E335A), Color(0xff1C1B33)])),
      child: Scaffold(
          appBar: AppBar(title: const Text("Locations"), foregroundColor: Colors.white, backgroundColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          body: ListView(children: [
            SingleChildScrollView(padding: const EdgeInsets.all(16).copyWith(bottom: 0), scrollDirection: Axis.horizontal, child: Row(children: List.generate(24, (index) => pill(selected: index == 3)))),

            SvgPicture.asset("assets/trapisium_tile.svg"),
            FlutterLogo(),

            PaddedRow(children: [airQuality(value: 7, status: "Airing")]),
            PaddedRow(children: [
              uvIndex(status: "Better", value: 2),
              sunLine(status: "06:47 PM", value: 100, size: size),
            ]),
            PaddedRow(children: [
              windSpeed(status: "Better", value: 2, direction: 0),
              sunLine(status: "06:47 PM", value: 100, size: size),
            ]),
          ])),
    );
  }

  Material pill({required bool selected}) {
    return Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(6).copyWith(bottom: 24),
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
                              begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xff48319D).withOpacity(.1), const Color(0xff48319D).withOpacity(.2), const Color(0xff48319D).withOpacity(.2), const Color(0xff48319D).withOpacity(.3)], stops: const [0.1, 0.2, 0.8, 0.9]),
                      boxShadow: [BoxShadow(color: const Color(0xff000000).withOpacity(.25), offset: const Offset(0, 10), spreadRadius: 0, blurRadius: 8)]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("12 AM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17)),
                      FlutterLogo(),
                      Text("19°", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1)),
                    ],
                  ))),
        ));
  }

  ContainerBox airQuality({required int value, required String status}) {
    return ContainerBox(children: [
      Text("Air Quality", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      const Spacer(flex: 2),
      Text(value.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
      Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22)),
      const Spacer(flex: 2),
      ColorfulIndicatorBar(value: value, maxValue: 10),
      const Spacer()
    ]);
  }

  ContainerBox uvIndex({required int value, required String status}) {
    return ContainerBox(children: [
      Text("UV Index", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      const Spacer(flex: 2),
      Text(value.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 42, height: 1)),
      Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22)),
      const Spacer(flex: 2),
      ColorfulIndicatorBar(value: value, maxValue: 10),
      const Spacer()
    ]);
  }

  Stack sunLine({required String status, required Size size, required int value}) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      ContainerBox(height: 190 + 16, width: size.width / 2 - 12, children: [
        Text("Sunrise", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
        const Spacer(flex: 3),
        const Align(alignment: Alignment.center, child: Text("04:12 AM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17), textAlign: TextAlign.center)),
        const Spacer(),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Sunset", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12, height: 2)), Text(status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 22, height: 1))])
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

  ContainerBox windSpeed({required double value, required double direction, required String status}) {
    return ContainerBox(children: [
      Text("Wind: $value KM/h", style: TextStyle(color: Colors.white.withOpacity(.6), fontWeight: FontWeight.w500, fontSize: 17)),
      Center(
          child: SizedBox(
              height: 110,
              width: 110,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(width: 116, height: 116, child: CircularProgressIndicator(value: 1, strokeWidth: 2, color: Colors.white.withOpacity(.5))),
                Transform.rotate(
                    angle: (direction - 90) * ((2 * 3.1415926535897932) / 360), child: Center(child: Row(children: [const Spacer(flex: 8), Expanded(flex: 3, child: Container(height: 6, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white))), const Spacer()]))),
                Text(direction.toInt().toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))
              ])))
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
                        decoration: BoxDecoration(color: const Color(0xff2D2258).withOpacity(.5), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(.2), width: 1, strokeAlign: StrokeAlign.inside)),
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
      Container(height: 6, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xff3759B1), Color(0xffE74395)]))),
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
