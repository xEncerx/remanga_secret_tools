import 'dart:async';

import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';
import 'package:talker/talker.dart';

/// Scheduler for updating packs periodically.
class PackSyncScheduler extends BaseScheduler {
  /// Creates a [PackSyncScheduler] instance.
  PackSyncScheduler({
    required this.packId,
    required this.syncPackUseCase,
    required this.interval,
  });

  /// The ID of the pack to be updated.
  final int packId;

  /// The use case for syncing the pack.
  final SyncPackUseCase syncPackUseCase;

  /// The interval  between updates.
  @override
  final Duration interval;

  @override
  String get name => 'pack_sync_scheduler_$packId';

  @override
  Future<void> executeTask() async {
    final result = await syncPackUseCase.execute(packId);
    result.when(
      success: (result) {
        getIt<Talker>().info(
          'Pack $packId synced successfully.'
          ' Cards added: ${result.cardsAdded},'
          ' has changes: ${result.hasChanges}',
        );
      },
      failure: (message, e, st) {
        getIt<Talker>().error(message, e, st);
      },
    );
  }
}
