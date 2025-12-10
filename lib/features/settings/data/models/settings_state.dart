import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';
part 'settings_state.g.dart';

/// Represents the state of the settings feature.
@freezed
abstract class SettingsState with _$SettingsState {
  /// Creates a new instance of [SettingsState].
  const factory SettingsState({
    /// The current theme mode of the application.
    @Default(ThemeMode.dark) ThemeMode themeMode,
  }) = _SettingsState;

  /// Creates a [SettingsState] from a JSON map.
  factory SettingsState.fromJson(Map<String, dynamic> json) => _$SettingsStateFromJson(json);
}
