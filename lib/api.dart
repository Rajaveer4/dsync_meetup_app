import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://your-api-url.com/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      requestBody: true,
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data['message'] ?? e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data['message'] ?? e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data['message'] ?? e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw ApiException(
        e.response?.data['message'] ?? e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Response> uploadFile(String path, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      return await _dio.post(path, data: formData);
    } on DioException catch (e) {
      throw ApiException('Upload failed: ${e.message}');
    }
  }
}