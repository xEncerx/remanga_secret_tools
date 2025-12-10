import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart' show Key;

import '../../features/features.dart';

part 'app_router.gr.dart';

/// Application router configuration.
///
/// Defines all navigation routes for the application.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    RedirectRoute(path: '/', redirectTo: '/packs/10'),
    AutoRoute(
      page: PackRoute.page,
      path: '/packs/:packId',
      initial: true,
    ),
    AutoRoute(
      page: NotFoundRoute.page,
      path: '*',
    ),
  ];

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
}
