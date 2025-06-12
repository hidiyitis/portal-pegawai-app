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
            // Header section
            _buildHeader(),
            SizedBox(height: 16),

            // Basic information
            _buildDetailItem('Kegiatan', cuti.kegiatan),
            _buildDetailItem('Tanggal Mulai Cuti', cuti.tanggalMulai),
            _buildDetailItem('Tanggal Selesai Cuti', cuti.tanggalSelesai),
            _buildDetailItem(
              'Tanggal Pengajuan',
              _extractDateHourMinute(cuti.tanggalPengajuan),
            ),
            _buildDetailItem('Manager', cuti.managerNama),
            _buildDetailItem('Status', _getStatusText(cuti.status)),

            // PERBAIKAN: Tampilkan filename dengan styling yang baik
            _buildAttachmentSection(),

            // PERBAIKAN: Tampilkan description/catatan yang sebenarnya
            _buildDescriptionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Detail Pengajuan Cuti',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.onPrimary,
      ),
    );
  }

  // TAMBAHAN: Section khusus untuk attachment filename
  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lampiran',
          style: TextStyle(
            color: AppColors.onSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),

        // Tampilkan filename atau pesan jika tidak ada
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                cuti.attachmentFileName != null
                    ? Icons.attach_file
                    : Icons.info_outline,
                size: 20,
                color:
                    cuti.attachmentFileName != null
                        ? AppColors.primary
                        : AppColors.onSecondary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  cuti.attachmentFileName ?? 'Tidak ada lampiran',
                  style: TextStyle(
                    color:
                        cuti.attachmentFileName != null
                            ? AppColors.onPrimary
                            : AppColors.onSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // TAMBAHAN: Section khusus untuk description/catatan
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan',
          style: TextStyle(
            color: AppColors.onSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.onSecondary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.onSecondary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            // Gunakan description yang sebenarnya, fallback ke 'catatan' untuk backward compatibility
            cuti.description?.isNotEmpty == true
                ? cuti.description!
                : (cuti.catatan?.isNotEmpty == true
                    ? cuti.catatan!
                    : 'Tidak ada catatan tambahan'),
            style: TextStyle(
              color:
                  (cuti.description?.isNotEmpty == true ||
                          cuti.catatan?.isNotEmpty == true)
                      ? AppColors.onPrimary
                      : AppColors.onSecondary,
              fontSize: 14,
              height: 1.4, // Line height untuk readability
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.onSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
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
        return 'Status Tidak Dikenal';
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
