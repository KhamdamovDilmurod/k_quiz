import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/pref_utils.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final PrefUtils _prefUtils;

  ThemeCubit(this._prefUtils) : super(const ThemeState(ThemeMode.system));

  void loadTheme() {
    emit(ThemeState(_prefUtils.getThemeMode()));
  }

  Future<void> changeTheme(ThemeMode mode) async {
    if (state.themeMode == mode) return;
    await _prefUtils.setThemeMode(mode);
    emit(ThemeState(mode));
  }
}
