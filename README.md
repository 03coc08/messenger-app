# Messenger App

Ứng dụng nhắn tin viết bằng Flutter, giao diện theo phong cách Messenger, dùng
[Mattermost](https://mattermost.com/) làm máy chủ (backend).

Hiện tại chỉ **đăng nhập** là gọi API thật (`/api/v4/users/login`). Các màn hình
còn lại (danh sách chat, danh bạ, khám phá, chi tiết chat) đang dùng dữ liệu mẫu.

## Ảnh màn hình

<p align="center">
  <img src="docs/images/login.png" alt="Màn hình đăng nhập" width="240" />
  <img src="docs/images/messenger-chats.png" alt="Danh sách chat" width="240" />
</p>

<p align="center">
  <img src="docs/images/people.png" alt="Danh bạ" width="240" />
  <img src="docs/images/chat-detail.png" alt="Chi tiết chat" width="240" />
</p>

## Yêu cầu

- Flutter (stable), Dart SDK `^3.11.5`. Project đang được phát triển với Flutter 3.41.
- Một máy chủ Mattermost có thể truy cập được. Nếu chạy Mattermost trên máy cá
  nhân, có thể dùng ngrok để tạo đường dẫn công khai.

## Cài đặt và chạy

### 1. Clone và tải thư viện

```bash
git clone <địa chỉ repo>
cd messenger_app
flutter pub get
```

`pubspec.lock` không được đưa lên git, nên `flutter pub get` sẽ tạo lại file này
trên máy bạn.

### 2. Tạo file cấu hình môi trường

Cấu hình được truyền vào lúc build bằng `--dart-define-from-file`. Các file
`env/*.env` chứa địa chỉ máy chủ thật nên **không được đẩy lên git**. Hãy tạo
từ file mẫu:

```bash
cp env/dev.env.example env/dev.env
```

Sau đó sửa `env/dev.env`:

| Biến       | Ý nghĩa                                         | Ví dụ                         |
|------------|-------------------------------------------------|-------------------------------|
| `APP_ENV`  | Môi trường chạy: `dev` hoặc `prod`              | `dev`                         |
| `BASE_URL` | Địa chỉ máy chủ Mattermost, không có `/` ở cuối | `https://chat.example.com`    |

Nếu cần build bản production, tạo thêm `env/prod.env` theo cùng mẫu.

### 3. Chạy app

```bash
# Môi trường dev
flutter run --dart-define-from-file=env/dev.env

# Môi trường prod
flutter run --dart-define-from-file=env/prod.env
```

Nếu quên truyền file env, app sẽ dừng ngay khi khởi động với lỗi
`ApiErrorCode.missingConfig` (xem `Env.validate()` trong
`lib/core/config/env.dart`).

**VS Code:** thêm `--dart-define-from-file` vào `args` trong `.vscode/launch.json`
(thư mục `.vscode/` không được đưa lên git):

```json
{
  "configurations": [
    {
      "name": "messenger_app (dev)",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define-from-file=env/dev.env"]
    }
  ]
}
```

### 4. Kiểm tra code

```bash
flutter analyze
flutter test
```

## Cấu trúc thư mục

```
lib/
├── main.dart                 # Điểm khởi động: kiểm tra env, cấu hình hệ thống, chạy MyApp
├── core/
│   ├── config/env.dart       # Đọc APP_ENV, BASE_URL từ --dart-define
│   ├── network/
│   │   ├── api_client.dart           # HTTP client chung: gắn token, timeout, gửi request
│   │   ├── api_response_handler.dart # Đọc response, đổi mã HTTP thành mã lỗi
│   │   ├── api_error_handler.dart    # Đổi lỗi mạng/timeout thành ApiException
│   │   └── api_exception.dart        # ApiException và bộ mã lỗi ApiErrorCode
│   └── utils/
│       ├── app_snackbar.dart # SnackBar dùng chung, gọi được ở mọi nơi
│       └── validators.dart   # Kiểm tra dữ liệu form
├── models/                   # Session, Channel, ChatItem, ChatMessage, Story
├── services/
│   └── mattermost_api.dart   # Các API Mattermost (login, getMe, logout)
├── screens/                  # Các màn hình (login, signup, chats, people, chat detail...)
├── theme/                    # Màu sắc (AppColors) và theme (AppTheme)
└── widgets/                  # Widget dùng lại nhiều nơi
assets/images/                # Ảnh đại diện mẫu
docs/images/                  # Ảnh màn hình cho README
env/                          # File cấu hình môi trường (chỉ file .example được commit)
```

## Gọi API và xử lý lỗi

Mọi request đều đi qua `ApiClient`. Lỗi ở bất kỳ bước nào cũng được đổi thành
`ApiException` có một `ApiErrorCode`, nên màn hình chỉ cần bắt một loại lỗi:

```dart
try {
  final session = await mattermostApi.login(email, password);
  // ...
} on ApiException catch (e) {
  AppSnackBar.error(e.message); // câu thông báo đã sẵn sàng để hiện cho người dùng
}
```

| Mã lỗi               | Khi nào xảy ra                                   |
|----------------------|--------------------------------------------------|
| `timeout`            | Máy chủ không phản hồi sau 15 giây               |
| `noConnection`       | Không kết nối được tới máy chủ                   |
| `invalidUrl`         | `BASE_URL` sai định dạng                         |
| `missingConfig`      | Chạy app mà không truyền file env                |
| `invalidCredentials` | Sai email hoặc mật khẩu                          |
| `sessionExpired`     | Token hết hạn (HTTP 401), gọi `onUnauthorized`   |
| `invalidResponse`    | Máy chủ trả dữ liệu không đúng định dạng         |
| `http`               | Các lỗi HTTP khác, dùng câu thông báo từ máy chủ |
| `unknown`            | Lỗi không xác định                               |

**Thêm API mới:** viết thêm hàm trong `MattermostApi`
(`lib/services/mattermost_api.dart`) và gọi qua `_client.get/post/put/delete`.
Token đăng nhập được tự gắn vào header sau khi `login()` thành công.

**Thêm mã lỗi mới:** thêm vào enum `ApiErrorCode` kèm câu thông báo, rồi
`throw ApiException.fromCode(ApiErrorCode.xxx)`.

## Quy ước

- Không commit các file: `env/*.env`, `.vscode/`, `.metadata`, `pubspec.lock`
  (đã có trong `.gitignore`).
- Màu sắc lấy từ `AppColors`, không viết mã màu trực tiếp trong widget.
- Thông báo cho người dùng dùng `AppSnackBar`.
- Commit message theo [Conventional Commits](https://www.conventionalcommits.org/):
  `feat:`, `fix:`, `refactor:`, `chore:`...
- Làm việc trên nhánh `feature/...`, tạo Pull Request vào `main` để review.
