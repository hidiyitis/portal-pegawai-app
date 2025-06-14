import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> uploadAvatar(XFile file);
  Future<List<UserModel>> getUsers();
  Future<List<UserModel>> getAllUsers();
  Future<UserModel> updatePassword(
    String current,
    String newPass,
    String confirmPass,
  );
  Future<UserModel> getCurrentUser();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});
  @override
  Future<UserModel> uploadAvatar(XFile file) async {
    var token = getIt<SharedPreferences>().getString('access_token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final formData = FormData.fromMap({
      'image': MultipartFile.fromFileSync(file.path, filename: file.name),
    });
    final response = await dio.put(
      '/users/upload-avatar',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    }
    throw Exception('${response.data['message']}');
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final token = getIt<SharedPreferences>().getString('access_token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await dio.get(
      '/users', // pastikan route backend mendukung endpoint ini
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    }

    throw Exception('Failed to fetch user list: ${response.statusMessage}');
  }

  @override
  Future<List<UserModel>> getUsers() async {
    var token = getIt<SharedPreferences>().getString('access_token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await dio.get(
      '/users/',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List;
      return dataList.map((item) {
        try {
          return UserModel.fromJson(item);
        } catch (e) {
          throw FormatException('Failed to parse users item: $e');
        }
      }).toList();
    }
    throw Exception('${response.data['message']}');
  }

  @override
  Future<UserModel> updatePassword(
    String current,
    String newPass,
    String confirmPass,
  ) async {
    var token = getIt<SharedPreferences>().getString('access_token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    try {
      final response = await dio.put(
        '/users/update-password',
        data: {
          'current_password': current,
          'new_password': newPass,
          'confirm_password': confirmPass,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      }
      throw Exception('${response.data['message']}');
    } catch (e) {
      throw Exception('Failed Update password');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    var prefs = getIt<SharedPreferences>();
    var token = prefs.getString('access_token');
    var user = UserModel.fromJson(jsonDecode(prefs.getString('user')!));

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await dio.get(
      '/users/${user.nip}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    }
    throw Exception('${response.data['message']}');
  }
}
