import 'package:backend/features/features.dart';

/// Use case for processing pending downloads.
class ProcessPendingDownloadsUseCase {
  /// Creates a [ProcessPendingDownloadsUseCase] instance.
  ProcessPendingDownloadsUseCase({
    required this.cardRepository,
    required this.downloadCardCoverUseCase,
    required this.maxConcurrent,
  });

  /// Repositories and use cases.
  final CardRepository cardRepository;

  /// Download case for downloading card covers.
  final DownloadCardCoverUseCase downloadCardCoverUseCase;

  /// Maximum number of concurrent downloads.
  final int maxConcurrent;

  /// Executes the use case to process pending downloads.
  Future<void> execute() async {
    final pendingCards = await cardRepository.findByStatus(
      DownloadStatus.pending,
      limit: 50,
    );

    if (pendingCards.isEmpty) return;

    for (var i = 0; i < pendingCards.length; i += maxConcurrent) {
      final batch = pendingCards.skip(i).take(maxConcurrent).toList();

      await Future.wait(
        batch.map((card) => downloadCardCoverUseCase.execute(card.id)),
      );

      if (i + maxConcurrent < pendingCards.length) {
        await Future<void>.delayed(const Duration(seconds: 1));
      }
    }
  }
}
