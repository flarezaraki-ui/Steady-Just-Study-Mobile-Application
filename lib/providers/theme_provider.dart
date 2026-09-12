import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/theme_service.dart';

final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService();
});

final themeProvider = StateNotifierProvider<ThemeController, Color>((ref) {
  final service = ref.read(themeServiceProvider);
  return ThemeController(service);
});

class ThemeController extends StateNotifier<Color> {
  final ThemeService service;

  ThemeController(this.service) : super(Color.fromARGB(255, 213, 225, 246)) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    state = await service.getTheme();
  }

  Future<void> setTheme(Color color, String name) async {
    state = color;
    await service.setTheme(name);
  }
}
