import 'package:flutter/material.dart';
import '../components.dart';

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
            appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: const Text("Weather"),
                centerTitle: true,
                foregroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                actions: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: IconButton(onPressed: () => routeBack(context), icon: const Icon(Icons.cancel_outlined), padding: const EdgeInsets.symmetric(horizontal: 12)))
                ]),
            backgroundColor: Colors.transparent,
            body: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: List.generate(
                    10,
                    (index) => LocationTile(
                        location: "Dhaka", weather: "index*9", temp: index * 9, time: DateTime.now().add(Duration(days: index)).toString().split(" ")[1], size: size, onTap: (){})))));
  }
}
