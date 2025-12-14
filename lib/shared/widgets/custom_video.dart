import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/core.dart';

/// A widget that displays a video from various sources with error handling and placeholders.
class CustomVideo extends StatefulWidget {
  /// Creates a [CustomVideo] widget.
  const CustomVideo({
    super.key,
    required this.videoPath,
    required this.bypassCORS,
    this.placeholder,
    this.errorWidget,
    bool isAsset = false,
  }) : _isAsset = isAsset;

  /// Creates a [CustomVideo] widget for network videos.
  const CustomVideo.network({
    super.key,
    required this.videoPath,
    this.bypassCORS = true,
    this.placeholder,
    this.errorWidget,
  }) : _isAsset = false;

  /// Creates a [CustomVideo] widget for asset videos.
  const CustomVideo.asset({
    super.key,
    required this.videoPath,
    this.placeholder,
    this.errorWidget,
  }) : _isAsset = true,
       bypassCORS = false;

  /// Path of the video to display.
  final String videoPath;

  /// Whether to bypass CORS using a proxy.
  final bool bypassCORS;

  /// A widget to display while the video is loading.
  final Widget? placeholder;

  /// A widget to display if an error occurs while loading the video.
  final Widget? errorWidget;

  static const _errorWidget = Image(image: AssetImage('assets/images/error-cover.webp'));
  final bool _isAsset;

  @override
  State<CustomVideo> createState() => _CustomVideoState();
}

class _CustomVideoState extends State<CustomVideo> with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _player;
  bool _hasRenderError = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _initializePlayer();
    super.initState();
  }

  void _initializePlayer() {
    _player = widget._isAsset
        ? VideoPlayerController.asset(widget.videoPath)
        : VideoPlayerController.networkUrl(
            Uri.parse(
              widget.bypassCORS ? CorsProxy.getProxiedUrl(widget.videoPath) : widget.videoPath,
            ),
            httpHeaders: {
              'Cache-Control': 'public, max-age=604800',
            },
          );

    _player
        .initialize()
        .then(
          (_) {
            if (!mounted) return;
            setState(() {
              _hasRenderError = false;
              _player.setLooping(true);
              _player.setVolume(0.0);
              _player.play();
            });
          },
        )
        .catchError((_) {
          if (!mounted) return;
          setState(() => _hasRenderError = true);
        });

    _player.addListener(_hasErrorListener);
  }

  void _hasErrorListener() {
    if (_player.value.hasError) {
      setState(() => _hasRenderError = true);
    }
  }

  @override
  void dispose() {
    _player.removeListener(_hasErrorListener);
    _player.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomVideo oldWidget) {
    if (oldWidget.videoPath != widget.videoPath || oldWidget._isAsset != widget._isAsset) {
      _player.dispose();
      _initializePlayer();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_hasRenderError || _player.value.hasError) {
      return widget.errorWidget ?? CustomVideo._errorWidget;
    }

    if (!_player.value.isInitialized) {
      return widget.placeholder ??
          const Center(
            child: CircularProgressIndicator(),
          );
    }

    return Stack(
      children: [
        VideoPlayer(_player),
        const Positioned.fill(
          child: ColoredBox(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
