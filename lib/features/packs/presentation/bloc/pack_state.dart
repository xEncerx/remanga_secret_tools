part of 'pack_bloc.dart';

/// Abstract base class for all Pack states.
sealed class PackState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state of the PackBloc.
final class PackInitialState extends PackState {}

/// State representing that the pack is currently loading.
final class PackLoadingState extends PackState {}

/// State representing that the pack has been successfully loaded.
final class PackLoadedState extends PackState {
  /// 
  PackLoadedState(this.packData);

  /// The loaded pack data.
  final PackDTO packData;

  @override
  List<Object?> get props => [packData];
}

/// State representing a failure in loading the pack.
final class PackFailureState extends PackState {
  /// Creates a [PackFailureState] with the given [exception].
  PackFailureState(this.exception);

  /// The exception that caused the failure.
  final ApiException exception;

  @override
  List<Object?> get props => [exception];
}
