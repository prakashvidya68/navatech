import 'package:hive_flutter/hive_flutter.dart';
import 'cache_service.dart';

class CacheServiceImpl implements CacheService {
  static const String _defaultBoxName = 'default';
  late Box _defaultBox;
  final Map<String, Box> _boxes = {};

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _defaultBox = await Hive.openBox(_defaultBoxName);
  }

  @override
  Future<void> put<T>(String key, T value) async {
    try {
      await _defaultBox.put(key, value);
    } catch (e) {
      throw Exception('Failed to put value in cache: $e');
    }
  }

  @override
  Future<T?> get<T>(String key) async {
    try {
      return _defaultBox.get(key) as T?;
    } catch (e) {
      throw Exception('Failed to get value from cache: $e');
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _defaultBox.delete(key);
    } catch (e) {
      throw Exception('Failed to delete value from cache: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _defaultBox.clear();
      // Clear all other boxes
      for (final box in _boxes.values) {
        await box.clear();
      }
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      return _defaultBox.containsKey(key);
    } catch (e) {
      throw Exception('Failed to check if key exists in cache: $e');
    }
  }

  @override
  Future<List<T>> getAll<T>(String boxName) async {
    try {
      Box box = await _getOrCreateBox(boxName);
      return box.values.cast<T>().toList();
    } catch (e) {
      throw Exception('Failed to get all values from cache: $e');
    }
  }

  @override
  Future<void> putAll<T>(String boxName, List<T> values) async {
    try {
      Box box = await _getOrCreateBox(boxName);
      await box.clear(); // Clear existing values
      await box.addAll(values);
    } catch (e) {
      throw Exception('Failed to put all values in cache: $e');
    }
  }

  Future<Box> _getOrCreateBox(String boxName) async {
    if (_boxes.containsKey(boxName)) {
      return _boxes[boxName]!;
    }

    final box = await Hive.openBox(boxName);
    _boxes[boxName] = box;
    return box;
  }

  Future<void> close() async {
    try {
      await _defaultBox.close();
      for (final box in _boxes.values) {
        await box.close();
      }
      _boxes.clear();
    } catch (e) {
      throw Exception('Failed to close cache: $e');
    }
  }
}
