import 'package:messenger_app/core/network/api_error_code.dart';
import 'package:messenger_app/core/network/api_exception.dart';

// Các giá trị này lấy từ file env/dev.env khi chạy app
class Env {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );
  static const String baseUrl = String.fromEnvironment('BASE_URL');

  static bool get isProd => appEnv == 'prod';

  static void validate() {
    if (baseUrl.isEmpty) {
      throw ApiException.fromCode(ApiErrorCode.missingConfig);
    }
  }
}
