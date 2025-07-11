abstract class CacheService {
  Future<void> init();
  Future<void> put<T>(String key, T value);
  Future<T?> get<T>(String key);
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
  Future<List<T>> getAll<T>(String boxName);
  Future<void> putAll<T>(String boxName, List<T> values);
}
