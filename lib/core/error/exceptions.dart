class ServerException implements Exception {
  const ServerException([this.message = 'Server exception']);

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  const CacheException([this.message = 'Cache exception']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
