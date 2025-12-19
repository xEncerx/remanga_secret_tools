import 'dart:io';

import 'package:backend/features/features.dart';
import 'package:path/path.dart' as path;

/// Local file system implementation of [FileStorage].
class LocalFileStorage implements FileStorage {
  /// Creates a [LocalFileStorage] instance.
  LocalFileStorage({required this.basePath}) {
    _ensureBasePathExists();
  }

  /// Base directory for all file operations.
  final String basePath;

  void _ensureBasePathExists() {
    final dir = Directory(basePath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  @override
  Future<void> write(String relativePath, List<int> bytes) async {
    final file = _getFile(relativePath);

    try {
      // Create parent directories if they don't exist
      await file.parent.create(recursive: true);

      // Write file
      await file.writeAsBytes(bytes, flush: true);
    } on FileSystemException catch (e) {
      if (e.osError?.errorCode == 28) {
        // ENOSPC (No space left on device)
        throw StorageQuotaException(
          'Insufficient disk space',
          relativePath,
        );
      }
      throw StorageWriteException(
        'Failed to write file: ${e.message}',
        relativePath,
      );
    } catch (e) {
      throw StorageWriteException(
        'Unexpected error writing file: $e',
        relativePath,
      );
    }
  }

  @override
  Future<bool> exists(String relativePath) async {
    final file = _getFile(relativePath);
    return file.existsSync();
  }

  File _getFile(String relativePath) {
    final cleanPath = relativePath.replaceFirst(RegExp(r'^[/\\]+'), '');
    return File(path.join(basePath, cleanPath));
  }
}
