import 'package:flutter/material.dart';

/// Extension methods to simplify working with [TextStyle] objects.
extension TextStyleExtensions on TextStyle? {
  /// Sets the font weight of the text style.
  TextStyle? weight(FontWeight v) => this?.copyWith(fontWeight: v);

  // === Weights ===
  /// Sets the font weight to thin.
  TextStyle? get thin => weight(FontWeight.w100);

  /// Sets the font weight to extra light.
  TextStyle? get extraLight => weight(FontWeight.w200);

  /// Sets the font weight to light.
  TextStyle? get light => weight(FontWeight.w300);

  /// Sets the font weight to normal.
  TextStyle? get regular => weight(FontWeight.normal);

  /// Sets the font weight to medium.
  TextStyle? get medium => weight(FontWeight.w500);

  /// Sets the font weight to semi-bold.
  TextStyle? get semiBold => weight(FontWeight.w600);

  /// Sets the font weight to bold.
  TextStyle? get bold => weight(FontWeight.w700);

  /// Sets the font weight to extra-bold.
  TextStyle? get extraBold => weight(FontWeight.w800);

  /// Sets the font weight to black.
  TextStyle? get black => weight(FontWeight.w900);

  /// Shortcut for color
  TextStyle? withColor(Color v) => this?.copyWith(color: v);

  /// Shortcut for height
  TextStyle? height(double v) => this?.copyWith(height: v);

  /// Shortcut for ellipsis overflow
  TextStyle? get ellipsis => this?.copyWith(overflow: TextOverflow.ellipsis);
}
