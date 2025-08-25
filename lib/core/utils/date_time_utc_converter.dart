import 'package:freezed_annotation/freezed_annotation.dart';

class DateTimeUtcConverter implements JsonConverter<DateTime, String> {
  const DateTimeUtcConverter();
  @override
  DateTime fromJson(String json) => DateTime.parse(json).toUtc();
  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

class NullableDateTimeUtcConverter
    implements JsonConverter<DateTime?, String?> {
  const NullableDateTimeUtcConverter();
  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json).toUtc();
  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}
