import '../core/config/env.dart';
import '../core/network/api_client.dart';
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

    // Token nằm ở header, không nằm trong body.
    final token = res.headers['token'];
    final user = res.data;
    if (token == null ||
        token.isEmpty ||
        user is! Map<String, dynamic> ||
        user['id'] is! String) {
      throw ApiException.fromCode(ApiErrorCode.invalidResponse);
    }

    _client.token = token; // lưu token cho các request sau
    return Session(userId: user['id'] as String, token: token);
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await _client.get('/api/v4/users/me');
    return res.data as Map<String, dynamic>;
  }

  void logout() => _client.token = null;
}

// Dùng chung cho toàn app
final apiClient = ApiClient(baseUrl: Env.baseUrl);
final mattermostApi = MattermostApi(apiClient);
