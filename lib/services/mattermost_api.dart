import '../core/config/env.dart';
import '../core/network/api_client.dart';
import '../core/network/api_error_code.dart';
import '../core/network/api_exception.dart';
import '../models/channel.dart';
import '../models/chat_message.dart';
import '../models/session.dart';
import '../models/team.dart';
import '../models/user.dart';

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

  Future<List<Team>> getMyTeams() async {
    final res = await _client.get('/api/v4/users/me/teams');
    return _list(res.data).map(Team.fromJson).toList();
  }

  // Kênh của mình trong 1 team (có cả tin nhắn riêng và nhóm)
  Future<List<Channel>> getMyChannels(String teamId) async {
    final res = await _client.get('/api/v4/users/me/teams/$teamId/channels');
    return _list(res.data).map(Channel.fromJson).toList();
  }

  Future<List<User>> getUsersByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final res = await _client.post('/api/v4/users/ids', body: ids);
    return _list(res.data).map(User.fromJson).toList();
  }

  // Tin mới nhất nằm đầu danh sách
  Future<List<ChatMessage>> getPosts(String channelId) async {
    final res = await _client.get('/api/v4/channels/$channelId/posts');
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ApiException.fromCode(ApiErrorCode.invalidResponse);
    }
    return ChatMessage.fromPostList(data);
  }

  Future<ChatMessage> sendPost(String channelId, String message) async {
    final res = await _client.post(
      '/api/v4/posts',
      body: {'channel_id': channelId, 'message': message},
    );
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw ApiException.fromCode(ApiErrorCode.invalidResponse);
    }
    return ChatMessage.fromJson(data);
  }

  List<Map<String, dynamic>> _list(dynamic data) {
    if (data is! List) {
      throw ApiException.fromCode(ApiErrorCode.invalidResponse);
    }
    return data.cast<Map<String, dynamic>>();
  }

  void logout() {
    _client.token = null;
  }
}

// Cả app dùng chung 1 client để giữ token đăng nhập
final apiClient = ApiClient(baseUrl: Env.baseUrl);
final mattermostApi = MattermostApi(apiClient);
