import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_error_code.dart';
import 'api_exception.dart';

class ApiResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String> headers;

  ApiResponse(this.statusCode, this.data, this.headers);
}

ApiResponse handleResponse(
  http.Response res, {
  void Function()? onUnauthorized,
}) {
  final data = _decode(res.body);

  if (res.statusCode >= 200 && res.statusCode < 300) {
    return ApiResponse(res.statusCode, data, res.headers);
  }

  final code = _errorCode(res.statusCode, data, res.body);
  if (code == ApiErrorCode.sessionExpired) {
    onUnauthorized?.call();
  }

  throw ApiException.fromCode(code, statusCode: res.statusCode, data: data);
}

dynamic _decode(String body) {
  if (body.isEmpty) return null;
  try {
    return jsonDecode(body);
  } catch (_) {
    return null;
  }
}

ApiErrorCode _errorCode(int statusCode, dynamic data, String rawBody) {
  if (rawBody.trimLeft().startsWith('<')) {
    return ApiErrorCode.htmlResponse;
  }

  // Mattermost trả về "id" để biết loại lỗi
  String errorId = '';
  if (data is Map && data['id'] is String) {
    errorId = data['id'];
  }

  if (errorId.contains('invalid_credentials')) {
    return ApiErrorCode.invalidCredentials;
  }
  if (errorId.contains('session_expired') || statusCode == 401) {
    return ApiErrorCode.sessionExpired;
  }

  if (statusCode == 400) {
    return ApiErrorCode.badRequest;
  }
  if (statusCode == 403) {
    return ApiErrorCode.forbidden;
  }
  if (statusCode == 404) {
    return ApiErrorCode.notFound;
  }
  if (statusCode >= 500) {
    return ApiErrorCode.serverError;
  }
  return ApiErrorCode.http;
}
