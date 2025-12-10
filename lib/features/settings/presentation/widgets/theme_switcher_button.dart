import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_cubit.dart';

/// A button to toggle between light and dark themes.
class ThemeSwitcherButton extends StatelessWidget {
  /// Creates a [ThemeSwitcherButton] widget.
  const ThemeSwitcherButton({
    super.key,
    this.iconSize = 28.0,
  });

  /// The size of the icon displayed in the button.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final isDark = context.select(
      (SettingsCubit cubit) => cubit.state.themeMode == ThemeMode.dark,
    );

    return IconButton(
      iconSize: iconSize,
      onPressed: () {
        context.read<SettingsCubit>().toggleTheme();
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => RotationTransition(
          turns: child.key == const ValueKey('dark')
              ? Tween<double>(begin: 1, end: 0.75).animate(anim)
              : Tween<double>(begin: 0.75, end: 1).animate(anim),
          child: ScaleTransition(scale: anim, child: child),
        ),
        child: isDark
            ? const Icon(
                Icons.light_mode_rounded,
                key: ValueKey('dark'),
              )
            : const Icon(
                Icons.dark_mode_rounded,
                key: ValueKey('light'),
              ),
      ),
      tooltip: isDark ? 'Светлая тема' : 'Темная тема',
    );
  }
}
