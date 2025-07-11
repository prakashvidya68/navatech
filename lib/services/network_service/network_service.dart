import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

/// Abstract class defining the contract for network operations
abstract class NetworkService {
  /// Base URL for the API
  String get baseUrl;

  /// Default headers for all requests
  Map<String, String> get defaultHeaders;

  /// Connection timeout duration in seconds
  Duration get connectionTimeout;

  /// Receive timeout duration in seconds
  Duration get receiveTimeout;

  /// Performs a GET request
  Future<Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  /// Performs a POST request
  Future<Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  });
}
