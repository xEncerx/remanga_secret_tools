import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Generic result type for operations that can succeed or fail.
@freezed
sealed class Result<T> with _$Result<T> {
  const Result._();

  /// Operation succeeded with a value.
  const factory Result.success(T value) = ResultSuccess<T>;

  /// Operation failed with an error.
  const factory Result.failure({
    required String message,
    Object? exception,
    StackTrace? stackTrace,
  }) = ResultFailure<T>;

  /// Helper to check if operation succeeded.
  bool get isSuccess => this is ResultSuccess<T>;

  /// Helper to check if operation failed.
  bool get isFailure => this is ResultFailure<T>;

  /// Get value if success, throw if failure.
  T getOrThrow() {
    return switch (this) {
      ResultSuccess(value: final v) => v,
      ResultFailure(message: final msg) => 
        throw Exception('Result failed: $msg'),
    };
  }

  /// Get value if success, return default if failure.
  T getOrDefault(T defaultValue) {
    return switch (this) {
      ResultSuccess(value: final v) => v,
      ResultFailure() => defaultValue,
    };
  }

  /// Transform success value, preserve failure.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      ResultSuccess(value: final v) => Result.success(transform(v)),
      ResultFailure(:final message, :final exception, :final stackTrace) => 
        Result.failure(
          message: message,
          exception: exception,
          stackTrace: stackTrace,
        ),
    };
  }
}
