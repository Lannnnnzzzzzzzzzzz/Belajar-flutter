import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteService extends ChangeNotifier {
  static const key = 'favorites_v1';
  SharedPreferences? _pref;
  List<String> _favorites = [];

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    _favorites = _pref?.getStringList(key) ?? [];
  }

  List<String> get favorites => List.unmodifiable(_favorites);

  bool isFav(String slug) => _favorites.contains(slug);

  Future<void> toggle(String slug) async {
    if (_favorites.contains(slug)) {
      _favorites.remove(slug);
    } else {
      _favorites.add(slug);
    }
    await _pref?.setStringList(key, _favorites);
    notifyListeners();
  }
}
