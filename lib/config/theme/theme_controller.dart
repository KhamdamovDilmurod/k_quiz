import 'package:flutter/material.dart';
import '../../utils/pref_utils.dart';

class ThemeController extends ChangeNotifier {
  final PrefUtils _prefUtils;

  ThemeController(this._prefUtils);

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    _themeMode = _prefUtils.getThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _prefUtils.setThemeMode(mode);
    notifyListeners();
  }
}
