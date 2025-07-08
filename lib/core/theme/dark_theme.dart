import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.deepPurpleAccent,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.deepPurpleAccent,
    unselectedItemColor: Colors.grey,
  ),
);
