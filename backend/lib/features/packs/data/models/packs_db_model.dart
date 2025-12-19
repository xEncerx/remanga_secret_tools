import 'package:backend/database/database.dart';
import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// A model class for the `packs` table in the database.
class PacksDbModel extends Table {
  @override
  String get tableName => 'packs';

  /// Unique identifier for the pack.
  IntColumn get id => integer()();

  /// Name of the pack.
  TextColumn get name => text()();

  /// Description of the pack.
  TextColumn get description => text()();

  /// Hash of the pack for integrity verification.
  TextColumn get packHash => text()();

  /// Level information of the pack.
  Column<Object> get level => customType(PgTypes.jsonb).map(
    JsonBTypeConverter<PackLevelEntity>(
      PackLevelEntity.fromJson,
      (level) => level.toJson(),
    ),
  )();

  /// Indicates if the pack is currently active.
  BoolColumn get isActive => boolean()();

  /// Type of the pack.
  TextColumn get type => text()();

  /// [PackGuarantorsEntity] representing the pack's guarantors.
  Column<Object> get guarantors => customType(PgTypes.jsonb).map(
    JsonBTypeConverter<PackGuarantorsEntity>(
      PackGuarantorsEntity.fromJson,
      (guarantors) => guarantors.toJson(),
    ),
  )();

  /// Cost of the pack.
  IntColumn get cost => integer()();

  /// Directory path related to the pack.
  TextColumn get dir => text()();

  /// Amount associated with the pack
  IntColumn get amount => integer()();

  /// Timestamp of when the pack was last updated.
  Column<PgDateTime> get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column> get primaryKey => {id};
}
