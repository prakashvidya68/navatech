import 'package:hive_flutter/hive_flutter.dart';
import 'cache_service.dart';

class CacheServiceImpl implements CacheService {
  static const String _defaultBoxName = 'default_cache';

  // Singleton instance
  static CacheServiceImpl? _instance;

  factory CacheServiceImpl() {
    _instance ??= CacheServiceImpl._internal();
    return _instance!;
  }

  // Private constructor
  CacheServiceImpl._internal();

  Box? _defaultBox;
  final Map<String, Box> _boxes = {};

  @override
  Future<void> init() async {
    // Open default box
    _defaultBox = await Hive.openBox(_defaultBoxName);
  }

  @override
  Future<void> put<T>(String key, T value) async {
    if (_defaultBox == null) {
      throw Exception('Cache service not initialized. Call init() first.');
    }

    await _defaultBox!.put(key, value);
  }

  @override
  Future<T?> get<T>(String key) async {
    if (_defaultBox == null) {
      throw Exception('Cache service not initialized. Call init() first.');
    }

    return _defaultBox!.get(key) as T?;
  }

  @override
  Future<void> delete(String key) async {
    if (_defaultBox == null) {
      throw Exception('Cache service not initialized. Call init() first.');
    }

    await _defaultBox!.delete(key);
  }

  @override
  Future<void> clear() async {
    if (_defaultBox == null) {
      throw Exception('Cache service not initialized. Call init() first.');
    }

    await _defaultBox!.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    if (_defaultBox == null) {
      throw Exception('Cache service not initialized. Call init() first.');
    }

    return _defaultBox!.containsKey(key);
  }

  @override
  Future<List<T>> getAll<T>(String boxName) async {
    Box box = await _getOrCreateBox(boxName);
    return box.values.cast<T>().toList();
  }

  @override
  Future<void> putAll<T>(String boxName, List<T> values) async {
    Box box = await _getOrCreateBox(boxName);

    // Clear existing data and add new values
    await box.clear();

    // Add values with auto-generated keys
    for (int i = 0; i < values.length; i++) {
      await box.put(i, values[i]);
    }
  }

  /// Get or create a named box
  Future<Box> _getOrCreateBox(String boxName) async {
    if (_boxes.containsKey(boxName)) {
      return _boxes[boxName]!;
    }

    Box box = await Hive.openBox(boxName);
    _boxes[boxName] = box;
    return box;
  }

  /// Close all boxes and dispose resources
  Future<void> dispose() async {
    await _defaultBox?.close();
    _defaultBox = null;

    for (Box box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }
}
