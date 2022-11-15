import 'package:flutter/material.dart';
import 'package:tajweed/tajweed_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tajweed example',
      theme: ThemeData(
        brightness: Brightness.light,
        //scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 120, 218, 123),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const TajweedExample(),
    );
  }
}

class TajweedExample extends StatelessWidget {
  const TajweedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const TajweedViewer();
  }
}
