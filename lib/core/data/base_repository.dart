import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

/// Base abstract class for repositories handling basic CRUD operations.
/// [TEntity] is the domain entity type.
/// [TModel] is the data model type (e.g., HiveObject).
abstract class BaseRepository<TEntity, TModel> {
  @protected
  final Box<TModel> _box;

  const BaseRepository(this._box);

  /// Converts an entity to its corresponding data model.
  @protected
  TModel entityToModel(TEntity entity);

  /// Converts a data model to its corresponding entity.
  @protected
  TEntity modelToEntity(TModel model);

  /// Returns the unique ID of an entity.
  @protected
  String getEntityId(TEntity entity);

  /// Returns the unique ID of a model.
  @protected
  String getModelId(TModel model);

  /// Inserts or updates an entity in the repository.
  Future<void> upsert(TEntity entity) async {
    final model = entityToModel(entity);
    await _box.put(getModelId(model), model);
  }

  /// Inserts or updates multiple entities in the repository.
  Future<void> upsertMany(Iterable<TEntity> entities) async {
    final Map<String, TModel> map = {
      for (var e in entities) getEntityId(e): entityToModel(e)
    };
    await _box.putAll(map);
  }

  /// Deletes an entity by its ID.
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Retrieves an entity by its ID.
  TEntity? getById(String id) {
    final model = _box.get(id);
    return model != null ? modelToEntity(model) : null;
  }

  /// Retrieves all entities.
  List<TEntity> all() => _box.values.map((e) => modelToEntity(e)).toList();

  /// Watches all entities for changes.
  Stream<List<TEntity>> watchAll() async* {
    List<TEntity> snapshot() => all();
    yield snapshot();
    await for (final _ in _box.watch()) {
      yield snapshot();
    }
  }
}

/// Extends [BaseRepository] with sorting capabilities.
abstract class BaseSortedRepository<TEntity, TModel> extends BaseRepository<TEntity, TModel> {
  const BaseSortedRepository(super._box);

  /// Returns the name of an entity for sorting.
  @protected
  String _getName(TEntity entity);

  /// Returns the creation date of an entity for sorting.
  @protected
  DateTime? _getDate(TEntity entity);

  /// Retrieves all entities sorted by name (case-insensitive).
  List<TEntity> allSortedByName() {
    final list = all();
    list.sort((a, b) => _getName(a).toLowerCase().compareTo(_getName(b).toLowerCase()));
    return list;
  }

  /// Retrieves all entities sorted by creation date (descending).
  List<TEntity> allSortedByDate() {
    final list = all();
    list.sort((a, b) => (_getDate(b)?.compareTo(_getDate(a) ?? DateTime.now()) ?? 0));
    return list;
  }
}

/// Extends [BaseRepository] with soft delete capabilities.
abstract class BaseSoftDeleteRepository<TEntity, TModel> extends BaseRepository<TEntity, TModel> {
  const BaseSoftDeleteRepository(super._box);

  /// Checks if a model is marked as deleted.
  @protected
  bool isModelDeleted(TModel model);

  /// Marks a model as deleted.
  @protected
  TModel markModelAsDeleted(TModel model);

  /// Marks a model as not deleted.
  @protected
  TModel markModelAsNotDeleted(TModel model);

  /// Soft deletes an entity by marking it as deleted.
  @override
  Future<void> delete(String id) async {
    final model = _box.get(id);
    if (model != null) {
      await _box.put(id, markModelAsDeleted(model));
    }
  }

  /// Hard deletes an entity by its ID.
  Future<void> deleteHard(String id) async {
    await super.delete(id);
  }

  /// Restores a soft-deleted entity.
  Future<void> restore(String id) async {
    final model = _box.get(id);
    if (model != null && isModelDeleted(model)) {
      await _box.put(id, markModelAsNotDeleted(model));
    }
  }

  @override
  List<TEntity> all({bool includeDeleted = false}) {
    final allModels = _box.values.where((model) => includeDeleted || !isModelDeleted(model));
    return allModels.map((e) => modelToEntity(e)).toList();
  }

  @override
  Stream<List<TEntity>> watchAll({bool includeDeleted = false}) async* {
    List<TEntity> snapshot() => all(includeDeleted: includeDeleted);
    yield snapshot();
    await for (final _ in _box.watch()) {
      yield snapshot();
    }
  }
}
