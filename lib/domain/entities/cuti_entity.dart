class CutiEntity {
  final int id;
  final String kegiatan;
  final String tanggalMulai;
  final String tanggalSelesai;
  final int managerId;
  final String managerNama;
  final String? lampiran;
  final String? catatan;
  final String status;
  final String tanggalPengajuan; // Baru

  CutiEntity({
    required this.id,
    required this.kegiatan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.managerId,
    required this.managerNama,
    this.lampiran,
    this.catatan,
    required this.status,
    required this.tanggalPengajuan, // Baru
  });
}
