import '../core/config/env.dart';
import '../core/network/api_client.dart';
import '../core/network/api_error_code.dart';
import '../core/network/api_exception.dart';
import '../models/session.dart';

class MattermostApi {
  MattermostApi(this._client);

  final ApiClient _client;

  Future<Session> login(String loginId, String password) async {
    final res = await _client.post(
      '/api/v4/users/login',
      body: {'login_id': loginId, 'password': password},
    );

    // Mattermost trả token trong header chứ không nằm trong body
    final token = res.headers['token'];
    if (token == null || token.isEmpty) {
      throw ApiException.fromCode(ApiErrorCode.invalidResponse);
    }

    final user = res.data;
    if (user is! Map || user['id'] is! String) {
      throw ApiException.fromCode(ApiErrorCode.invalidResponse);
    }

    _client.token = token;
    return Session(userId: user['id'], token: token);
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await _client.get('/api/v4/users/me');
    return res.data as Map<String, dynamic>;
  }

  void logout() {
    _client.token = null;
  }
}

// Cả app dùng chung 1 client để giữ token đăng nhập
final apiClient = ApiClient(baseUrl: Env.baseUrl);
final mattermostApi = MattermostApi(apiClient);
