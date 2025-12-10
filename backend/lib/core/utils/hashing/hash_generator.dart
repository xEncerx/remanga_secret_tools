/// An abstract class for generating hashes and checking for changes.
abstract class HashGenerator<T> {
  /// Generates a hash for the given data.
  String generate(T data);

  /// Checks if the data has changed by comparing the new hash with the old hash
  bool hasChanged(T data, String oldHash) {
    return generate(data) != oldHash;
  }
}
