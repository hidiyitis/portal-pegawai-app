import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/manager_entity.dart';

abstract class CutiRepository {
  Future<List<CutiEntity>> getDaftarCuti();
  Future<KuotaCutiEntity> getKuotaCuti();
  Future<List<ManagerEntity>> getDaftarManager();
  Future<CutiEntity> ajukanCuti({
    required String kegiatan,
    required String tanggalMulai,
    required String tanggalSelesai,
    required int managerId,
    String? lampiran,
    String? catatan,
  });
}
