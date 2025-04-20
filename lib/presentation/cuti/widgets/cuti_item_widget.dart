import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';

class CutiItemWidget extends StatelessWidget {
  final CutiEntity cuti;
  final VoidCallback onTap;

  const CutiItemWidget({Key? key, required this.cuti, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Date indicator
            Container(
              width: 50,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _extractDay(cuti.tanggal),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppTextSize.bodyLarge,
                    ),
                  ),
                  Text(
                    _extractMonth(cuti.tanggal),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppTextSize.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cuti.kegiatan,
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: AppTextSize.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getStatusText(cuti.status),
                      style: TextStyle(
                        color: _getStatusColor(cuti.status),
                        fontSize: AppTextSize.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Detail button
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Text(
                'Detail',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractDay(String tanggal) {
    try {
      final parts = tanggal.split(' ');
      return parts[0];
    } catch (e) {
      return '';
    }
  }

  String _extractMonth(String tanggal) {
    try {
      final parts = tanggal.split(' ');
      return parts[1];
    } catch (e) {
      return '';
    }
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'dalam_pengajuan':
        return Colors.orange;
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return AppColors.onError;
      default:
        return Colors.grey;
    }
  }
}
