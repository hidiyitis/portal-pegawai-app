import 'package:portal_pegawai_app/domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  DepartmentModel({required super.departmentId, required super.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['department_id'],
      name: json['name'],
    );
  }
}
