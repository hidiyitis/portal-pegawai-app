import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/data/models/attendance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AttendanceRemoteDateSource {
  Future<AttendanceModel> clockInAndClockOut(
    String status,
    Position position,
    XFile file,
  );
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDateSource {
  final Dio dio;

  AttendanceRemoteDataSourceImpl({required this.dio});
  @override
  Future<AttendanceModel> clockInAndClockOut(
    String status,
    Position position,
    XFile file,
  ) async {
    var token = getIt<SharedPreferences>().getString('access_token');
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final formData = FormData.fromMap({
      'status': status,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'file': MultipartFile.fromFileSync(file.path, filename: file.name),
    });

    final response = await dio.post(
      '/attandance',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 201) {
      final res = AttendanceModel.fromJson(response.data['data']);
      return res;
    }
    throw Exception('${response.data['message']}');
  }
}
