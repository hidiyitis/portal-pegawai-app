import 'package:portal_pegawai_app/data/models/cuti_model.dart';
import 'package:portal_pegawai_app/data/models/kuota_cuti_model.dart';
import 'package:portal_pegawai_app/data/models/manager_model.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/manager_entity.dart';
import 'package:portal_pegawai_app/domain/repositories/cuti_repository.dart';

class CutiRepositoryImpl implements CutiRepository {
  // Dummy data untuk sementara
  final List<CutiModel> _daftarCuti = [
    CutiModel(
      id: 1,
      kegiatan: 'Cuti Menikah?',
      tanggal: '1 Maret 2025',
      managerId: 1,
      managerNama: 'Budi Santoso',
      catatan: 'Acara pernikahan',
      status: 'disetujui',
    ),
    CutiModel(
      id: 2,
      kegiatan: 'Cuti Menikah?',
      tanggal: '2 Maret 2025',
      managerId: 1,
      managerNama: 'Budi Santoso',
      catatan: 'Acara pernikahan',
      status: 'disetujui',
    ),
    CutiModel(
      id: 3,
      kegiatan: 'Cuti Menikah?',
      tanggal: '3 Maret 2025',
      managerId: 1,
      managerNama: 'Budi Santoso',
      catatan: 'Acara pernikahan',
      status: 'disetujui',
    ),
    CutiModel(
      id: 4,
      kegiatan: 'Cuti Sakit',
      tanggal: '5 Maret 2025',
      managerId: 2,
      managerNama: 'Dewi Pratiwi',
      catatan: 'Harus kontrol ke dokter',
      status: 'dalam_pengajuan',
    ),
    CutiModel(
      id: 5,
      kegiatan: 'Cuti Melahirkan',
      tanggal: '10 Maret 2025',
      managerId: 3,
      managerNama: 'Andi Wijaya',
      catatan: 'Persiapan melahirkan',
      status: 'ditolak',
    ),
  ];

  KuotaCutiModel _kuotaCuti = KuotaCutiModel(
    total: 10,
    dalamPengajuan: 0,
    ditolak: 0,
    disetujui: 10,
  );

  final List<ManagerModel> _daftarManager = [
    ManagerModel(id: 1, nama: 'Budi Santoso', jabatan: 'Kepala IT'),
    ManagerModel(id: 2, nama: 'Dewi Pratiwi', jabatan: 'Kepala HRD'),
    ManagerModel(id: 3, nama: 'Andi Wijaya', jabatan: 'Kepala Keuangan'),
  ];

  @override
  Future<List<CutiEntity>> getDaftarCuti() async {
    await Future.delayed(
      Duration(milliseconds: 500),
    ); // Simulasi delay jaringan
    return _daftarCuti;
  }

  @override
  Future<KuotaCutiEntity> getKuotaCuti() async {
    await Future.delayed(
      Duration(milliseconds: 300),
    ); // Simulasi delay jaringan
    return _kuotaCuti;
  }

  @override
  Future<List<ManagerEntity>> getDaftarManager() async {
    await Future.delayed(
      Duration(milliseconds: 300),
    ); // Simulasi delay jaringan
    return _daftarManager;
  }

  @override
  Future<CutiEntity> ajukanCuti({
    required String kegiatan,
    required String tanggal,
    required int managerId,
    String? lampiran,
    String? catatan,
  }) async {
    await Future.delayed(
      Duration(milliseconds: 800),
    ); // Simulasi delay jaringan

    // Temukan manager berdasarkan ID
    final manager = _daftarManager.firstWhere(
      (manager) => manager.id == managerId,
      orElse: () => _daftarManager[0],
    );

    final newId = _daftarCuti.isEmpty ? 1 : _daftarCuti.last.id + 1;
    final newCuti = CutiModel(
      id: newId,
      kegiatan: kegiatan,
      tanggal: tanggal,
      managerId: managerId,
      managerNama: manager.nama,
      lampiran: lampiran,
      catatan: catatan,
      status: 'dalam_pengajuan',
    );

    _daftarCuti.add(newCuti);

    // Update kuota cuti
    _kuotaCuti = KuotaCutiModel(
      total: _kuotaCuti.total,
      dalamPengajuan: _kuotaCuti.dalamPengajuan + 1,
      ditolak: _kuotaCuti.ditolak,
      disetujui: _kuotaCuti.disetujui,
    );

    return newCuti;
  }
}
