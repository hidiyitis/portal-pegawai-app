import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> uploadAvatar(XFile file);
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
}
