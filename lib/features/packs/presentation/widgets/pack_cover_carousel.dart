import 'package:flutter/material.dart';

import 'widgets.dart';

/// A carousel widget that displays multiple copies of a pack cover image
class PackCoverCarousel extends StatelessWidget {
  /// Creates a [PackCoverCarousel].
  const PackCoverCarousel({
    super.key,
    required this.packCover,
  });

  /// Pack cover url
  final String packCover;

  @override
  Widget build(BuildContext context) {
    const Widget cachedCard = PackCardWidget.image(
      cardPath: 'assets/images/random-card.webp',
      isAsset: true,
      handleOnHover: false,
    );
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height * 0.25;

        final cardWidth = height * (2 / 3);
        final screenWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final int itemCount = (screenWidth / cardWidth).ceil() + 1;

        return SizedBox(
          height: height,
          child: Stack(
            children: [
              Center(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  child: Row(
                    children: List.generate(
                      itemCount,
                      (index) => SizedBox(
                        width: cardWidth,
                        height: height,
                        child: cachedCard,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 200,
                child: _buildGradientOverlay(backgroundColor),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: 200,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: _buildGradientOverlay(backgroundColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay(Color backgroundColor) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor,
            backgroundColor.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
