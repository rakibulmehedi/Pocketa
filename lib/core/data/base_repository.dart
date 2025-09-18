import 'package:pocketa/core/data/base_entity.dart';

/// Base repository interface with common CRUD operations
abstract class BaseRepository<T> {
  // Mutations
  Future<void> upsert(T entity);
  Future<void> upsertMany(Iterable<T> entities);
  Future<void> deleteHard(String id);
  Future<void> deleteSoft(String id);

  // Reads
  T? getById(String id);
  List<T> all({bool includeDeleted = false});
  Stream<List<T>> watchAll({bool includeDeleted = false});

  // Common filters
  List<T> findByField<R>(String fieldName, R value, {bool includeDeleted = false});
  List<T> findByDateRange(
    DateTime from,
    DateTime to, {
    String? fieldName,
    bool includeDeleted = false,
  });
}

/// Base repository implementation with common logic
abstract class BaseRepositoryImpl<T, M> implements BaseRepository<T> {
  final dynamic _box; // Hive box or other storage

  const BaseRepositoryImpl(this._box);

  /// Get the storage box (accessible to derived classes)
  dynamic get box => _box;

  // Abstract methods to be implemented by concrete repositories
  T modelToEntity(M model);
  M entityToModel(T entity);
  String get entityIdField;
  
  // Helper methods for soft delete and field access
  T _markAsDeleted(T entity);
  dynamic _getFieldValue(T entity, String fieldName);
  
  // Helper methods to check entity properties
  bool _isDeleted(T entity) {
    if (entity is BaseEntity) {
      return entity.isDeleted;
    }
    // For entities that don't extend BaseEntity, check if they have isDeleted property
    try {
      final dynamic entityDynamic = entity;
      return entityDynamic.isDeleted as bool? ?? false;
    } catch (e) {
      return false;
    }
  }
  
  String _getId(T entity) {
    if (entity is BaseEntity) {
      return entity.id;
    }
    // For entities that don't extend BaseEntity, check if they have id property
    try {
      final dynamic entityDynamic = entity;
      return entityDynamic.id as String;
    } catch (e) {
      throw StateError('Entity must have an id property');
    }
  }

  @override
  Future<void> upsert(T entity) async {
    final model = entityToModel(entity);
    await _box.put(_getId(entity), model);
  }

  @override
  Future<void> upsertMany(Iterable<T> entities) async {
    final Map<String, M> models = {};
    for (final entity in entities) {
      models[_getId(entity)] = entityToModel(entity);
    }
    await _box.putAll(models);
  }

  @override
  Future<void> deleteHard(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> deleteSoft(String id) async {
    final entity = getById(id);
    if (entity != null) {
      final updatedEntity = _markAsDeleted(entity);
      await upsert(updatedEntity);
    }
  }

  @override
  T? getById(String id) {
    final model = _box.get(id);
    return model != null ? modelToEntity(model) : null;
  }

  @override
  List<T> all({bool includeDeleted = false}) {
    return _box.values
        .map((model) => modelToEntity(model))
        .where((entity) => includeDeleted || !_isDeleted(entity))
        .toList();
  }

  @override
  Stream<List<T>> watchAll({bool includeDeleted = false}) async* {
    List<T> snapshot() => all(includeDeleted: includeDeleted);
    yield snapshot();
    await for (final _ in _box.watch()) {
      yield snapshot();
    }
  }

  @override
  List<T> findByField<R>(String fieldName, R value, {bool includeDeleted = false}) {
    return all(includeDeleted: includeDeleted)
        .where((entity) => _getFieldValue(entity, fieldName) == value)
        .toList();
  }

  @override
  List<T> findByDateRange(
    DateTime from,
    DateTime to, {
    String? fieldName = 'createdAt',
    bool includeDeleted = false,
  }) {
    return all(includeDeleted: includeDeleted)
        .where((entity) {
          final date = _getFieldValue(entity, fieldName ?? 'createdAt') as DateTime?;
          if (date == null) return false;
          return date.isAfter(from) && date.isBefore(to);
        })
        .toList();
  }

}