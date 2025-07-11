import 'package:dio/dio.dart';
import 'package:navatech_assignment/services/network_service/network_service.dart';

class NetworkServiceImpl implements NetworkService {
  static NetworkServiceImpl? _instance;

  late final Dio _dio;

  NetworkServiceImpl._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: defaultHeaders,
        connectTimeout: connectionTimeout,
        receiveTimeout: receiveTimeout,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          print(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          handler.next(error);
        },
      ),
    );
  }

  /// Factory constructor to ensure singleton pattern
  factory NetworkServiceImpl() {
    return _instance ??= NetworkServiceImpl._internal();
  }

  /// Alternative factory constructor with explicit singleton access
  static NetworkServiceImpl get instance {
    return _instance ??= NetworkServiceImpl._internal();
  }

  @override
  String get baseUrl => 'https://jsonplaceholder.typicode.com';

  @override
  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Duration get connectionTimeout => const Duration(seconds: 30);

  @override
  Duration get receiveTimeout => const Duration(seconds: 30);

  @override
  Future<Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: headers != null ? Options(headers: headers) : null,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        options: headers != null ? Options(headers: headers) : null,
        queryParameters: queryParameters,
        data: body,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.statusMessage ?? 'Bad response';
        return Exception('HTTP $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      case DioExceptionType.badCertificate:
        return Exception('Bad certificate');
      case DioExceptionType.unknown:
      default:
        return Exception('Unknown error: ${error.message}');
    }
  }
}
