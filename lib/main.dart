import 'package:flutter/material.dart';
import 'views/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: 'Weather AI', theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue, fontFamily: "Kanit", useMaterial3: true), home: const Home());
  }
}
