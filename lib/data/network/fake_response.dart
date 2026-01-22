import 'package:dio/dio.dart';

class FakeResponseConfig {
  final dynamic data;
  final String? message;
  final bool success;
  final int errorCode;
  final int statusCode;
  final int waitSeconds;

  FakeResponseConfig({
    required this.data,
    this.message,
    this.success = true,
    this.errorCode = 0,
    this.statusCode = 200,
    this.waitSeconds = 2,
  });
}

class FakeDio {
  FakeResponseConfig fakeResponses;

  FakeDio({required this.fakeResponses});

  Future<Response> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _buildFakeResponse(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
    );
  }

  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _buildFakeResponse(
      method: 'POST',
      path: path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _buildFakeResponse(
      method: 'PUT',
      path: path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _buildFakeResponse(
      method: 'DELETE',
      path: path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> _buildFakeResponse({
    required String method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final FakeResponseConfig config = fakeResponses;
    await Future.delayed(Duration(seconds: config.waitSeconds));

    return Response(
      requestOptions: RequestOptions(
        path: path,
        method: method,
        data: data,
        queryParameters: queryParameters,
      ),
      statusCode: config.statusCode,
      statusMessage: "OK",
      data: {
        "success": config.success,
        "message": config.message,
        "error_code": config.errorCode,
        "data": _normalizeData(config.data),
      },
    );
  }

  dynamic _normalizeData(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) return data;
    if (data is List) {
      return data.map((e) {
        if (e is Map<String, dynamic>) return e;
        try {
          return e.toJson(); // har bir element
        } catch (_) {
          return e;
        }
      }).toList();
    }
    try {
      return data.toJson();
    } catch (_) {
      return data;
    }
  }
}
