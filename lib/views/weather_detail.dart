import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WeatherDetail extends StatefulWidget {
  const WeatherDetail({Key? key, required this.controller, required this.pController}) : super(key: key);
  final ScrollController controller;
  final PanelController pController;

  @override
  State<WeatherDetail> createState() => _WeatherDetailState();
}

class _WeatherDetailState extends State<WeatherDetail> {
  togglePanel() => widget.pController.isPanelOpen ? widget.pController.close() : widget.pController.open();

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      children: [InkWell(
        onTap: togglePanel,
        child: Center(
          child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12))),
        ),
      )],
    );
  }
}

