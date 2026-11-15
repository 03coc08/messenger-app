import 'dart:convert';

import 'package:http/http.dart' as http;

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

  final code = _errorCode(res.statusCode, data);
  if (code == ApiErrorCode.sessionExpired) onUnauthorized?.call();

  // Mã đã biết thì dùng câu của mã; còn lại dùng câu suy ra từ response.
  if (code != ApiErrorCode.http) {
    throw ApiException.fromCode(code, statusCode: res.statusCode, data: data);
  }
  throw ApiException(
    _errorMessage(res.statusCode, data, res.body),
    code: ApiErrorCode.http,
    statusCode: res.statusCode,
    data: data,
  );
}

dynamic _decode(String body) {
  if (body.isEmpty) return null;
  try {
    return jsonDecode(body);
  } catch (_) {
    return null;
  }
}

String _errorMessage(int code, dynamic data, String rawBody) {
  if (data is Map && data['message'] is String) {
    return data['message'];
  }
  if (rawBody.trimLeft().startsWith('<')) {
    return 'Máy chủ trả về HTML thay vì JSON (mã $code). '
        'Kiểm tra lại BASE_URL hoặc ngrok.';
  }
  return switch (code) {
    400 => 'Yêu cầu không hợp lệ.',
    401 => 'Phiên đăng nhập hết hạn hoặc sai thông tin.',
    403 => 'Bạn không có quyền thực hiện thao tác này.',
    404 => 'Không tìm thấy tài nguyên.',
    >= 500 => 'Máy chủ đang gặp lỗi (mã $code).',
    _ => 'Có lỗi xảy ra (mã $code).',
  };
}

/// Đổi response lỗi thành mã lỗi dùng chung.
ApiErrorCode _errorCode(int statusCode, dynamic data) {
  // Mattermost gửi kèm "id" cho biết chính xác loại lỗi.
  final errorId = data is Map && data['id'] is String
      ? data['id'] as String
      : '';

  if (errorId.contains('invalid_credentials')) {
    return ApiErrorCode.invalidCredentials;
  }
  if (errorId.contains('session_expired') || statusCode == 401) {
    return ApiErrorCode.sessionExpired;
  }
  return ApiErrorCode.http;
}
