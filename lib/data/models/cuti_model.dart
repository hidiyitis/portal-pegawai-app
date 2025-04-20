import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';

class CutiModel extends CutiEntity {
  CutiModel({
    required super.id,
    required super.kegiatan,
    required super.tanggalMulai,
    required super.tanggalSelesai,
    required super.managerId,
    required super.managerNama,
    super.lampiran,
    super.catatan,
    required super.status,
    required super.tanggalPengajuan,
  });

  factory CutiModel.fromJson(Map<String, dynamic> json) {
    return CutiModel(
      id: json['id'],
      kegiatan: json['kegiatan'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      managerId: json['manager_id'],
      managerNama: json['manager_nama'],
      lampiran: json['lampiran'],
      catatan: json['catatan'],
      status: json['status'],
      tanggalPengajuan: json['tanggal_pengajuan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kegiatan': kegiatan,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'manager_id': managerId,
      'manager_nama': managerNama,
      'lampiran': lampiran,
      'catatan': catatan,
      'status': status,
      'tanggal_pengajuan': tanggalPengajuan,
    };
  }
}
