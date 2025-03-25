import 'package:portal_pegawai_app/data/models/department_model.dart';
import 'package:portal_pegawai_app/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.nip,
    required super.name,
    required super.leaveQuota,
    required super.photoUrl,
    required super.role,
    required super.departmentId,
    required super.department,
    required super.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nip: json['nip'],
      name: json['name'],
      leaveQuota: json['leave_quota'],
      photoUrl: json['photo_url'],
      role: json['role'],
      departmentId: json['department_id'],
      department: DepartmentModel.fromJson(json['department']),
      isActive: json['is_active'],
    );
  }
}
