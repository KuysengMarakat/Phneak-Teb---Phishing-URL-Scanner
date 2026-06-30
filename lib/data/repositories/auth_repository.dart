import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../models/user.dart';
import '../database/database_helper.dart';

/// Handles user registration, login and session state.
class AuthRepository {
  /// Register a new user. Returns the created [User] or throws if the
  /// email already exists.
  Future<User> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final user = User(
      username: username,
      email: email.toLowerCase(),
      passwordHash: hashPassword(password),
      createdAt: DateTime.now(),
    );
    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  /// Attempt to log in. Returns the [User] on success, or null on failure.
  Future<User?> login(String email, String password) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email.toLowerCase(), hashPassword(password)],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final user = User.fromMap(rows.first);
    await _setLoggedIn(true);
    return user;
  }

  Future<void> logout() => _setLoggedIn(false);

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefIsLoggedIn) ?? false;
  }

  Future<void> _setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefIsLoggedIn, value);
  }

  /// SHA-256 hash of the password. (For production, prefer a salted
  /// algorithm such as bcrypt/argon2.)
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return crypto.sha256.convert(bytes).toString();
  }
}
