import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

/// A grid view displaying a list of pack cards.
class PackSliverGrid extends StatelessWidget {
  /// Creates a [PackSliverGrid] widget.
  const PackSliverGrid({super.key, required this.cards});

  /// The list of cards to display.
  final List<CardDTO> cards;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 3,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: cards.length,
        (context, index) {
          final card = cards[index];

          if (card.cover.url == null) return const SizedBox.shrink();

          final cardUri = Uri.parse('${EnvConfig.remangaUrl}card/${card.id}');

          return Link(
            uri: cardUri,
            target: LinkTarget.blank,
            builder: (context, followLink) {
              return card.cover.isVideo
                  ? PackCardWidget.video(
                      key: ValueKey(card.id),
                      cardPath: card.cover.url!,
                      onTap: followLink,
                    )
                  : PackCardWidget.image(
                      key: ValueKey(card.id),
                      cardPath: card.cover.url!,
                      onTap: followLink,
                    );
            },
          );
        },
      ),
    );
  }
}
