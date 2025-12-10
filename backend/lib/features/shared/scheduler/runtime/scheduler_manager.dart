import 'dart:async';

import 'package:backend/features/features.dart';

/// Manages the lifecycle and communication of schedulers.
class SchedulerManager {
  static final Map<String, BaseScheduler> _schedulers = {};

  /// Registers a new scheduler.
  static Future<void> register(BaseScheduler scheduler) async {
    final name = scheduler.name;

    if (_schedulers.containsKey(name)) {
      throw StateError('Scheduler with name $name is already registered.');
    }

    _schedulers[name] = scheduler;
    await scheduler.start();
  }

  /// Stops the scheduler with the given [name].
  static Future<void> stop(
    String name, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final scheduler = _schedulers[name];

    if (scheduler == null) return;

    await scheduler.dispose(timeout: timeout);
    _schedulers.remove(name);
  }

  /// Stops all registered schedulers.
  static Future<void> stopAll({
    Duration eachTaskTimeout = const Duration(seconds: 10),
  }) async {
    final names = List<String>.from(_schedulers.keys);

    await Future.wait(
      names.map((name) => stop(name, timeout: eachTaskTimeout)),
    );
  }
}
