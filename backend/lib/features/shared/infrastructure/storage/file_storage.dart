import 'package:backend/features/features.dart';

/// Abstract interface for file storage operations.
abstract interface class FileStorage {
  /// Writes binary data to a file at the specified path.
  ///
  /// If the file already exists, it will be overwritten.
  /// Creates parent directories if they don't exist.
  ///
  /// Throws [StorageException] if write operation fails.
  Future<void> write(String path, List<int> bytes);

  /// Checks if a file exists at the specified path.
  Future<bool> exists(String path);
}
