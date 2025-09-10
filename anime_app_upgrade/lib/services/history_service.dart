import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryService extends ChangeNotifier {
  static const key = 'watch_history_v1';
  SharedPreferences? _pref;
  Map<String, dynamic> _history = {};

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    final raw = _pref?.getString(key);
    if (raw != null) {
      _history = json.decode(raw);
    }
  }

  Map<String, dynamic> get history => Map.unmodifiable(_history);

  double getPosition(String slug) {
    final v = _history[slug];
    if (v == null) return 0.0;
    return (v['pos'] ?? 0).toDouble();
  }

  Future<void> savePosition(String slug, double pos, {String? episode}) async {
    _history[slug] = {'pos': pos, 'episode': episode ?? ''};
    await _pref?.setString(key, json.encode(_history));
    notifyListeners();
  }

  Future<void> clear(String slug) async {
    _history.remove(slug);
    await _pref?.setString(key, json.encode(_history));
    notifyListeners();
  }
}
