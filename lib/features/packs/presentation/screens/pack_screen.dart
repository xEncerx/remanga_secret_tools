import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../settings/settings.dart';
import '../presentation.dart';

/// Screen displaying pack details.
@RoutePage()
class PackScreen extends StatelessWidget implements AutoRouteWrapper {
  /// Creates a [PackScreen] widget.
  const PackScreen({
    super.key,
    @PathParam('packId') this.packId = 10,
  });

  /// The ID of the pack to display.
  final int packId;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<PackBloc>(
      key: ValueKey('PackBloc-$packId'),
      create: (context) => PackBloc()..add(FetchPackLoopEvent(packId: packId)),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<PackBloc, PackState>(
        builder: (context, state) {
          if (state is PackFailureState) {
            return ShowInfoWidget.error(
              title: 'Ошибка загрузки пака',
              description: state.exception.detail,
            );
          }
          if (state is PackLoadedState) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      state.packData.name,
                      style: theme.textTheme.headlineSmall.bold,
                    ),
                  ),
                  leadingWidth: 120,
                  leading: const Row(
                    children: [
                      LinkSvgCircleButton(
                        url: EnvConfig.authorRemanga,
                        svgAssetPath: 'assets/svgs/yin-yang.svg',
                        tooltip: 'Remanga автора',
                      ),
                      LinkSvgCircleButton(
                        url: EnvConfig.githubRepo,
                        svgAssetPath: 'assets/svgs/github.svg',
                        tooltip: 'Репозиторий на GitHub',
                      ),
                    ],
                  ),
                  actionsPadding: const EdgeInsets.only(right: 8),
                  actions: const [
                    ThemeSwitcherButton(),
                  ],
                ),
                SliverToBoxAdapter(
                  child: PackCoverCarousel(packCover: state.packData.cover.url ?? ''),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        flex: 3,
                        child: PackArrowShape(
                          angle: pi,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: PackBuyButton(
                          packId: packId,
                          cost: state.packData.cost,
                        ),
                      ),
                      const Flexible(
                        flex: 3,
                        child: PackArrowShape(),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Text('Содержимое пака', style: theme.textTheme.titleMedium.semiBold),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 40),
                  sliver: PackSliverGrid(cards: state.packData.cards),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
