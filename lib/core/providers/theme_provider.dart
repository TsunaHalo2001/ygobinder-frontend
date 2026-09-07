import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ygobinder/core/database/database_provider.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final db = ref.read(databaseProvider);
    final setting = await db.getSetting('app_theme_mode');
    if (setting != null) {
      if (setting == 'LIGHT') {
        state = ThemeMode.light;
      } else if (setting == 'DARK') {
        state = ThemeMode.dark;
      } else if (setting == 'SYSTEM') {
        state = ThemeMode.system;
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final db = ref.read(databaseProvider);
    String val = 'SYSTEM';
    if (mode == ThemeMode.light) val = 'LIGHT';
    if (mode == ThemeMode.dark) val = 'DARK';
    await db.saveSetting('app_theme_mode', val);
  }
}
