import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../data/models/settings_state.dart';

/// Cubit for managing application settings.
class SettingsCubit extends HydratedCubit<SettingsState> {
  /// Creates a new instance of [SettingsCubit].
  SettingsCubit() : super(const SettingsState());

  /// Toggles the theme mode between light and dark.
  void toggleTheme() {
    final isDark = state.themeMode == ThemeMode.dark;
    emit(
      state.copyWith(
        themeMode: isDark ? ThemeMode.light : ThemeMode.dark,
      ),
    );
  }

  /// Sets the theme mode to the specified [mode].
  void setTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      return SettingsState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }
}
