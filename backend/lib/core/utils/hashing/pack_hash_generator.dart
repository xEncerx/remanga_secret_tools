import 'package:backend/core/utils/hashing/hash_generator.dart';
import 'package:backend/features/packs/domain/domain.dart';
import 'package:crypto/crypto.dart';

/// A hash generator for PackEntity that generates a hash based on the sorted list of card IDs.
class PackHashGenerator extends HashGenerator<PackEntity> {
  @override
  String generate(PackEntity data) {
    final ids = <int>[];
    for (final card in data.cards) {
      ids.add(card.id);
    }
    ids.sort();
    return sha256.convert(ids).toString();
  }
}
