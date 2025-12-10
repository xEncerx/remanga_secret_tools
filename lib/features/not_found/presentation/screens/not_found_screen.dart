import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../shared/shared.dart';

/// Screen displayed when a requested route is not found.
@RoutePage()
class NotFoundScreen extends StatelessWidget {
  /// Creates a [NotFoundScreen] widget.
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ShowInfoWidget.warning(
        title: 'Страница не найдена',
        description: 'Такой страницы пока не существует...',
      ),
    );
  }
}
