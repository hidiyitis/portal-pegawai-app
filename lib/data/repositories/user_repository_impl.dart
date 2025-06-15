import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/errors/error.dart';
import 'package:portal_pegawai_app/data/datasources/user_remote_data_source.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:portal_pegawai_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl({required this.remote});
  @override
  Future<UserModel> uploadAvatar(XFile file) async {
    try {
      return await remote.uploadAvatar(file);
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Upload failed',
      );
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    return await remote.getAllUsers(); // Pastikan remote sudah punya fungsi ini
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      return await remote.getUsers();
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Upload failed',
      );
    }
  }

  @override
  Future<UserModel> updatePassword(
    String current,
    String newPass,
    String confirmPass,
  ) async {
    try {
      var res = await remote.updatePassword(current, newPass, confirmPass);
      return res;
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Failed Update Password',
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() {
    try {
      return remote.getCurrentUser();
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Failed Update Password',
      );
    }
  }
}
