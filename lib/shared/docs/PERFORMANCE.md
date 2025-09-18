# ⚡ Performance Guide

Comprehensive guide to optimizing performance with Pocketa UI Components.

## 📋 Table of Contents

- [Performance Features](#performance-features)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)
- [Performance Monitoring](#performance-monitoring)
- [Optimization Techniques](#optimization-techniques)

---

## Performance Features

### RepaintBoundary

All heavy widgets are automatically wrapped with `RepaintBoundary` to prevent unnecessary repaints.

```dart
// Automatically applied to all components
CustomAppBar(
  title: 'Dashboard',
  // RepaintBoundary is automatically applied
)
```

### OptimizedWidget

Prevents unnecessary rebuilds by isolating widget updates.

```dart
OptimizedWidget(
  cacheKey: 'transaction_list',
  child: ListView.builder(
    itemBuilder: (context, index) => TransactionTile(),
  ),
)
```

### MemoizedWidget

Caches expensive computations to avoid recalculation.

```dart
MemoizedWidget(
  dependencies: [data, filter],
  builder: () => ExpensiveComputationWidget(data, filter),
)
```

### InteractiveWrapper

Provides haptic feedback and animations with performance optimizations.

```dart
InteractiveWrapper(
  onTap: () => handleTap(),
  enableHaptic: true,
  child: MyWidget(),
)
```

---

## Best Practices

### 1. Use Appropriate Components

```dart
// ✅ Good: Use optimized list components
OptimizedListView(
  children: items,
  cacheKey: 'my_list',
)

// ❌ Avoid: Using basic ListView for large lists
ListView(children: items)
```

### 2. Implement Proper Caching

```dart
// ✅ Good: Cache expensive computations
MemoizedWidget(
  dependencies: [userData, filters],
  builder: () => ExpensiveFilteredList(userData, filters),
)

// ❌ Avoid: Recalculating on every build
Widget build(BuildContext context) {
  final filteredData = expensiveFilter(userData, filters);
  return FilteredList(data: filteredData);
}
```

### 3. Use Cache Keys

```dart
// ✅ Good: Use meaningful cache keys
OptimizedWidget(
  cacheKey: 'user_profile_${user.id}',
  child: UserProfile(user: user),
)

// ❌ Avoid: Generic or missing cache keys
OptimizedWidget(
  cacheKey: 'widget',
  child: UserProfile(user: user),
)
```

### 4. Optimize List Performance

```dart
// ✅ Good: Use optimized list components
OptimizedListView(
  children: transactionTiles,
  cacheKey: 'transaction_list',
  controller: scrollController,
)

// ❌ Avoid: Using basic ListView for large datasets
ListView(children: transactionTiles)
```

### 5. Minimize Widget Rebuilds

```dart
// ✅ Good: Extract static widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStaticHeader(), // Extracted to avoid rebuilds
        _buildDynamicContent(),
      ],
    );
  }

  Widget _buildStaticHeader() {
    return Container(
      height: 100,
      child: Text('Static Header'),
    );
  }
}

// ❌ Avoid: Inline static widgets
Widget build(BuildContext context) {
  return Column(
    children: [
      Container( // This rebuilds unnecessarily
        height: 100,
        child: Text('Static Header'),
      ),
      _buildDynamicContent(),
    ],
  );
}
```

---

## Common Pitfalls

### 1. Unnecessary Rebuilds

```dart
// ❌ Problem: Widget rebuilds on every parent rebuild
class MyWidget extends StatelessWidget {
  final String title;
  final List<String> items;

  MyWidget({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        ...items.map((item) => ListTile(title: Text(item))),
      ],
    );
  }
}

// ✅ Solution: Use OptimizedWidget
class MyWidget extends StatelessWidget {
  final String title;
  final List<String> items;

  MyWidget({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return OptimizedWidget(
      cacheKey: 'my_widget_$title',
      child: Column(
        children: [
          Text(title),
          ...items.map((item) => ListTile(title: Text(item))),
        ],
      ),
    );
  }
}
```

### 2. Expensive Computations in Build

```dart
// ❌ Problem: Expensive computation on every build
class MyWidget extends StatelessWidget {
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final total = transactions.fold(0.0, (sum, tx) => sum + tx.amount);
    final average = total / transactions.length;
    
    return Text('Average: \$${average.toStringAsFixed(2)}');
  }
}

// ✅ Solution: Use MemoizedWidget
class MyWidget extends StatelessWidget {
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return MemoizedWidget(
      dependencies: [transactions],
      builder: () {
        final total = transactions.fold(0.0, (sum, tx) => sum + tx.amount);
        final average = total / transactions.length;
        
        return Text('Average: \$${average.toStringAsFixed(2)}');
      },
    );
  }
}
```

### 3. Missing Cache Keys

```dart
// ❌ Problem: Missing or generic cache keys
OptimizedWidget(
  cacheKey: 'widget', // Too generic
  child: UserProfile(user: user),
)

// ✅ Solution: Use specific cache keys
OptimizedWidget(
  cacheKey: 'user_profile_${user.id}_${user.lastUpdated}',
  child: UserProfile(user: user),
)
```

### 4. Inefficient List Rendering

```dart
// ❌ Problem: Rendering all items at once
ListView(
  children: List.generate(10000, (index) => 
    ListTile(title: Text('Item $index'))
  ),
)

// ✅ Solution: Use ListView.builder with optimization
OptimizedListView(
  children: List.generate(10000, (index) => 
    OptimizedWidget(
      cacheKey: 'item_$index',
      child: ListTile(title: Text('Item $index')),
    )
  ),
  cacheKey: 'large_list',
)
```

---

## Performance Monitoring

### 1. Use Flutter Inspector

Enable Flutter Inspector to monitor widget rebuilds:

```dart
// Add to main.dart for debugging
void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      // Enable performance overlay
      showPerformanceOverlay: true,
    ),
  );
}
```

### 2. Monitor Memory Usage

```dart
// Add memory monitoring
class PerformanceMonitor {
  static void logMemoryUsage(String context) {
    if (kDebugMode) {
      print('Memory usage at $context: ${ProcessInfo.currentRss}');
    }
  }
}

// Use in widgets
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    PerformanceMonitor.logMemoryUsage('MyWidget init');
  }

  @override
  void dispose() {
    PerformanceMonitor.logMemoryUsage('MyWidget dispose');
    super.dispose();
  }
}
```

### 3. Profile Widget Rebuilds

```dart
// Add rebuild monitoring
class RebuildMonitor extends StatefulWidget {
  final Widget child;
  final String name;

  const RebuildMonitor({
    Key? key,
    required this.child,
    required this.name,
  }) : super(key: key);

  @override
  _RebuildMonitorState createState() => _RebuildMonitorState();
}

class _RebuildMonitorState extends State<RebuildMonitor> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    if (kDebugMode) {
      print('${widget.name} rebuilt $_rebuildCount times');
    }
    return widget.child;
  }
}
```

---

## Optimization Techniques

### 1. Lazy Loading

```dart
class LazyLoadedList extends StatefulWidget {
  @override
  _LazyLoadedListState createState() => _LazyLoadedListState();
}

class _LazyLoadedListState extends State<LazyLoadedList> {
  final List<String> _items = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return OptimizedListView(
      children: _items.map((item) => 
        OptimizedWidget(
          cacheKey: 'item_$item',
          child: ListTile(title: Text(item)),
        )
      ).toList(),
      onScrollEnd: _loadMoreItems,
    );
  }

  void _loadMoreItems() {
    if (!_isLoading) {
      setState(() => _isLoading = true);
      
      // Simulate loading
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _items.addAll(List.generate(20, (index) => 'Item ${_items.length + index}'));
          _isLoading = false;
        });
      });
    }
  }
}
```

### 2. Image Optimization

```dart
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OptimizedWidget(
      cacheKey: 'image_$imageUrl',
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return AppLoadingIndicator(
            size: 50,
            message: 'Loading image...',
            showMessage: true,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Icon(Icons.error),
          );
        },
      ),
    );
  }
}
```

### 3. Efficient State Management

```dart
class OptimizedCounter extends StatefulWidget {
  @override
  _OptimizedCounterState createState() => _OptimizedCounterState();
}

class _OptimizedCounterState extends State<OptimizedCounter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only rebuild the counter display
        OptimizedWidget(
          cacheKey: 'counter_display',
          child: Text(
            'Count: $_count',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SizedBox(height: 20),
        // Buttons don't need to rebuild
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton(
              text: 'Decrement',
              onPressed: () => setState(() => _count--),
            ),
            SizedBox(width: 20),
            AppButton(
              text: 'Increment',
              onPressed: () => setState(() => _count++),
            ),
          ],
        ),
      ],
    );
  }
}
```

### 4. Efficient Data Processing

```dart
class DataProcessor {
  static final Map<String, List<ProcessedData>> _cache = {};

  static List<ProcessedData> processData(List<RawData> rawData, String filter) {
    final cacheKey = '${rawData.length}_$filter';
    
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final processed = rawData
        .where((item) => item.category == filter)
        .map((item) => ProcessedData.fromRaw(item))
        .toList();

    _cache[cacheKey] = processed;
    return processed;
  }

  static void clearCache() {
    _cache.clear();
  }
}

// Usage in widget
class DataDisplay extends StatelessWidget {
  final List<RawData> rawData;
  final String filter;

  @override
  Widget build(BuildContext context) {
    return MemoizedWidget(
      dependencies: [rawData, filter],
      builder: () {
        final processedData = DataProcessor.processData(rawData, filter);
        return ListView.builder(
          itemCount: processedData.length,
          itemBuilder: (context, index) => 
            ListTile(title: Text(processedData[index].title)),
        );
      },
    );
  }
}
```

---

## Performance Checklist

### Before Development
- [ ] Identify heavy computations and data processing
- [ ] Plan widget hierarchy to minimize rebuilds
- [ ] Choose appropriate components for the use case
- [ ] Consider data caching strategies

### During Development
- [ ] Use `OptimizedWidget` for complex widgets
- [ ] Use `MemoizedWidget` for expensive computations
- [ ] Implement proper cache keys
- [ ] Use optimized list components for large datasets
- [ ] Extract static widgets to avoid unnecessary rebuilds

### After Development
- [ ] Test on different device sizes
- [ ] Monitor memory usage
- [ ] Check for memory leaks
- [ ] Profile widget rebuilds
- [ ] Test with large datasets

### Performance Testing
- [ ] Use Flutter Inspector
- [ ] Enable performance overlay
- [ ] Monitor memory usage
- [ ] Test scroll performance
- [ ] Check animation smoothness

---

## Common Performance Issues

### 1. Memory Leaks

```dart
// ❌ Problem: Not disposing controllers
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  // Missing dispose method - causes memory leak
}

// ✅ Solution: Proper disposal
class _MyWidgetState extends State<MyWidget> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose(); // Proper disposal
    super.dispose();
  }
}
```

### 2. Excessive Rebuilds

```dart
// ❌ Problem: Rebuilding entire widget tree
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Static Header'), // Rebuilds unnecessarily
        Text('Counter: $_counter'),
        AppButton(
          text: 'Increment',
          onPressed: () => setState(() => _counter++),
        ),
      ],
    );
  }
}

// ✅ Solution: Extract static widgets
class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StaticHeader(), // Extracted to avoid rebuilds
        Text('Counter: $_counter'),
        AppButton(
          text: 'Increment',
          onPressed: () => setState(() => _counter++),
        ),
      ],
    );
  }
}

class _StaticHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Static Header');
  }
}
```

---

**Built with ❤️ for the Pocketa app**
