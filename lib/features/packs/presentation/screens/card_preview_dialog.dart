import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../features.dart';

/// Shows a dialog previewing a card.
Future<void> showCardPreviewDialog({
  required BuildContext context,
  required CardDTO card,
  int rankCount = 0,
}) {
  return showDialog(
    context: context,
    builder: (context) => CardPreviewDialog(
      card: card,
      rankCount: rankCount,
    ),
  );
}

/// A dialog widget that previews a card detail.
class CardPreviewDialog extends StatelessWidget {
  /// Creates a [CardPreviewDialog] widget.
  const CardPreviewDialog({
    super.key,
    required this.card,
    required this.rankCount,
  });

  /// The card data to preview.
  final CardDTO card;

  /// The rank count of the card.
  final int rankCount;

  @override
  Widget build(BuildContext context) {
    final dropRate = rankCount > 0 ? (card.encounterCount / rankCount * 100) : 0.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(
        maxHeight: 800,
        maxWidth: 500,
      ),
      insetPadding: const EdgeInsets.only(top: 65),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Invisible layer to close the dialog when tapping outside the card cover
                GestureDetector(onTap: () => Navigator.of(context).pop()),

                if (card.cover.isVideo)
                  PackCardWidget.video(
                    key: ValueKey(card.id),
                    cardPath: card.cover.toAbsoluteUrl(EnvConfig.mediaBaseUrl),
                    handleOnHover: false,
                  )
                else
                  PackCardWidget.image(
                    key: ValueKey(card.id),
                    cardPath: card.cover.toAbsoluteUrl(EnvConfig.mediaBaseUrl),
                    handleOnHover: false,
                  ),
              ],
            ),
          ),
          Flexible(
            child: _CardPreviewDetail(
              cardId: card.id,
              description: card.description,
              dropRate: dropRate,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget displaying card details in the preview dialog.
class _CardPreviewDetail extends StatelessWidget {
  const _CardPreviewDetail({
    required this.cardId,
    required this.description,
    required this.dropRate,
  });

  final int cardId;
  final String description;
  final double dropRate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Просто карточка',
                  style: theme.textTheme.titleLarge.semiBold,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  description.isNotEmpty
                      ? description
                      : 'Эх, автор не потрудился добавить описание :(',
                  style: theme.textTheme.bodyLarge.withColor(theme.hintColor).ellipsis,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
                Link(
                  uri: Uri.parse('${EnvConfig.remangaUrl}card/$cardId'),
                  target: LinkTarget.blank,
                  builder: (context, followLink) => FilledButton.icon(
                    onPressed: followLink,
                    label: const Text('Перейти к карте', maxLines: 1),
                    icon: const Icon(Icons.open_in_new_rounded),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
                Text(
                  'Эта карта появляется с вероятностью в ${dropRate.toStringAsFixed(1)}%*',
                  style: theme.textTheme.bodyLarge.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  '* Вероятность рассчитывается на основе количества раз, когда карта появлялась в паке в сравнении с общим количеством карт этого ранга.',
                  style: theme.textTheme.bodyMedium.withColor(theme.hintColor).ellipsis,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton.filledTonal(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Закрыть',
          ),
        ),
      ],
    );
  }
}
