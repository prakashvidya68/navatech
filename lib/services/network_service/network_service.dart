abstract class NetworkService {
  Future<Map<String, dynamic>> get(String endpoint);
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  });
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
  });
  Future<Map<String, dynamic>> delete(String endpoint);
}
