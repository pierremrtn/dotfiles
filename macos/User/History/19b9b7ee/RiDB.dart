import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:unusable_player/unusable_player.dart' as up;

const String _kIsLightModeKey = "lightTheme";

class ThemeService extends GetxService {
  static ThemeService get instance => Get.find<ThemeService>();

  late final Box<bool> _cache;

  Future<ThemeService> init() async {
    _cache = await Hive.openBox('theme_mode');
    return this;
  }

  ThemeMode get themeMode {
    final isLightThemeMode = _cache.get(_kIsLightModeKey) ?? true;
    if (isLightThemeMode) {
      return ThemeMode.light;
    } else {
      return ThemeMode.light;
    }
  }

  enableDarkTheme() async {
    await _cache.put(_kIsLightModeKey, false);
    Get.changeThemeMode(ThemeMode.dark);
  }

  enableLightTheme() async {
    await _cache.put(_kIsLightModeKey, true);
    Get.changeThemeMode(ThemeMode.light);
  }
}
