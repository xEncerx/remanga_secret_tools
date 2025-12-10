import 'dart:async';

import 'package:backend/core/core.dart';
import 'package:meta/meta.dart';
import 'package:talker/talker.dart';

/// Base class for all schedulers.
abstract class BaseScheduler {
  Timer? _timer;

  /// Indicates whether the scheduler is active.
  bool isActive = true;
  Completer<void>? _currentTask;

  /// The unique name of the scheduler.
  String get name;

  /// The interval between task executions.
  Duration get interval;

  /// The function that defines the task to be executed.
  Future<void> executeTask();

  /// The entry point function for the scheduler.
  Future<void> start() async {
    if (_timer != null) {
      getIt<Talker>().warning('[$name] Already started');
      return;
    }

    getIt<Talker>().info('[$name] Scheduler started with interval: $interval');

    _timer = Timer.periodic(interval, (_) async {
      if (!isActive || _currentTask != null) return;

      _currentTask = Completer<void>();

      try {
        await executeTask();
      } catch (e, st) {
        getIt<Talker>().error('[$name] Error during task execution: $e', e, st);
      } finally {
        _currentTask?.complete();
        _currentTask = null;
      }
    });
  }

  /// Disposes resources used by the scheduler.
  @mustCallSuper
  Future<void> dispose({Duration timeout = const Duration(seconds: 10)}) async {
    _timer?.cancel();
    _timer = null;
    isActive = false;

    await _waitForCurrentTask(timeout);

    getIt<Talker>().info('[$name] Stopped and disposed');
  }

  /// Waits for the current task to complete with a timeout.
  Future<void> _waitForCurrentTask(Duration timeout) async {
    if (_currentTask == null) return;

    try {
      await _currentTask!.future.timeout(
        timeout,
        onTimeout: () => getIt<Talker>().warning(
          '[$name] Task did not complete within $timeout',
        ),
      );
    } catch (e) {
      getIt<Talker>().warning(
        '[$name] Current task did not complete in time: $e',
      );
    }
  }

  /// Pauses the scheduler.
  void pause() {
    isActive = false;
    getIt<Talker>().info('[$name] Paused');
  }

  /// Resumes the scheduler.
  void resume() {
    isActive = true;
    getIt<Talker>().info('[$name] Resumed');
  }
}
