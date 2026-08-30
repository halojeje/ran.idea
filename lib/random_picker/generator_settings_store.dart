import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'generator_settings.dart';

/// Reads/writes [GeneratorSettings] to local storage.
///
/// Kept separate from PreferenceHelper (login session / profile) on purpose:
/// generator config and user session are different concerns and shouldn't
/// share one key namespace.
class GeneratorSettingsStore {
  static const String _key = 'generator_settings_v1';

  static Future<void> save(GeneratorSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toMap()));
  }

  static Future<GeneratorSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return GeneratorSettings.defaults;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return GeneratorSettings.fromMap(map);
    } catch (_) {
      // Corrupted/old-format value: fall back to defaults instead of crashing.
      return GeneratorSettings.defaults;
    }
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
