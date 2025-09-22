import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/core/providers/base_providers.dart';
import 'package:flow/core/data/base_entity.dart';
import 'package:flow/core/data/base_repository.dart';

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

// Test repository
class TestRepository extends BaseRepositoryImpl<TestEntity, TestEntity> {
  TestRepository(super.box);

  @override
  TestEntity modelToEntity(TestEntity model) => model;

  @override
  TestEntity entityToModel(TestEntity entity) => entity;

  @override
  String get entityIdField => 'id';

  @override
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

  @override
  dynamic _getFieldValue(TestEntity entity, String fieldName) {
    switch (fieldName) {
      case 'name': return entity.name;
      case 'value': return entity.value;
      case 'createdAt': return entity.createdAt;
      default: return null;
    }
  }
}

// Test state notifier
class TestStateNotifier extends BaseStateNotifier<int> {
  TestStateNotifier() : super(0);

  void increment() => state = state + 1;
  void decrement() => state = state - 1;
}

void main() {
  group('BaseProviders', () {
    test('should create repository provider', () {
      final repositoryProvider = BaseProviders.repositoryProvider<TestRepository, TestEntity>(
        (ref) => TestRepository(null),
      );
      
      expect(repositoryProvider, isA<Provider<TestRepository>>());
    });

    test('should create all entities provider', () {
      final repositoryProvider = Provider<TestRepository>((ref) => TestRepository(null));
      final allEntitiesProvider = BaseProviders.allEntitiesProvider<TestEntity>(repositoryProvider);
      
      expect(allEntitiesProvider, isA<AutoDisposeStreamProvider<List<TestEntity>>>());
    });

    test('should create entity by id provider', () {
      final repositoryProvider = Provider<TestRepository>((ref) => TestRepository(null));
      final entityByIdProvider = BaseProviders.entityByIdProvider<TestEntity>(repositoryProvider);
      
      expect(entityByIdProvider, isA<AutoDisposeProviderFamily<TestEntity?, String?>>());
    });

    test('should create filtered entities provider', () {
      final repositoryProvider = Provider<TestRepository>((ref) => TestRepository(null));
      final filteredEntitiesProvider = BaseProviders.filteredEntitiesProvider<TestEntity>(repositoryProvider);
      
      expect(filteredEntitiesProvider, isA<AutoDisposeProviderFamily<List<TestEntity>, Map<String, dynamic>>>());
    });
  });

  group('BaseStateNotifier', () {
    test('should create state notifier with initial state', () {
      final notifier = TestStateNotifier();
      
      expect(notifier.state, 0);
    });

    test('should update state', () {
      final notifier = TestStateNotifier();
      
      notifier.increment();
      expect(notifier.state, 1);
      
      notifier.increment();
      expect(notifier.state, 2);
      
      notifier.decrement();
      expect(notifier.state, 1);
    });
  });
}