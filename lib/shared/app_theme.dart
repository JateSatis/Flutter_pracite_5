import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.green,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.green, foregroundColor: Colors.white),
  );
}