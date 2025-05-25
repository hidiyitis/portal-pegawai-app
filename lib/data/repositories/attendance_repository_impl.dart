import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/errors/error.dart';
import 'package:portal_pegawai_app/data/datasources/attendance_remote_data_source.dart';
import 'package:portal_pegawai_app/data/local/attendance_local_data_source.dart';
import 'package:portal_pegawai_app/data/models/attendance_model.dart';
import 'package:portal_pegawai_app/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDateSource remote;
  final AttendanceLocalDataSource local;

  AttendanceRepositoryImpl({required this.remote, required this.local});

  @override
  Future<AttendanceModel> clockedInAndOut(
    String status,
    Position position,
    XFile file,
  ) async {
    try {
      var res = await remote.clockInAndClockOut(status, position, file);
      return res;
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Attendance failed',
      );
    }
  }

  @override
  Future<void> storeClockedInClockOut(String status, String time) =>
      local.storeClockInClockOut(status, time);

  @override
  Future<String?> getClockIn() {
    return local.getClockIn();
  }

  @override
  Future<String?> getClockOut() {
    return local.getClockOut();
  }

  @override
  Future<bool> checkClockedIn() {
    return local.checkClockedIn();
  }

  @override
  Future<bool> checkClockedOut() {
    return local.checkClockedOut();
  }
}
