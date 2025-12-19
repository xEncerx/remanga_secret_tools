import 'package:backend/features/features.dart';

/// Scheduler for downloading files.
class CardCoverDownloaderScheduler extends BaseScheduler {
  /// Creates a new instance of [CardCoverDownloaderScheduler].
  CardCoverDownloaderScheduler({
    required this.processPendingDownloadsUseCase,
    required this.interval,
  });

  /// Use case for processing pending downloads.
  final ProcessPendingDownloadsUseCase processPendingDownloadsUseCase;

  @override
  final Duration interval;

  @override
  String get name => 'card_download_scheduler';

  @override
  Future<void> executeTask() async {
    await processPendingDownloadsUseCase.execute();
  }
}
