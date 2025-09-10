import 'package:flutter/material.dart';

class LevelProvider extends ChangeNotifier {
  int _level = 1;

  int get level => _level;

  // increment level
  void incrementLevel() {
    _level++;
    notifyListeners();
  }
}
