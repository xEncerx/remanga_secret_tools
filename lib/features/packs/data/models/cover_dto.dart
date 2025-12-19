import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/core.dart';

part 'cover_dto.freezed.dart';
part 'cover_dto.g.dart';

/// DTO representing cover images with different resolutions.
@freezed
abstract class CoverDTO with _$CoverDTO {
  /// Factory constructor for [CoverDTO].
  const factory CoverDTO({
    /// URL for medium resolution cover image.
    required String? mid,

    /// URL for high resolution cover image.
    required String? high,
  }) = _CoverDTO;

  const CoverDTO._();

  /// Creates a [CoverDTO] from a JSON map.
  factory CoverDTO.fromJson(Map<String, dynamic> json) => _$CoverDTOFromJson(json);

  static const Set<String> _videoExtensions = {'mp4', 'webm'};

  /// Gets the best available cover URL, preferring high resolution.
  String? get url {
    final url = high ?? mid;
    if (url == null) return null;

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      return '${EnvConfig.mediaBaseUrl}$url';
    }
  }

  /// Determines if the cover image is a video based on its file extension.
  bool get isVideo {
    if (mid == null && high == null) {
      return false;
    }

    final url = mid ?? high!;
    final extension = url.split('.').last.toLowerCase();
    return _videoExtensions.contains(extension);
  }
}
