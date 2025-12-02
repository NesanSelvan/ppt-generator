import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppConfig {
  AppConfig._();

  static Map<String, dynamic>? _config;

  static Future<void> load() async {
    if (_config != null) return;

    const filePath = String.fromEnvironment('APP_CONFIG_FILE');
    log("file path $filePath");
    String? payload;
    if (filePath.isNotEmpty) {
      try {
        try {
          payload = await rootBundle.loadString(filePath);
        } catch (assetError) {
          if (File(filePath).existsSync()) {
            payload = File(filePath).readAsStringSync();
          } else {
            rethrow;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('APP_CONFIG_FILE read error: $e');
        }
        payload = null;
      }
    }
    if (payload == null || payload.isEmpty) {
      _config = null;
      return;
    }
    try {
      final parsed = json.decode(payload);
      if (parsed is Map<String, dynamic>) {
        _config = parsed;
      } else {
        _config = null;
      }
    } catch (_) {
      if (kDebugMode) {
        print('APP_CONFIG payload exists but failed to parse as JSON');
      }
      _config = null;
    }
  }

  static bool get isLoaded => _config != null;

  static Map<String, dynamic> get all => _config ?? const <String, dynamic>{};

  static dynamic get(String key) {
    return _config?[key];
  }

  static String? getString(String key) {
    final v = get(key);
    if (v == null) return null;
    return v is String ? v : v.toString();
  }
}
