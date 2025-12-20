// ignore_for_file: lines_longer_than_80_chars

/// Base class for storage exceptions.
sealed class StorageException implements Exception {
  const StorageException(this.message, [this.path]);

  /// The error message associated with the exception.
  final String message;

  /// The path to the file or directory where the exception occurred.
  final String? path;

  @override
  String toString() {
    final pathInfo = path != null ? ' (path: $path)' : '';
    return 'StorageException: $message$pathInfo';
  }
}

/// Thrown when file write operation fails.
class StorageWriteException extends StorageException {
  /// Creates a [StorageWriteException] with the given message and optional path
  const StorageWriteException(super.message, [super.path]);
}

/// Thrown when file read operation fails.
class StorageReadException extends StorageException {
  /// Creates a [StorageReadException] with the given message and optional path
  const StorageReadException(super.message, [super.path]);
}

/// Thrown when file doesn't exist.
class StorageNotFoundException extends StorageException {
  /// Creates a [StorageNotFoundException] with the given message and optional path
  const StorageNotFoundException(super.message, [super.path]);
}

/// Thrown when file deletion fails.
class StorageDeleteException extends StorageException {
  /// Creates a [StorageDeleteException] with the given message and optional path
  const StorageDeleteException(super.message, [super.path]);
}

/// Thrown when insufficient disk space.
class StorageQuotaException extends StorageException {
  /// Creates a [StorageQuotaException] with the given message and optional path
  const StorageQuotaException(super.message, [super.path]);
}
