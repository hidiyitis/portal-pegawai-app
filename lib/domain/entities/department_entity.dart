class DepartmentEntity {
  final int departmentId;
  final String name;

  DepartmentEntity({required this.departmentId, required this.name});
  Map<String, dynamic> toJson() => {
    'department_id': departmentId,
    'name': name,
  };
}
