// Standardized exception definitions (placeholder for future use)

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error']);
  @override
  String toString() => 'CacheException: $message';
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'Database error']);
  @override
  String toString() => 'DatabaseException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error']);
  @override
  String toString() => 'NetworkException: $message';
}

