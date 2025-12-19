import 'package:backend/features/features.dart';
import 'package:drift/drift.dart';

/// A model class representing the `pack_cards` table in the database.
class PackCardsDbModel extends Table {
  @override
  String get tableName => 'pack_cards';

  /// The ID of the pack.
  IntColumn get packId =>
      integer().references(PacksDbModel, #id, onDelete: KeyAction.cascade)();

  /// The ID of the card.
  IntColumn get cardId =>
      integer().references(CardsDbModel, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>>? get primaryKey => {packId, cardId};
}
