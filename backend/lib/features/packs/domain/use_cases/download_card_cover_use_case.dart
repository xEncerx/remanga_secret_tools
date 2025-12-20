import 'package:backend/features/features.dart';
import 'package:dio/dio.dart';

/// Use case for downloading card cover image.
class DownloadCardCoverUseCase {
  /// Creates an instance of [DownloadCardCoverUseCase].
  DownloadCardCoverUseCase({
    required this.dio,
    required this.cardRepository,
    required this.fileStorage,
  });

  /// Dio instance for making HTTP requests.
  final Dio dio;

  /// Card repository for database operations.
  final CardRepository cardRepository;

  /// File storage for handling file operations.
  final FileStorage fileStorage;

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
      final bytes = await dio.get<List<int>>(
        card.coverOriginalUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      await fileStorage.write(localPath, bytes.data!);

      // 5. Mark as downloaded
      await cardRepository.updateCoverStatus(cardId, DownloadStatus.downloaded);

      return DownloadResult.success(DownloadData.downloaded());
    } catch (e, st) {
      return DownloadResult.failure(
        message: 'Failed to download card cover for card $cardId',
        exception: e,
        stackTrace: st,
      );
    }
  }
}
