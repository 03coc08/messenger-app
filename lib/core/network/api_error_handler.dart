import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// Đổi MỌI lỗi thành ApiException có mã lỗi dùng chung.
/// Dùng cho cả tầng network lẫn các màn hình.
ApiException handleRequestError(Object error, StackTrace stack) {
  if (error is ApiException) return error; // đã có mã lỗi thì giữ nguyên

  if (error is TimeoutException) {
    return ApiException.fromCode(ApiErrorCode.timeout);
  }
  if (error is http.ClientException) {
    debugPrint('Không kết nối được: ${error.message}');
    return ApiException.fromCode(ApiErrorCode.noConnection);
  }
  debugPrint('Lỗi không xác định: $error\n$stack');
  return ApiException.fromCode(ApiErrorCode.unknown);
}
