import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Drift database table representing packs.
class Packs extends Table {
  /// Unique identifier for the pack.
  IntColumn get packId => integer()();

  /// Raw pack data stored as JSON.
  Column<Object> get rawPackData =>
      customType(PgTypes.jsonb).map(const PackEntityConverter())();

  /// Hash of the pack for integrity verification.
  TextColumn get packHash => text()();

  /// Timestamp of when the pack was last updated.
  Column<PgDateTime> get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column> get primaryKey => {packId};
}

/// Convert PackEntity to and from a JSON string for database storage.
class PackEntityConverter extends TypeConverter<PackEntity, Object> {
  /// Creates a constant instance of [PackEntityConverter].
  const PackEntityConverter();

  @override
  PackEntity fromSql(Object fromDb) {
    return PackEntity.fromJson(fromDb as Map<String, dynamic>);
  }

  @override
  Object toSql(PackEntity value) {
    return value.toJson();
  }
}
