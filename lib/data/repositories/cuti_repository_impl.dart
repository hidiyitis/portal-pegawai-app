import 'package:portal_pegawai_app/data/models/cuti_model.dart';
import 'package:portal_pegawai_app/data/models/kuota_cuti_model.dart';
import 'package:portal_pegawai_app/data/models/manager_model.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/manager_entity.dart';
import 'package:portal_pegawai_app/domain/repositories/cuti_repository.dart';
import 'package:portal_pegawai_app/core/errors/error.dart';

class CutiRepositoryImpl implements CutiRepository {
  final List<CutiModel> _daftarCuti = [
    // data fek
    CutiModel(
      id: 1,
      kegiatan: 'Cuti Menikah',
      tanggalMulai: '10/09/2024',
      tanggalSelesai: '12/09/2024',
      managerId: 1,
      managerNama: 'Budi Santoso',
      status: 'disetujui',
      tanggalPengajuan: DateTime.now().toString(), // Added required parameter
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
  //buat liburan
  final List<DateTime> _publicHolidays = [
    DateTime(2024, 8, 17),
    DateTime(2024, 12, 25),
  ];

  @override
  Future<List<CutiEntity>> getDaftarCuti() async {
    await Future.delayed(Duration(milliseconds: 500));
    return _daftarCuti;
  }

  @override
  Future<KuotaCutiEntity> getKuotaCuti() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _kuotaCuti;
  }

  @override
  Future<List<ManagerEntity>> getDaftarManager() async {
    await Future.delayed(Duration(milliseconds: 300));
    return _daftarManager;
  }

  @override
  Future<CutiEntity> ajukanCuti({
    required String kegiatan,
    required String tanggalMulai,
    required String tanggalSelesai,
    required int managerId,
    String? lampiran,
    String? catatan,
  }) async {
    await Future.delayed(Duration(seconds: 2));

    final startDate = _parseTanggal(tanggalMulai);
    final endDate = _parseTanggal(tanggalSelesai);

    if (startDate == null || endDate == null) {
      throw ValidationFailure(message: 'Format tanggal tidak valid');
    }

    if (startDate.isAfter(endDate)) {
      throw ValidationFailure(
        message: 'Tanggal mulai tidak boleh setelah tanggal selesai',
      );
    }

    final conflictingCuti =
        _daftarCuti.where((cuti) {
          final cutiStart = _parseTanggal(cuti.tanggalMulai);
          final cutiEnd = _parseTanggal(cuti.tanggalSelesai);
          return _tanggalBertabrakan(startDate, endDate, cutiStart!, cutiEnd!);
        }).toList();

    if (conflictingCuti.isNotEmpty) {
      throw ValidationFailure(
        message: 'Tanggal cuti bertabrakan dengan pengajuan sebelumnya',
      );
    }

    int daysCount = 0;
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || currentDate == endDate) {
      if (currentDate.weekday != 6 && currentDate.weekday != 7) {
        if (!_publicHolidays.contains(currentDate)) {
          daysCount++;
        }
      }
      currentDate = currentDate.add(Duration(days: 1));
    }

    if (_kuotaCuti.dalamPengajuan + daysCount > _kuotaCuti.total) {
      throw ValidationFailure(message: 'Kuota cuti tidak mencukupi');
    }

    final manager = _daftarManager.firstWhere(
      (manager) => manager.id == managerId,
      orElse: () => _daftarManager[0],
    );

    final newId = _daftarCuti.isEmpty ? 1 : _daftarCuti.last.id + 1;
    final newCuti = CutiModel(
      id: newId,
      kegiatan: kegiatan,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      managerId: managerId,
      managerNama: manager.nama,
      lampiran: lampiran,
      catatan: catatan,
      status: 'dalam_pengajuan',
      tanggalPengajuan: DateTime.now().toString(), // Baru
    );

    _daftarCuti.add(newCuti);

    _kuotaCuti = KuotaCutiModel(
      total: _kuotaCuti.total,
      dalamPengajuan: _kuotaCuti.dalamPengajuan + daysCount,
      ditolak: _kuotaCuti.ditolak,
      disetujui: _kuotaCuti.disetujui,
    );

    return newCuti;
  }

  DateTime? _parseTanggal(String tanggal) {
    try {
      final parts = tanggal.split('/');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      return null;
    }
  }

  bool _tanggalBertabrakan(
    DateTime newStart,
    DateTime newEnd,
    DateTime existingStart,
    DateTime existingEnd,
  ) {
    return newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart);
  }
}
