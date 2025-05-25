// ignore: constant_identifier_names
enum AttendenceStatus { CLOCK_IN, CLOCK_OUT }

class AttendanceEntity {
  int attendanceId;
  int nip;
  String photoUrl;
  AttendenceStatus status;
  double latitude;
  double longitude;
  DateTime createdAt;
  DateTime updatedAt;

  AttendanceEntity({
    required this.attendanceId,
    required this.nip,
    required this.photoUrl,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });
}
