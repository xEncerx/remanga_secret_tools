import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// A model class for the `cards` table in the database.
class CardsDbModel extends Table {
  @override
  String get tableName => 'cards';

  /// Unique identifier for the card.
  IntColumn get id => integer()();

  /// Description of the card.
  TextColumn get description => text()();

  /// Score value of the card.
  IntColumn get score => integer()();

  /// Rank of the card.
  TextColumn get rank => textEnum<CardRankEnum>()();

  /// Power level of the card.
  IntColumn get power => integer()();

  /// Indicates if the card has associated audio.
  BoolColumn get hasAudio => boolean()();

  /// Indicates if the card can be upgraded.
  BoolColumn get isUpgradable => boolean()();

  /// URL for the original cover image of the card.
  TextColumn get coverOriginalUrl => text()();

  /// Local path for the cover image of the card.
  ///
  /// Can be null if the image is not yet downloaded.
  TextColumn get coverLocalPath => text().nullable()();

  /// [DownloadStatus] of the cover image download.
  ///
  /// Can be 'pending', 'downloading', 'downloaded', or 'failure'.
  TextColumn get coverStatus =>
      textEnum<DownloadStatus>().withDefault(const Constant('pending'))();

  /// Timestamp of when the card was last updated.
  Column<PgDateTime> get updatedAt =>
      customType(PgTypes.timestampWithTimezone).withDefault(now())();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
