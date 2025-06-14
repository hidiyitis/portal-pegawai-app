import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/data/models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<AttendanceModel> clockedInAndOut(
    String status,
    Position position,
    XFile file,
  );
  Future<void> storeClockedInClockOut(String status, String time);
  Future<String?> getClockIn();
  Future<String?> getClockOut();
  Future<bool> checkClockedIn();
  Future<bool> checkClockedOut();
  Future<AttendanceModel> getLastClock();
}
