import 'package:backend/features/features.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_result.freezed.dart';

/// Data returned on successful download operation.
@freezed
abstract class DownloadData with _$DownloadData {
  /// Creates a [DownloadData] instance.
  const factory DownloadData({
    required CardDownloadStatus status,
  }) = _DownloadData;

  const DownloadData._();

  /// Factory for successful download.
  factory DownloadData.downloaded() => const DownloadData(
    status: CardDownloadStatus.downloaded,
  );

  /// Factory for already downloaded file (skip).
  factory DownloadData.alreadyDownloaded() => const DownloadData(
    status: CardDownloadStatus.alreadyDownloaded,
  );

  /// Factory for card not found in database.
  factory DownloadData.notFound() => const DownloadData(
    status: CardDownloadStatus.notFound,
  );
}

/// Status of download operation.
enum CardDownloadStatus {
  /// File downloaded successfully.
  downloaded,

  /// File was already downloaded (no action taken).
  alreadyDownloaded,

  /// Card not found in database.
  notFound,
}

/// Type alias for pack synchronization result.
///
/// Returns [DownloadData] on success or error details on failure.
typedef DownloadResult = Result<DownloadData>;
