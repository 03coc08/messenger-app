import 'package:messenger_app/core/network/api_exception.dart';

class Env {
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );
  static const String baseUrl = String.fromEnvironment('BASE_URL');

  static bool get isProd => appEnv == 'prod';

  /// Gọi ở main() để báo lỗi sớm nếu quên truyền file env
  static void validate() {
    if (baseUrl.isEmpty) {
      throw ApiException.fromCode(ApiErrorCode.missingConfig);
    }
  }
}
