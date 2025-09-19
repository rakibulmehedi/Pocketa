import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa/core/data/base_entity.dart';

// Test entity implementation
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

void main() {
  group('BaseEntity', () {
    test('should create entity with required fields', () {
      final entity = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
      );
      
      expect(entity.id, 'test-id');
      expect(entity.name, 'Test Name');
      expect(entity.value, 42);
      expect(entity.createdAt, null);
      expect(entity.updatedAt, null);
      expect(entity.isDeleted, false);
    });

    test('should create entity with all fields', () {
      final now = DateTime.now();
      final entity = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
        createdAt: now,
        updatedAt: now,
        isDeleted: true,
      );
      
      expect(entity.id, 'test-id');
      expect(entity.name, 'Test Name');
      expect(entity.value, 42);
      expect(entity.createdAt, now);
      expect(entity.updatedAt, now);
      expect(entity.isDeleted, true);
    });

    test('should test equality', () {
      final now = DateTime.now();
      final entity1 = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      
      final entity2 = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      
      final entity3 = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 43, // Different value
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      
      expect(entity1, equals(entity2));
      expect(entity1, isNot(equals(entity3)));
    });

    test('should test hashCode', () {
      final now = DateTime.now();
      final entity1 = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      
      final entity2 = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('should include all props in equality check', () {
      final now = DateTime.now();
      final entity1 = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
        createdAt: now,
        updatedAt: now,
        isDeleted: false,
      );
      
      final entity2 = TestEntity(
        id: 'test-id',
        name: 'Test Name',
        value: 42,
        createdAt: now,
        updatedAt: now,
        isDeleted: true, // Different isDeleted
      );
      
      expect(entity1, isNot(equals(entity2)));
    });
  });
}