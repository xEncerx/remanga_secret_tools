import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/core.dart';
import 'features/settings/settings.dart';
import 'shared/shared.dart';

/// Entry point of the application.
///
/// This widget serves as the root of the widget tree.
class MainApp extends StatelessWidget {
  /// Creates a [MainApp] widget.
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.themeMode != current.themeMode,
        builder: (context, state) => MaterialApp.router(
          title: 'Oreshki',
          themeMode: state.themeMode,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          routerConfig: getIt<AppRouter>().config(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
