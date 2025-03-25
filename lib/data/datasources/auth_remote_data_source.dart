import 'package:dio/dio.dart';
import 'package:portal_pegawai_app/data/models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String nip, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthModel> login(String nip, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'nip': nip, 'password': password},
    );
    return AuthModel.fromJson(response.data['data']);
  }
}
