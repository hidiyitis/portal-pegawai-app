import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';

class KuotaCutiModel extends KuotaCutiEntity {
  KuotaCutiModel({
    required super.total,
    required super.dalamPengajuan,
    required super.ditolak,
    required super.disetujui,
  });

  factory KuotaCutiModel.fromJson(Map<String, dynamic> json) {
    return KuotaCutiModel(
      total: json['total'],
      dalamPengajuan: json['dalam_pengajuan'],
      ditolak: json['ditolak'],
      disetujui: json['disetujui'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'dalam_pengajuan': dalamPengajuan,
      'ditolak': ditolak,
      'disetujui': disetujui,
    };
  }
}
