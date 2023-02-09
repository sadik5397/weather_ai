import 'package:flutter/material.dart';
import 'package:weather_ai/views/locations.dart';
import 'views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather AI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // fontFamily: "Kanit",
          useMaterial3: true,
        ),
        // home: const Home());
        home: const Home());
  }
}
