enum ApiErrorCode {
  timeout('Máy chủ phản hồi quá lâu. Hãy thử lại.'),
  noConnection('Không kết nối được tới máy chủ.'),
  invalidUrl('Địa chỉ máy chủ không hợp lệ.'),
  missingConfig(
    'Thiếu BASE_URL. Hãy chạy với --dart-define-from-file=.env.dev',
  ),
  htmlResponse(
    'Máy chủ trả về HTML thay vì JSON. Kiểm tra lại BASE_URL hoặc ngrok.',
  ),
  invalidCredentials('Email hoặc mật khẩu không chính xác.'),
  sessionExpired('Phiên đăng nhập đã hết hạn. Hãy đăng nhập lại.'),
  badRequest('Yêu cầu không hợp lệ.'),
  forbidden('Bạn không có quyền thực hiện thao tác này.'),
  notFound('Không tìm thấy tài nguyên.'),
  serverError('Máy chủ đang gặp lỗi. Hãy thử lại sau.'),
  invalidResponse('Máy chủ trả về dữ liệu không hợp lệ.'),
  http('Máy chủ báo lỗi.'),
  unknown('Có lỗi xảy ra. Hãy thử lại.');

  const ApiErrorCode(this.message);

  final String message;
}
