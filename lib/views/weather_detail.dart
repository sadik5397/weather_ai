import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WeatherDetail extends StatefulWidget {
  const WeatherDetail({Key? key, required this.controller, required this.pController}) : super(key: key);
  final ScrollController controller;
  final PanelController pController;

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> with SingleTickerProviderStateMixin {
  togglePanel() => widget.pController.isPanelOpen ? widget.pController.close() : widget.pController.open();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(filter: ImageFilter.blur(tileMode: TileMode.repeated, sigmaX: 15, sigmaY: 15), child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(.1)))),
          Padding(
              padding: const EdgeInsets.only(top: 2.5),
              child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(tileMode: TileMode.repeated, sigmaX: 15, sigmaY: 15), child: Container(decoration: BoxDecoration(color: const Color(0xff1b0f3b).withOpacity(.5)))))),
          Column(
            // shrinkWrap: true,
            // controller: widget.controller,
            children: [
              InkWell(
                  onTap: togglePanel,
                  child: Center(
                      child: Container(margin: const EdgeInsets.symmetric(vertical: 16), width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12))))),
              TabBar(controller: tabController, tabs: const [Text("Hourly"), Text("Weekly")], indicatorPadding: const EdgeInsets.all(24).copyWith(bottom: 0)),
              Expanded(
                  child: TabBarView(controller: tabController, children: [
                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: List.generate(24, (index) => pill(selected: index == 3)))),
                FlutterLogo(),
              ])),
            ],
          ),
        ],
      ),
    );
  }

  Material pill({required bool selected}) {
    return Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(6).copyWith(bottom: 20),
          child: InkWell(
              splashColor: Colors.black.withOpacity(.25),
              borderRadius: BorderRadius.circular(30),
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("12 AM", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
                      FlutterLogo(),
                      Text("19°", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20, height: 1)),
                    ],
                  ),
                  width: 60,
                  height: 146,
                  decoration: BoxDecoration(
                      color: Color(0xff48319D),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(.2), width: 1, strokeAlign: StrokeAlign.inside),
                      gradient: selected
                          ? null
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [const Color(0xff48319D).withOpacity(.1), const Color(0xff48319D).withOpacity(.2), const Color(0xff48319D).withOpacity(.2), const Color(0xff48319D).withOpacity(.3)],
                              stops: const [0.1, 0.2, 0.8, 0.9]),
                      boxShadow: [BoxShadow(color: const Color(0xff000000).withOpacity(.25), offset: const Offset(0, 10), spreadRadius: 0, blurRadius: 8)]))),
        ));
  }
}
