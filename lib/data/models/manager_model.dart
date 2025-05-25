import 'package:portal_pegawai_app/domain/entities/manager_entity.dart';

class ManagerModel extends ManagerEntity {
  ManagerModel({
    required super.id,
    required super.nama,
    required super.jabatan,
  });

  factory ManagerModel.fromJson(Map<String, dynamic> json) {
    return ManagerModel(
      id: json['id'],
      nama: json['nama'],
      jabatan: json['jabatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'jabatan': jabatan};
  }
}
