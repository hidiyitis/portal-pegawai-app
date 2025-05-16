import 'package:dio/dio.dart';
import 'package:portal_pegawai_app/core/errors/error.dart';
import 'package:portal_pegawai_app/data/datasources/auth_remote_data_source.dart';
import 'package:portal_pegawai_app/data/local/auth_local_data_source.dart';
import 'package:portal_pegawai_app/data/models/auth_model.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:portal_pegawai_app/domain/entities/auth_entity.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<AuthEntity> login(String nip, String password) async {
    try {
      final auth = await remote.login(nip, password);
      await local.cacheAuthData(auth);
      return auth;
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Login failed',
      );
    }
  }

  @override
  Future<void> cacheAuthData(AuthEntity auth) =>
      local.cacheAuthData(auth as AuthModel);

  @override
  Future<void> clearAuthData() => local.clearAuthData();

  @override
  Future<UserModel?> getAuthUserData() => local.getAuthUserData();
}
