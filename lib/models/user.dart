/// Represents an authenticated app user.
class User {
  final int? id;
  final String username;
  final String email;
  final String passwordHash;
  final bool biometricEnabled;
  final DateTime createdAt;

  const User({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.biometricEnabled = false,
    required this.createdAt,
  });

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? passwordHash,
    bool? biometricEnabled,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'email': email,
        'password_hash': passwordHash,
        'biometric_enabled': biometricEnabled ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as int?,
        username: map['username'] as String,
        email: map['email'] as String,
        passwordHash: map['password_hash'] as String,
        biometricEnabled: (map['biometric_enabled'] as int? ?? 0) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
