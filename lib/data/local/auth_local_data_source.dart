import 'dart:convert';
import 'package:portal_pegawai_app/data/models/auth_model.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData(AuthModel auth);
  Future<void> clearAuthData();
  Future<UserModel?> getAuthUserData();
  Future<void> updateAuthData(UserModel user);
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
    await prefs.remove('lastClockedIn');
    await prefs.remove('lastClockedOut');
  }

  @override
  Future<UserModel?> getAuthUserData() async {
    if (!prefs.containsKey("user")) {
      return null;
    }
    final userData = UserModel.fromJson(jsonDecode(prefs.getString('user')!));

    return userData;
  }

  @override
  Future<void> updateAuthData(UserModel user) async {
    await prefs.setString('user', jsonEncode(user.toJson()));
  }
}
