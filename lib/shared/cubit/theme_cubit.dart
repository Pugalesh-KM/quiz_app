
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _boxName = 'settings';
  static const _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_boxName);
    final saved = box.get(_themeKey, defaultValue: 'system');
    emit(_stringToThemeMode(saved));
  }

  Future<void> setTheme(ThemeMode mode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_themeKey, _themeModeToString(mode));
    emit(mode);
  }

  ThemeMode _stringToThemeMode(String value) {
    switch (value) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'light';
      case ThemeMode.dark: return 'dark';
      default: return 'system';
    }
  }
}
