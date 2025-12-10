import 'dart:async';

import 'package:backend/core/core.dart';
import 'package:backend/features/features.dart';

/// Scheduler for updating packs periodically.
class PackScheduler extends BaseScheduler {
  /// Creates a [PackScheduler] instance.
  PackScheduler({
    required this.packId,
    required this.interval,
  });

  /// The ID of the pack to be updated.
  final int packId;

  /// The interval  between updates.
  @override
  final Duration interval;

  @override
  String get name => 'pack_scheduler_$packId';

  @override
  Future<void> executeTask() async {
    await getIt<PacksUseCases>().fetchAndUpdatePack(packId);
  }
}
