/// Bộ mã lỗi dùng chung. Mỗi mã có sẵn câu thông báo cho người dùng.
enum ApiErrorCode {
  timeout('Máy chủ phản hồi quá lâu. Hãy thử lại.'),
  noConnection('Không kết nối được tới máy chủ.'),
  invalidUrl('Địa chỉ máy chủ không hợp lệ.'),
  missingConfig(
    'Thiếu BASE_URL. Hãy chạy với --dart-define-from-file=env/dev.env',
  ),
  invalidCredentials('Email hoặc mật khẩu không chính xác.'),
  sessionExpired('Phiên đăng nhập đã hết hạn. Hãy đăng nhập lại.'),
  invalidResponse('Máy chủ trả về dữ liệu không hợp lệ.'),
  http('Máy chủ báo lỗi.'),
  unknown('Có lỗi xảy ra. Hãy thử lại.');

  const ApiErrorCode(this.message);

  /// Câu thông báo mặc định của mã lỗi này.
  final String message;
}

class ApiException implements Exception {
  final String message;
  final ApiErrorCode code;
  final int? statusCode;
  final dynamic data;

  ApiException(
    this.message, {
    this.code = ApiErrorCode.unknown,
    this.statusCode,
    this.data,
  });

  /// Tạo lỗi từ mã, dùng luôn câu thông báo của mã đó.
  ApiException.fromCode(this.code, {this.statusCode, this.data})
    : message = code.message;

  @override
  String toString() => message;
}
