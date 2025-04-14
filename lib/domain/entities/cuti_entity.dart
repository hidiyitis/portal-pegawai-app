class CutiEntity {
  final int id;
  final String kegiatan;
  final String tanggal;
  final int managerId;
  final String managerNama;
  final String? lampiran;
  final String? catatan;
  final String status; // "dalam_pengajuan", "disetujui", "ditolak"

  CutiEntity({
    required this.id,
    required this.kegiatan,
    required this.tanggal,
    required this.managerId,
    required this.managerNama,
    this.lampiran,
    this.catatan,
    required this.status,
  });
}
