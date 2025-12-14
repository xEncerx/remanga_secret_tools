import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../../../../core/core.dart';

/// A button that opens the Remanga pack page in the browser to buy or open a pack.
class PackBuyButton extends StatelessWidget {
  /// Creates a [PackBuyButton] widget.
  const PackBuyButton({
    super.key,
    required this.packId,
    required this.cost,
  });

  /// The pack's identifier used to build the URL opened in the browser.
  final int packId;

  /// The pack's price shown on the button.
  final int cost;

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse('${EnvConfig.remangaUrl}deck/$packId/open'),
      target: LinkTarget.blank,
      builder: (context, followLink) => FilledButton.icon(
        onPressed: followLink,
        style: FilledButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ).copyWith(right: 10),
        ),
        label: Text(
          cost.toString(),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        icon: const Icon(
          Icons.bolt_rounded,
          color: Colors.amberAccent,
        ),
        iconAlignment: IconAlignment.end,
      ),
    );
  }
}
