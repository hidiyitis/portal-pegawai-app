// attendance_model.dart
import 'package:portal_pegawai_app/domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  AttendanceModel({
    required super.attendanceId,
    required super.nip,
    required super.photoUrl,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceId: json['attendance_id'],
      nip: json['nip'],
      photoUrl: json['photo_url'],
      status: _parseAttendenceStatus(json['status']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
    );
  }

  static AttendenceStatus _parseAttendenceStatus(String status) {
    switch (status) {
      case 'CLOCK_IN':
        return AttendenceStatus.CLOCK_IN;
      case 'CLOCK_OUT':
        return AttendenceStatus.CLOCK_OUT;
      default:
        throw ArgumentError('Invalid attendance status: $status');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'attendance_id': attendanceId,
      'nip': nip,
      'photo_url': photoUrl,
      'status': status.name,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
