import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../shared/shared.dart';

/// A widget that displays a pack card image.
class PackCardWidget extends StatefulWidget {
  /// Creates a [PackCardWidget].
  const PackCardWidget({
    super.key,
    required this.cardPath,
    bool isAsset = false,
    this.onTap,
    this.handleOnHover = true,
  }) : _isVideo = false,
       _isAsset = isAsset;

  /// Creates a [PackCardWidget] for an image.
  const PackCardWidget.image({
    super.key,
    required this.cardPath,
    bool isAsset = false,
    this.onTap,
    this.handleOnHover = true,
  }) : _isVideo = false,
       _isAsset = isAsset;

  /// Creates a [PackCardWidget] for a video.
  const PackCardWidget.video({
    super.key,
    required this.cardPath,
    bool isAsset = false,
    this.onTap,
    this.handleOnHover = true,
  }) : _isVideo = true,
       _isAsset = isAsset;

  /// The Path of the card image or video.
  final String cardPath;

  /// Whether to handle hover effects.
  final bool handleOnHover;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  final bool _isAsset;
  final bool _isVideo;

  static const Widget _errorImage = Image(image: AssetImage('assets/images/random-card.webp'));

  @override
  State<PackCardWidget> createState() => _PackCardWidgetState();
}

class _PackCardWidgetState extends State<PackCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    if (!widget.handleOnHover) return;
    _isHovered = true;
    _animationController.forward();
  }

  void _onHoverExit() {
    if (!widget.handleOnHover) return;
    _isHovered = false;
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return RepaintBoundary(
      child: MouseRegion(
        cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => _onHoverEnter(),
        onExit: (_) => _onHoverExit(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.all(8.0 * (1 - _animation.value)),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3 * _animation.value),
                              blurRadius: _animation.value * 10,
                              spreadRadius: _animation.value,
                            ),
                          ]
                        : const [],
                  ),
                  child: child,
                ),
              );
            },
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: widget._isVideo ? _buildVideo(theme) : _buildImage(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    return widget._isAsset
        ? CustomImage.asset(
            imagePath: widget.cardPath,
            placeholder: (_, _) => _buildShimmer(theme),
            errorWidget: (_, _, _) => PackCardWidget._errorImage,
          )
        : CustomImage.network(
            imagePath: widget.cardPath,
            placeholder: (_, _) => _buildShimmer(theme),
            errorWidget: (_, _, _) => PackCardWidget._errorImage,
          );
  }

  Widget _buildVideo(ThemeData theme) {
    return widget._isAsset
        ? CustomVideo.asset(
            videoPath: widget.cardPath,
            placeholder: _buildShimmer(theme),
            errorWidget: PackCardWidget._errorImage,
          )
        : CustomVideo.network(
            videoPath: widget.cardPath,
            placeholder: _buildShimmer(theme),
            errorWidget: PackCardWidget._errorImage,
          );
  }

  Widget _buildShimmer(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    final opacityColor = primaryColor.withValues(alpha: 0.3);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: opacityColor,
        highlightColor: Color.lerp(primaryColor, Colors.white, 0.1)!,
        period: const Duration(seconds: 1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(color: opacityColor),
        ),
      ),
    );
  }
}
