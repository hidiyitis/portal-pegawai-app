import 'package:portal_pegawai_app/domain/entities/department_entity.dart';

class UserEntity {
  final int nip;
  final String name;
  final int leaveQuota;
  final String photoUrl;
  final String role;
  final int departmentId;
  final DepartmentEntity department;
  final bool isActive;

  UserEntity({
    required this.nip,
    required this.name,
    required this.leaveQuota,
    required this.photoUrl,
    required this.role,
    required this.departmentId,
    required this.department,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'nip': nip,
    'name': name,
    'leave_quota': leaveQuota,
    'photo_url': photoUrl,
    'role': role,
    'department_id': departmentId,
    'department': department.toJson(),
    'isActive': isActive,
  };
}
