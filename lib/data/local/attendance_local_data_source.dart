import 'package:portal_pegawai_app/domain/entities/attendance_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AttendanceLocalDataSource {
  Future<void> storeClockInClockOut(String status, String time);
  Future<String?> getClockIn();
  Future<String?> getClockOut();
  Future<bool> checkClockedIn();
  Future<bool> checkClockedOut();
}

class AttendanceLoaclDataSourceImpl implements AttendanceLocalDataSource {
  final SharedPreferences prefs;

  AttendanceLoaclDataSourceImpl({required this.prefs});
  @override
  Future<String?> getClockIn() async {
    return prefs.getString('lastClockedIn');
  }

  @override
  Future<String?> getClockOut() async {
    return prefs.getString('lastClockedOut');
  }

  @override
  Future<void> storeClockInClockOut(String status, String time) async {
    if (status == AttendenceStatus.CLOCK_IN.name) {
      await prefs.setString('lastClockedIn', time);
      await prefs.remove('lastClockedOut');
    }
    if (status == AttendenceStatus.CLOCK_OUT.name) {
      await prefs.setString('lastClockedOut', time);
      await prefs.remove('lastClockedIn');
    }
  }

  @override
  Future<bool> checkClockedIn() async {
    return prefs.containsKey('lastClockedIn');
  }

  @override
  Future<bool> checkClockedOut() async {
    return prefs.containsKey('lastClockedOut');
  }
}
