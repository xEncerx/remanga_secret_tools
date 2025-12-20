import 'package:backend/features/features.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_result.freezed.dart';

/// Data returned on successful pack synchronization.
@freezed
abstract class SyncData with _$SyncData {
  /// Creates a [SyncData] instance.
  const factory SyncData({
    required int cardsAdded,
    required bool hasChanges,
  }) = _SyncData;

  const SyncData._();

  /// Factory for unchanged synchronization (no new cards).
  factory SyncData.unchanged() => const SyncData(
    cardsAdded: 0,
    hasChanges: false,
  );

  /// Factory for updated synchronization with card changes.
  factory SyncData.updated({
    required int cardsAdded,
  }) => SyncData(
    cardsAdded: cardsAdded,
    hasChanges: true,
  );
}

/// Type alias for pack synchronization result.
///
/// Returns [SyncData] on success or error details on failure.
typedef SyncResult = Result<SyncData>;
