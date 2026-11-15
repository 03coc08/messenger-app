class Validators {
  static String? email(String value) {
    if (value.trim().isEmpty) return 'Hãy nhập email.';
    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return 'Hãy nhập mật khẩu.';
    return null;
  }

  /// Kiểm tra cả form đăng nhập, trả về lỗi đầu tiên gặp phải.
  static String? login({required String email, required String password}) {
    return Validators.email(email) ?? Validators.password(password);
  }
}
