import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', theme);
  }

  Future<Color> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('selectedTheme');
    if (theme == 'white') return Color.fromARGB(255, 255, 255, 255);
    if (theme == 'grey') return const Color.fromARGB(255, 25, 25, 25);
    if (theme == 'red') return Colors.red;
    return const Color.fromARGB(255, 138, 178, 246); // default
  }
}
