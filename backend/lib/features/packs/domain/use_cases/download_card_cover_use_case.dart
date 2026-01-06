import 'dart:async';
import 'dart:io';

import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';
import 'package:dio/dio.dart';
import 'package:retry/retry.dart';

/// Use case for downloading card cover image.
class DownloadCardCoverUseCase {
  /// Creates an instance of [DownloadCardCoverUseCase].
  DownloadCardCoverUseCase({
    required this.restClient,
    required this.cardRepository,
    required this.fileStorage,
  });

  /// Dio instance for making HTTP requests.
  final RestClient restClient;

  /// Card repository for database operations.
  final CardRepository cardRepository;

  /// File storage for handling file operations.
  final FileStorage fileStorage;

  static const _retryOptions = RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 5),
  );

  /// Executes the download process for the card cover image.
  Future<DownloadResult> execute(int cardId) async {
    // 1. Get card from DB
    final card = await cardRepository.findById(cardId);
    if (card == null) {
      return DownloadResult.success(DownloadData.notFound());
    }
    if (card.coverStatus == DownloadStatus.downloaded) {
      return DownloadResult.success(DownloadData.alreadyDownloaded());
    }

    try {
      // 2. Mark as downloading
      await cardRepository.updateCoverStatus(
        cardId,
        DownloadStatus.downloading,
      );

      // 3. Check if file already exists (recovery after crash)
      final localPath = card.coverLocalPath!;
      if (await fileStorage.exists(localPath)) {
        await cardRepository.updateCoverStatus(
          cardId,
          DownloadStatus.downloaded,
        );
        return DownloadResult.success(DownloadData.alreadyDownloaded());
      }

      // 4. Download file
      final bytes = await _retryOptions.retry(
        () => restClient.files.downloadImage(card.coverOriginalUrl),
        retryIf: _shouldRetry,
      );

      await fileStorage.write(localPath, bytes);

      // 5. Mark as downloaded
      await cardRepository.updateCoverStatus(cardId, DownloadStatus.downloaded);
      return DownloadResult.success(DownloadData.downloaded());
    } catch (e, st) {
      await cardRepository.updateCoverStatus(cardId, DownloadStatus.failure);
      return DownloadResult.failure(
        message: 'Failed to download card cover for card $cardId',
        exception: e,
        stackTrace: st,
      );
    }
  }

  /// Determines if the exception is retryable.
  bool _shouldRetry(Exception e) {
    // Network exceptions
    if (e is SocketException || e is TimeoutException) {
      return true;
    }

    // DioException
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return true;
      }

      // Check HTTP status codes
      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        return statusCode == 408 || // Request Timeout
            statusCode == 429 || // Too Many Requests
            statusCode == 500 || // Internal Server Error
            statusCode == 502 || // Bad Gateway
            statusCode == 504; // Gateway Timeout
      }
    }

    return false;
  }
}
