class Validators {
  static String? email(String value) {
    if (value.trim().isEmpty) return 'Hãy nhập email.';
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return 'Hãy nhập mật khẩu.';
    return null;
  }

  // Kiểm tra form đăng nhập, sai chỗ nào thì trả về lỗi chỗ đó trước
  static String? login({required String email, required String password}) {
    return Validators.email(email) ?? Validators.password(password);
  }
}
