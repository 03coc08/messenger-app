import 'api_error_code.dart';

class ApiException implements Exception {
  final ApiErrorCode code;
  final int? statusCode;
  final dynamic data;

  ApiException.fromCode(this.code, {this.statusCode, this.data});

  // Câu báo lỗi lấy luôn từ mã lỗi
  String get message => code.message;

  @override
  String toString() => message;
}
