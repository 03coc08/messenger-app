class User {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  // Có họ tên thì hiện họ tên, không thì hiện username
  String get displayName {
    final full = '$firstName $lastName'.trim();
    return full.isEmpty ? username : full;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }
}
