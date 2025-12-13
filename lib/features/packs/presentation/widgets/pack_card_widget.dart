import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController? _videoController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _hasRenderError = false;
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

    if (widget._isVideo) {
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoController?.removeListener(_videoErrorListener);
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideo() {
    _videoController = widget._isAsset
        ? VideoPlayerController.asset(widget.cardPath)
        : VideoPlayerController.networkUrl(
            Uri.parse(widget.cardPath),
          );

    _videoController!
      ..addListener(_videoErrorListener)
      ..initialize().then(
        (_) {
          if (!mounted) return;
          setState(() {
            _hasRenderError = false;
          });
          _videoController?.setLooping(true);
          _videoController?.setVolume(0.0);
          _videoController?.play();
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _hasRenderError = true;
          });
        },
      );
  }

  void _videoErrorListener() {
    if (_videoController?.value.hasError ?? false) {
      if (!mounted || !_hasRenderError) return;
      setState(() {
        _hasRenderError = true;
      });
    }
  }

  @override
  void didUpdateWidget(covariant PackCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final pathChanged = oldWidget.cardPath != widget.cardPath;
    final sourceChanged = oldWidget._isAsset != widget._isAsset;
    final typeChanged = oldWidget._isVideo != widget._isVideo;

    if (typeChanged || (widget._isVideo && (pathChanged || sourceChanged))) {
      _videoController?.dispose();
      _hasRenderError = false;
      _initializeVideo();
    }
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
    final ImageProvider image = widget._isAsset
        ? AssetImage(widget.cardPath)
        : NetworkImage(
            widget.cardPath,
            webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
          );

    return OctoImage(
      image: image,
      errorBuilder: (_, _, _) => PackCardWidget._errorImage,
      placeholderBuilder: (_) => _buildShimmer(theme),
    );
  }

  Widget _buildVideo(ThemeData theme) {
    if (_hasRenderError) return PackCardWidget._errorImage;

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return _buildShimmer(theme);
    }
    return Stack(
      children: [
        VideoPlayer(_videoController!),
        const Positioned.fill(
          child: ColoredBox(
            color: Colors.transparent,
          ),
        ),
      ],
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
