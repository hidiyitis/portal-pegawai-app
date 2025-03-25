import 'dart:convert';
import 'package:portal_pegawai_app/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData(AuthModel auth);
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> cacheAuthData(AuthModel auth) async {
    await prefs.setString('access_token', auth.accessToken);
    await prefs.setString('refresh_token', auth.refreshToken);
    await prefs.setString('access_token_expired_at', auth.accessTokenExpiredAt);
    await prefs.setString('user', jsonEncode(auth.user.toJson()));
  }

  @override
  Future<void> clearAuthData() async {
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user');
    await prefs.remove('access_token_expired_at');
  }
}
