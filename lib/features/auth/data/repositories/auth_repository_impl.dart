import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CodeKey/features/auth/domain/entities/app_user.dart';
import 'package:CodeKey/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;
  static const String _userKey = 'auth_user';

  AuthRepositoryImpl(this._client);

  @override
  Future<AppUser?> signIn(String username, String accessKey) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('username', username)
        .eq('access_key', accessKey)
        .maybeSingle();

    if (response != null) {
      final user = AppUser(
        id: response['id'],
        username: response['username'],
        fullName: response['full_name'],
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));

      return user;
    }

    throw Exception('Invalid username or access key');
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<AppUser?> getPersistedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      return AppUser.fromJson(jsonDecode(userStr));
    }
    return null;
  }
}
