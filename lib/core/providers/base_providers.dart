import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/core/data/base_entity.dart';
import 'package:flow/core/data/base_repository.dart';

/// Base provider factory for creating common repository providers
class BaseProviders {
  /// Create a repository provider
  static Provider<R> repositoryProvider<R extends BaseRepository<T>, T extends BaseEntity>(
    R Function(Ref ref) factory,
  ) {
    return Provider<R>(factory);
  }

  /// Create a stream provider for all entities
  static AutoDisposeStreamProvider<List<T>> allEntitiesProvider<T extends BaseEntity>(
    Provider<BaseRepository<T>> repositoryProvider,
  ) {
    return StreamProvider.autoDispose<List<T>>((ref) {
      final repository = ref.watch(repositoryProvider);
      return repository.watchAll();
    });
  }

  /// Create a family provider for getting entity by ID
  static AutoDisposeProviderFamily<T?, String?> entityByIdProvider<T extends BaseEntity>(
    Provider<BaseRepository<T>> repositoryProvider,
  ) {
    return Provider.family.autoDispose<T?, String?>((ref, id) {
      if (id == null) return null;
      final repository = ref.watch(repositoryProvider);
      return repository.getById(id);
    });
  }

  /// Create a filtered entities provider
  static AutoDisposeProviderFamily<List<T>, Map<String, dynamic>> filteredEntitiesProvider<T extends BaseEntity>(
    Provider<BaseRepository<T>> repositoryProvider,
  ) {
    return Provider.family.autoDispose<List<T>, Map<String, dynamic>>((ref, filters) {
      final repository = ref.watch(repositoryProvider);
      var entities = repository.all(includeDeleted: filters['includeDeleted'] ?? false);
      
      // Apply filters
      if (filters['fieldName'] != null && filters['value'] != null) {
        entities = repository.findByField(
          filters['fieldName'],
          filters['value'],
          includeDeleted: filters['includeDeleted'] ?? false,
        );
      }
      
      if (filters['from'] != null && filters['to'] != null) {
        entities = repository.findByDateRange(
          filters['from'],
          filters['to'],
          fieldName: filters['dateField'] ?? 'createdAt',
          includeDeleted: filters['includeDeleted'] ?? false,
        );
      }
      
      return entities;
    });
  }
}

/// Base state notifier for common state management patterns
abstract class BaseStateNotifier<T> extends StateNotifier<T> {
  BaseStateNotifier(super.initialState);

  /// Handle async operations with loading state
  Future<void> handleAsyncOperation(
    Future<void> Function() operation, {
    void Function()? onSuccess,
    void Function(Object error)? onError,
  }) async {
    try {
      await operation();
      onSuccess?.call();
    } catch (error) {
      onError?.call(error);
    }
  }

  /// Update state safely
  void updateState(T newState) {
    if (mounted) {
      state = newState;
    }
  }
}

/// Common state mixin for loading and error states
mixin LoadingStateMixin<T> on StateNotifier<T> {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    if (mounted) {
      // Trigger rebuild by updating state
      state = state;
    }
  }

  void setError(String? error) {
    _error = error;
    if (mounted) {
      // Trigger rebuild by updating state
      state = state;
    }
  }

  void clearError() {
    setError(null);
  }
}
