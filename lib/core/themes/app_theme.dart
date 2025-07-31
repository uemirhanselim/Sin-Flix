import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Euclid',
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent, brightness: Brightness.dark),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Euclid',
  );
} 