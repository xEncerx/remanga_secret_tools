import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import '../shared.dart';

/// A popup menu button that displays author links.
class AuthorPopupMenuButton extends StatelessWidget {
  /// Creates an [AuthorPopupMenuButton].
  const AuthorPopupMenuButton({
    super.key,
    required this.links,
    this.iconColor,
    this.tooltip = 'Об авторе',
  });

  /// The list of social links to display.
  final List<SocialLinkData> links;

  /// The color of the menu icon.
  final Color? iconColor;

  /// The tooltip text for the menu icon.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: tooltip,
      offset: const Offset(0, 40),
      icon: Icon(Icons.more_vert, color: iconColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) {
        return List.generate(links.length, (index) {
          final link = links[index];

          return PopupMenuItem<int>(
            value: index,
            padding: EdgeInsets.zero,
            child: Link(
              uri: Uri.parse(link.url),
              target: LinkTarget.blank,
              builder: (context, followLink) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    followLink?.call();
                  },
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: link.icon,
                    ),
                    title: Text(
                      link.label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }
}
