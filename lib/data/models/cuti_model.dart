import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';

class CutiModel extends CutiEntity {
  CutiModel({
    required super.id,
    required super.kegiatan,
    required super.tanggal,
    required super.managerId,
    required super.managerNama,
    super.lampiran,
    super.catatan,
    required super.status,
  });

  factory CutiModel.fromJson(Map<String, dynamic> json) {
    return CutiModel(
      id: json['id'],
      kegiatan: json['kegiatan'],
      tanggal: json['tanggal'],
      managerId: json['manager_id'],
      managerNama: json['manager_nama'],
      lampiran: json['lampiran'],
      catatan: json['catatan'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kegiatan': kegiatan,
      'tanggal': tanggal,
      'manager_id': managerId,
      'manager_nama': managerNama,
      'lampiran': lampiran,
      'catatan': catatan,
      'status': status,
    };
  }
}
