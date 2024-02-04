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
    return const Scaffold(
      body: TajweedViewer(),
    );
  }
}
