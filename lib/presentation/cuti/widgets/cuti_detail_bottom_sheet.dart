import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';

class CutiDetailBottomSheet extends StatelessWidget {
  final CutiEntity cuti;

  const CutiDetailBottomSheet({Key? key, required this.cuti}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detail Cuti',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.onPrimary,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailItem('Kegiatan', cuti.kegiatan),
            _buildDetailItem('Tanggal Mulai Cuti', cuti.tanggalMulai),
            _buildDetailItem('Tanggal Selesai Cuti', cuti.tanggalSelesai),
            _buildDetailItem(
              'Tanggal Pengajuan',
              _extractDateHourMinute(cuti.tanggalPengajuan),
            ),
            _buildDetailItem('Manager', cuti.managerNama),
            _buildDetailItem('Status', _getStatusText(cuti.status)),
            _buildDetailItem('Catatan', cuti.catatan ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.onSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'dalam_pengajuan':
        return 'Dalam Pengajuan';
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Unknown';
    }
  }

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
      return datetime;
    }
  }
}
