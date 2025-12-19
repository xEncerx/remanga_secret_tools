import 'dart:convert';

import 'package:drift/drift.dart';

/// A [TypeConverter] for JSONB objects.
class JsonBTypeConverter<T> extends TypeConverter<T, Object> {
  /// Creates a new [JsonBTypeConverter].
  const JsonBTypeConverter(this.fromJson, this.toJson);

  /// Converts a JSON string to a [T] object.
  final T Function(Map<String, dynamic> json) fromJson;

  /// Converts a [T] object to a JSON string.
  final Map<String, dynamic> Function(T value) toJson;

  @override
  T fromSql(Object fromDb) {
    if (fromDb is Map) {
      return fromJson(Map<String, dynamic>.from(fromDb));
    }
    if (fromDb is String) {
      return fromJson(jsonDecode(fromDb) as Map<String, dynamic>);
    }
    
    throw ArgumentError('Unexpected type: ${fromDb.runtimeType}');
  }

  @override
  Object toSql(T value) => json.encode(toJson(value));
}
