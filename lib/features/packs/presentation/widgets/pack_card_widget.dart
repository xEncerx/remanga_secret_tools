import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

/// A widget that displays a pack card image.
class PackCardWidget extends StatefulWidget {
  /// Creates a [PackCardWidget].
  const PackCardWidget({
    super.key,
    required this.cardUrl,
    this.onTap,
    this.isVideo = false,
    this.handleOnHover = true,
  });

  /// Creates a [PackCardWidget] for an image.
  const PackCardWidget.image({
    super.key,
    required this.cardUrl,
    this.onTap,
    this.handleOnHover = true,
  }) : isVideo = false;

  /// Creates a [PackCardWidget] for a video.
  const PackCardWidget.video({
    super.key,
    required this.cardUrl,
    this.onTap,
    this.handleOnHover = true,
  }) : isVideo = true;

  /// The URL of the card image or video.
  final String cardUrl;

  /// Indicates whether the card is a video.
  final bool isVideo;

  ///
  final bool handleOnHover;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  static const Widget _errorImage = Image(image: AssetImage('assets/images/random-card.webp'));

  @override
  State<PackCardWidget> createState() => _PackCardWidgetState();
}

class _PackCardWidgetState extends State<PackCardWidget> {
  VideoPlayerController? _videoController;
  bool _hasRenderError = false;
  bool _isHovered = false;

  @override
  void initState() {
    if (widget.isVideo) {
      _initializeVideo();
    }
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoErrorListener);
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeVideo() {
    _videoController =
        VideoPlayerController.networkUrl(
            Uri.parse(widget.cardUrl),
          )
          ..addListener(_videoErrorListener)
          ..initialize().then(
            (_) {
              if (!mounted) return;

              setState(() {});
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
      if (!mounted) return;
      setState(() {
        _hasRenderError = true;
      });
    }
  }

  @override
  void didUpdateWidget(covariant PackCardWidget oldWidget) {
    if (widget.isVideo && oldWidget.cardUrl != widget.cardUrl) {
      _videoController?.dispose();
      _hasRenderError = false;
      _initializeVideo();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => widget.handleOnHover ? setState(() => _isHovered = true) : null,
      onExit: (_) => widget.handleOnHover ? setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(_isHovered ? 0 : 8.0),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: _isHovered ? 1 : 0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            builder: (_, value, child) => DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.3 * value),
                          blurRadius: value * 10,
                          spreadRadius: value,
                        ),
                      ]
                    : [],
              ),
              child: RepaintBoundary(child: child),
            ),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: widget.isVideo ? _buildVideo(theme) : _buildImage(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    return OctoImage(
      image: NetworkImage(
        widget.cardUrl,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
      ),
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
        // Invisible layer to handle clicks
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
          borderRadius: BorderRadiusGeometry.circular(16),
          child: ColoredBox(color: opacityColor),
        ),
      ),
    );
  }
}
