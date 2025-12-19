// ignore_for_file: constant_identifier_names

/// Represents the rank of a card in a pack.
enum CardRankEnum {
  /// Represents the RE rank of card.
  rank_re,

  /// Represents the S rank of card.
  rank_s,

  /// Represents the A rank of card.
  rank_a,

  /// Represents the B rank of card.
  rank_b,

  /// Represents the C rank of card.
  rank_c,

  /// Represents the D rank of card.
  rank_d,

  /// Represents the E rank of card.
  rank_e,

  /// Represents the F rank of card.
  rank_f,

  /// Represents the unknown rank of card.
  unknown;

  /// Converts a string value to a [CardRankEnum] value.
  static CardRankEnum fromString(String value) {
    return CardRankEnum.values.firstWhere(
      (element) => element.name == value.toLowerCase(),
      orElse: () => unknown,
    );
  }
}
