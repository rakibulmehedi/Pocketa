import 'package:equatable/equatable.dart';

/// Base interface for all entities in the application.
/// Provides common fields like `id`, `createdAt`, `updatedAt`, and `isDeleted`.
abstract class BaseEntity extends Equatable {
  String get id;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  bool get isDeleted;

  @override
  List<Object?> get props => [id, createdAt, updatedAt, isDeleted];

  /// Check if entity is active (not deleted)
  bool get isActive => !isDeleted;

  /// Get creation date or current time if null
  DateTime get effectiveCreatedAt => createdAt ?? DateTime.now().toUtc();

  /// Get update date or creation date if null
  DateTime get effectiveUpdatedAt => updatedAt ?? effectiveCreatedAt;
}

/// Base implementation for entities that don't use Freezed
abstract class BaseEntityImpl extends BaseEntity {
  @override
  final String id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final bool isDeleted;

  BaseEntityImpl({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
  });
}

/// Mixin for Freezed entities to implement BaseEntity interface
mixin BaseEntityMixin on Object {
  String get id;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  bool get isDeleted;

  /// Check if entity is active (not deleted)
  bool get isActive => !isDeleted;

  /// Get creation date or current time if null
  DateTime get effectiveCreatedAt => createdAt ?? DateTime.now().toUtc();

  /// Get update date or creation date if null
  DateTime get effectiveUpdatedAt => updatedAt ?? effectiveCreatedAt;

  /// Get props for Equatable
  List<Object?> get effectiveProps => [id, createdAt, updatedAt, isDeleted];
}