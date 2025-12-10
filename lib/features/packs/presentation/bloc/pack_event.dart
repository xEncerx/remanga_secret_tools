part of 'pack_bloc.dart';

/// Abstract base class for all Pack events.
sealed class PackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to fetch pack data.
final class FetchPackEvent extends PackEvent {
  /// Creates a [FetchPackEvent] with the given [packId].
  FetchPackEvent(this.packId);

  /// The ID of the pack to fetch.
  final int packId;

  @override
  List<Object?> get props => [packId];
}

/// Event to fetch pack data in a loop.
final class FetchPackLoopEvent extends PackEvent {
  /// Creates a [FetchPackLoopEvent] with the given [packId].
  FetchPackLoopEvent({
    required this.packId,
    this.delay = const Duration(seconds: 30),
  });

  /// The ID of the pack to fetch.
  final int packId;

  /// The delay duration between fetches.
  final Duration delay;

  @override
  List<Object?> get props => [packId];
}
