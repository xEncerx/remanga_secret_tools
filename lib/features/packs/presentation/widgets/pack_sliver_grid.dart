import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../features.dart';

/// A grid view displaying a list of pack cards.
class PackSliverGrid extends StatelessWidget {
  /// Creates a [PackSliverGrid] widget.
  const PackSliverGrid({super.key, required this.pack});

  /// Pack data containing the cards to display.
  final PackDTO pack;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 3,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: pack.cards.length,
        (context, index) {
          final card = pack.cards[index];
          final cardRankCount = (pack.packRankCounts.toJson()[card.rank] as int?) ?? 0;

          return card.cover.isVideo
              ? PackCardWidget.video(
                  key: ValueKey(card.id),
                  cardPath: card.cover.toAbsoluteUrl(EnvConfig.mediaBaseUrl),
                  onTap: () => showCardPreviewDialog(
                    context: context,
                    card: card,
                    rankCount: cardRankCount,
                  ),
                )
              : PackCardWidget.image(
                  key: ValueKey(card.id),
                  cardPath: card.cover.toAbsoluteUrl(EnvConfig.mediaBaseUrl),
                  onTap: () => showCardPreviewDialog(
                    context: context,
                    card: card,
                    rankCount: cardRankCount,
                  ),
                );
        },
      ),
    );
  }
}
