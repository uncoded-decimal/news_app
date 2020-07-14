import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    accentColor: Colors.amber[800],
  );
}