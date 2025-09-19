import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/data/base_repository.dart';
import 'package:pocketa/core/data/base_entity.dart';

// Test entity
class TestEntity extends BaseEntityImpl {
  final String name;
  final int value;

  TestEntity({
    required super.id,
    required this.name,
    required this.value,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
  });

  @override
  List<Object?> get props => [...super.props, name, value];
}

// Test model (same as entity for simplicity)
class TestModel {
  final String id;
  final String name;
  final int value;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;

  TestModel({
    required this.id,
    required this.name,
    required this.value,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
  });

  TestEntity toEntity() => TestEntity(
    id: id,
    name: name,
    value: value,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isDeleted: isDeleted,
  );
}

// Test repository implementation
class TestRepositoryImpl extends BaseRepositoryImpl<TestEntity, TestModel> {
  TestRepositoryImpl(super.box);

  @override
  TestEntity modelToEntity(TestModel model) => model.toEntity();

  @override
  TestModel entityToModel(TestEntity entity) => TestModel(
    id: entity.id,
    name: entity.name,
    value: entity.value,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    isDeleted: entity.isDeleted,
  );

  @override
  String get entityIdField => 'id';

  TestEntity _markAsDeleted(TestEntity entity) {
    return TestEntity(
      id: entity.id,
      name: entity.name,
      value: entity.value,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isDeleted: true,
    );
  }

  dynamic _getFieldValue(TestEntity entity, String fieldName) {
    switch (fieldName) {
      case 'name': return entity.name;
      case 'value': return entity.value;
      case 'createdAt': return entity.createdAt;
      default: return null;
    }
  }
}

// Mock box for testing
class MockBox {
  final Map<String, TestModel> _data = {};

  TestModel? get(String key) => _data[key];
  
  Future<void> put(String key, TestModel value) async {
    _data[key] = value;
  }
  
  Future<void> putAll(Map<String, TestModel> values) async {
    _data.addAll(values);
  }
  
  Future<void> delete(String key) async {
    _data.remove(key);
  }
  
  Iterable<TestModel> get values => _data.values;
  
  Stream<void> watch() async* {
    // Mock stream for testing
  }
}

void main() {
  group('BaseRepositoryImpl', () {
    late TestRepositoryImpl repository;
    late MockBox mockBox;

    setUp(() {
      mockBox = MockBox();
      repository = TestRepositoryImpl(mockBox);
    });

    test('should upsert entity', () async {
      final entity = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
      );
      
      await repository.upsert(entity);
      
      final retrieved = repository.getById('test-id');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'test-id');
      expect(retrieved.name, 'Test Name');
      expect(retrieved.value, 42);
    });

    test('should upsert many entities', () async {
      final entities = [
        TestEntity(id: 'id1', name: 'Name 1', value: 1),
        TestEntity(id: 'id2', name: 'Name 2', value: 2),
        TestEntity(id: 'id3', name: 'Name 3', value: 3),
      ];
      
      await repository.upsertMany(entities);
      
      final all = repository.all();
      expect(all.length, 3);
      expect(all.map((e) => e.id), containsAll(['id1', 'id2', 'id3']));
    });

    test('should delete hard', () async {
      final entity = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
      );
      
      await repository.upsert(entity);
      expect(repository.getById('test-id'), isNotNull);
      
      await repository.deleteHard('test-id');
      expect(repository.getById('test-id'), isNull);
    });

    test('should delete soft', () async {
      final entity = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
      );
      
      await repository.upsert(entity);
      expect(repository.getById('test-id')!.isDeleted, false);
      
      await repository.deleteSoft('test-id');
      expect(repository.getById('test-id')!.isDeleted, true);
    });

    test('should get all entities', () async {
      final entities = [
        TestEntity(id: 'id1', name: 'Name 1', value: 1),
        TestEntity(id: 'id2', name: 'Name 2', value: 2),
        TestEntity(id: 'id3', name: 'Name 3', value: 3),
      ];
      
      await repository.upsertMany(entities);
      
      final all = repository.all();
      expect(all.length, 3);
    });

    test('should get all entities including deleted', () async {
      final entity = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
      );
      
      await repository.upsert(entity);
      await repository.deleteSoft('test-id');
      
      final all = repository.all();
      expect(all.length, 0);
      
      final allIncludingDeleted = repository.all(includeDeleted: true);
      expect(allIncludingDeleted.length, 1);
      expect(allIncludingDeleted.first.isDeleted, true);
    });

    test('should find by field', () async {
      final entities = [
        TestEntity(id: 'id1', name: 'Name 1', value: 1),
        TestEntity(id: 'id2', name: 'Name 2', value: 2),
        TestEntity(id: 'id3', name: 'Name 1', value: 3),
      ];
      
      await repository.upsertMany(entities);
      
      final found = repository.findByField('name', 'Name 1');
      expect(found.length, 2);
      expect(found.map((e) => e.id), containsAll(['id1', 'id3']));
    });

    test('should find by date range', () async {
      final now = DateTime.now();
      final entities = [
        TestEntity(
          id: 'id1',
          name: 'Name 1',
          value: 1,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        TestEntity(
          id: 'id2',
          name: 'Name 2',
          value: 2,
          createdAt: now,
        ),
        TestEntity(
          id: 'id3',
          name: 'Name 3',
          value: 3,
          createdAt: now.add(const Duration(days: 1)),
        ),
      ];
      
      await repository.upsertMany(entities);
      
      final found = repository.findByDateRange(
        now.subtract(const Duration(hours: 1)),
        now.add(const Duration(hours: 1)),
      );
      expect(found.length, 1);
      expect(found.first.id, 'id2');
    });

    test('should watch all entities', () async {
      final entities = [
        TestEntity(id: 'id1', name: 'Name 1', value: 1),
        TestEntity(id: 'id2', name: 'Name 2', value: 2),
      ];
      
      await repository.upsertMany(entities);
      
      final stream = repository.watchAll();
      final firstEmission = await stream.first;
      
      expect(firstEmission.length, 2);
      expect(firstEmission.map((e) => e.id), containsAll(['id1', 'id2']));
    });
  });
}
