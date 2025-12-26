import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                  leading: const ThemeSwitcherButton(),
                  actionsPadding: const EdgeInsets.only(right: 8),
                  actions: [
                    AuthorPopupMenuButton(
                      links: [
                        SocialLinkData(
                          label: 'Remanga автора',
                          url: EnvConfig.authorRemanga,
                          icon: SvgPicture.asset(
                            'assets/svgs/yin-yang.svg',
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SocialLinkData(
                          label: 'Репозиторий',
                          url: EnvConfig.githubRepo,
                          icon: SvgPicture.asset(
                            'assets/svgs/github.svg',
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SliverToBoxAdapter(
                  child: PackCoverCarousel(),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    spacing: 5,
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
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: PackSliverGrid(pack: state.packData),
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
