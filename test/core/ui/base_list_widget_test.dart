import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/ui/base_list_widget.dart';
import 'package:flow/core/data/base_entity.dart';

// Test entity for testing
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

// Test implementation of BaseListWidget
class TestListWidget extends BaseListWidget<TestEntity> {
  const TestListWidget({
    super.key,
    required super.items,
    super.itemBuilder,
    super.separatorBuilder,
    super.emptyWidget,
    super.emptyMessage,
    super.isLoading,
    super.hasMore,
    super.onLoadMore,
    super.padding,
    super.scrollController,
    super.shrinkWrap,
    super.physics,
  });

  @override
  Widget _buildList(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      controller: scrollController,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (ctx, i) => (itemBuilder ?? _defaultItemBuilder)(ctx, items[i], i),
    );
  }

  @override
  Widget _buildMasonryGrid(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      controller: scrollController,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (ctx, i) => (itemBuilder ?? _defaultItemBuilder)(ctx, items[i], i),
    );
  }

  @override
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(emptyMessage ?? 'No items found'),
    );
  }

  @override
  Widget _defaultItemBuilder(BuildContext context, TestEntity item, int index) {
    return ListTile(title: Text(item.name));
  }
}

void main() {
  group('BaseListWidget', () {
    testWidgets('should render list of items', (WidgetTester tester) async {
      final items = List.generate(5, (i) => TestEntity(
        id: 'item_$i',
        name: 'Item $i',
        value: i,
      ));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestListWidget(items: items),
          ),
        ),
      );

      for (int i = 0; i < 5; i++) {
        expect(find.text('Item $i'), findsOneWidget);
      }
    });

    testWidgets('should render empty widget when no items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestListWidget(
              items: const [],
              emptyWidget: const Text('No items'),
            ),
          ),
        ),
      );

      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('should render loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestListWidget(
              items: const [],
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle custom padding', (WidgetTester tester) async {
      final items = List.generate(3, (i) => TestEntity(
        id: 'item_$i',
        name: 'Item $i',
        value: i,
      ));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestListWidget(
              items: items,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      );

      for (int i = 0; i < 3; i++) {
        expect(find.text('Item $i'), findsOneWidget);
      }
    });

    testWidgets('should handle custom item builder', (WidgetTester tester) async {
      final items = List.generate(3, (i) => TestEntity(
        id: 'item_$i',
        name: 'Item $i',
        value: i,
      ));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TestListWidget(
              items: items,
              itemBuilder: (context, item, index) => Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('Value: ${item.value}'),
                ),
              ),
            ),
          ),
        ),
      );

      for (int i = 0; i < 3; i++) {
        expect(find.text('Item $i'), findsOneWidget);
        expect(find.text('Value: $i'), findsOneWidget);
      }
    });
  });
}
