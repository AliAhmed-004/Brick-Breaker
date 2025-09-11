import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelProvider extends ChangeNotifier {
  int _level = 1;

  int get level => _level;

  LevelProvider() {
    loadLevel();
  }

  // LOAD LEVEL FROM SHARED PREFERENCES
  void loadLevel() async {
    final prefs = await SharedPreferences.getInstance();
    _level = prefs.getInt("currentLevel") ?? 1;
    notifyListeners();
  }

  // increment level
  void incrementLevel() async {
    _level++;
    notifyListeners();

    // Update current level in shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentLevel', _level);
  }
}
