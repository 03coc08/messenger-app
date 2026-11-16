import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_error_code.dart';
import 'api_error_handler.dart';
import 'api_exception.dart';
import 'api_response_handler.dart';

class ApiClient {
  ApiClient({
    required String baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
  }) : _baseUrl = baseUrl.trim().replaceAll(RegExp(r'/+$'), ''), // bỏ dấu / ở cuối
       _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;
  final Duration timeout;

  // Có token thì request nào cũng tự gắn vào header
  String? token;

  // Gọi khi bị 401 (hết phiên đăng nhập)
  void Function()? onUnauthorized;

  Future<ApiResponse> get(String path, {Map<String, String>? query}) {
    return _send('GET', path, query: query);
  }

  Future<ApiResponse> post(String path, {Object? body}) {
    return _send('POST', path, body: body);
  }

  Future<ApiResponse> put(String path, {Object? body}) {
    return _send('PUT', path, body: body);
  }

  Future<ApiResponse> delete(String path, {Object? body}) {
    return _send('DELETE', path, body: body);
  }

  Future<ApiResponse> _send(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
  }) async {
    final request = _buildRequest(method, path, body: body, query: query);

    final http.Response res;
    try {
      final streamed = await _client.send(request).timeout(timeout);
      res = await http.Response.fromStream(streamed);
    } catch (e, stack) {
      throw handleRequestError(e, stack);
    }

    if (kDebugMode) {
      debugPrint('[$method] ${request.url} -> ${res.statusCode}');
    }
    return handleResponse(res, onUnauthorized: onUnauthorized);
  }

  http.Request _buildRequest(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
  }) {
    Uri uri;
    try {
      uri = Uri.parse('$_baseUrl$path');
    } on FormatException {
      throw ApiException.fromCode(ApiErrorCode.invalidUrl);
    }

    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: query);
    }

    final request = http.Request(method, uri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['ngrok-skip-browser-warning'] = 'true';
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (body != null) {
      request.body = jsonEncode(body);
    }
    return request;
  }
}
