import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_error_code.dart';
import 'api_exception.dart';

// Đổi mọi loại lỗi về ApiException để màn hình chỉ cần xử lý 1 kiểu
ApiException handleRequestError(Object error, StackTrace stack) {
  if (error is ApiException) {
    return error;
  }

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
