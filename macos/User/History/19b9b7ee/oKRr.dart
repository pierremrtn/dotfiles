import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:unusable_player/unusable_player.dart' as up;

enum _Theme {
  light,
  dark,
}

class ThemeService extends GetxService with Translations {
  static ThemeService get instance => Get.find<ThemeService>();

  late final Box<_Theme> _cache;

  Future<ThemeService> init() async {
    _cache = await Hive.openBox('testBox');
    return this;
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        // 'fr_FR': frFR,
      };
}