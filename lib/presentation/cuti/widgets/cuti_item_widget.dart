import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/presentation/cuti/widgets/cuti_detail_bottom_sheet.dart';

// Widget yang diperbaiki untuk menampilkan item cuti dengan status color yang sesuai
// Seperti seorang artist yang menggunakan warna untuk menyampaikan emosi,
// kita akan menggunakan warna untuk memberikan informasi status yang intuitif
class CutiItemWidget extends StatelessWidget {
  final CutiEntity cuti;
  final VoidCallback onTap;

  const CutiItemWidget({Key? key, required this.cuti, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dapatkan informasi status untuk styling
    final statusInfo = _getStatusInfo(cuti.status);

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor:
              Colors.transparent, // Untuk rounded corners yang smooth
          builder:
              (context) => Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: CutiDetailBottomSheet(cuti: cuti),
              ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Border dengan warna sesuai status untuk visual hierarchy yang jelas
          border: Border.all(
            color: statusInfo.color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: statusInfo.color.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            // Container tanggal dengan warna yang sesuai status
            // Ini adalah focal point yang langsung memberikan informasi visual
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                // Gradient yang subtle untuk visual appeal yang lebih modern
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [statusInfo.color, statusInfo.color.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tanggal mulai
                  Column(
                    children: [
                      Text(
                        _extractDay(cuti.tanggalMulai),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppTextSize.headingSmall,
                        ),
                      ),
                      Text(
                        _extractMonth(cuti.tanggalMulai),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: AppTextSize.bodySmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Separator dengan ikon yang menunjukkan rentang tanggal
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Icon(
                      Icons.arrow_downward,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                  ),

                  // Tanggal selesai
                  Column(
                    children: [
                      Text(
                        _extractDay(cuti.tanggalSelesai),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppTextSize.headingSmall,
                        ),
                      ),
                      Text(
                        _extractMonth(cuti.tanggalSelesai),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: AppTextSize.bodySmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content area dengan informasi detail
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title dengan styling yang prominent
                    Text(
                      cuti.kegiatan,
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppTextSize.bodyLarge,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),

                    // Manager information dengan icon untuk clarity
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: AppColors.onSecondary,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Manager: ${cuti.managerNama}',
                            style: TextStyle(
                              color: AppColors.onSecondary,
                              fontSize: AppTextSize.bodySmall,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),

                    // Status dengan waktu pengajuan
                    Row(
                      children: [
                        // Status badge dengan warna yang sesuai
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusInfo.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: statusInfo.color.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            statusInfo.displayText,
                            style: TextStyle(
                              color: statusInfo.color,
                              fontSize: AppTextSize.bodySmall,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),

                        // Separator
                        Container(
                          width: 1,
                          height: 12,
                          color: AppColors.onSecondary.withOpacity(0.3),
                        ),
                        SizedBox(width: 8),

                        // Waktu pengajuan
                        Expanded(
                          child: Text(
                            'Diajukan: ${_extractDateHourMinute(cuti.tanggalPengajuan)}',
                            style: TextStyle(
                              color: AppColors.onSecondary,
                              fontSize: AppTextSize.bodySmall,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Action indicator
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.visibility, color: AppColors.primary, size: 20),
                  SizedBox(height: 4),
                  Text(
                    'Detail',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: AppTextSize.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method untuk mendapatkan informasi status dengan warna dan text yang sesuai
  // Ini adalah mapping center yang mengubah status technical menjadi presentation format
  StatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'dalam_pengajuan':
      case 'pending':
      case 'in_progress':
        return StatusInfo(
          color: Colors.orange[600]!, // Kuning/orange untuk dalam pengajuan
          displayText: 'Dalam Pengajuan',
          description: 'Menunggu persetujuan manager',
        );
      case 'disetujui':
      case 'diterima':
      case 'completed':
      case 'approved':
        return StatusInfo(
          color: Colors.green[600]!, // Hijau untuk disetujui
          displayText: 'Disetujui',
          description: 'Pengajuan telah disetujui',
        );
      case 'ditolak':
      case 'rejected':
        return StatusInfo(
          color: Colors.red[600]!, // Merah untuk ditolak
          displayText: 'Ditolak',
          description: 'Pengajuan tidak disetujui',
        );
      case 'dibatalkan':
      case 'cancelled':
        return StatusInfo(
          color: Colors.grey[600]!, // Abu-abu untuk dibatalkan
          displayText: 'Dibatalkan',
          description: 'Pengajuan dibatalkan',
        );
      default:
        return StatusInfo(
          color: Colors.grey[600]!,
          displayText: 'Status Tidak Dikenal',
          description: 'Status tidak dapat diidentifikasi',
        );
    }
  }

  // Helper methods untuk extract informasi tanggal dengan format yang consistent
  String _extractDay(String tanggal) {
    try {
      final parts = tanggal.split('/');
      return parts[0].padLeft(2, '0');
    } catch (e) {
      return '??';
    }
  }

  String _extractMonth(String tanggal) {
    try {
      final parts = tanggal.split('/');
      final monthNames = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      final monthIndex = int.parse(parts[1]);
      return monthNames[monthIndex];
    } catch (e) {
      return '???';
    }
  }

  // Method untuk extract tanggal dan jam dari timestamp pengajuan
  String _extractDateHourMinute(String datetime) {
    try {
      final parts = datetime.split(' ');
      if (parts.length >= 2) {
        final datePart = parts[0];
        final timePart = parts[1];
        final timeParts = timePart.split(':');
        if (timeParts.length >= 2) {
          return '$datePart ${timeParts[0]}:${timeParts[1]}';
        }
        return datePart;
      }
      return datetime;
    } catch (e) {
      // Fallback untuk format tanggal yang tidak dikenal
      return datetime.substring(0, datetime.length > 16 ? 16 : datetime.length);
    }
  }
}

// Data class untuk menyimpan informasi status yang terstruktur
// Ini membantu dalam maintainability dan extensibility kode
class StatusInfo {
  final Color color;
  final String displayText;
  final String description;

  const StatusInfo({
    required this.color,
    required this.displayText,
    required this.description,
  });
}
