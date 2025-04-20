import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/presentation/cuti/widgets/cuti_detail_bottom_sheet.dart';

class CutiItemWidget extends StatelessWidget {
  final CutiEntity cuti;
  final VoidCallback onTap;

  const CutiItemWidget({Key? key, required this.cuti, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder:
              (context) => Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 1,
                child: CutiDetailBottomSheet(cuti: cuti),
              ),
        );
      },
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
            Container(
              width: 120,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _extractStartDay(cuti.tanggalMulai),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppTextSize.bodyLarge,
                        ),
                      ),
                      Text(
                        _extractStartMonth(cuti.tanggalMulai),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTextSize.bodySmall,
                        ),
                      ),
                      Text(
                        _extractStartYear(cuti.tanggalMulai),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTextSize.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '-',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppTextSize.bodySmall,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _extractEndDay(cuti.tanggalSelesai),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppTextSize.bodyLarge,
                        ),
                      ),
                      Text(
                        _extractEndMonth(cuti.tanggalSelesai),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTextSize.bodySmall,
                        ),
                      ),
                      Text(
                        _extractEndYear(cuti.tanggalSelesai),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppTextSize.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                      '${_getStatusText(cuti.status)} | Waktu Pengajuan : ${_extractDateHourMinute(cuti.tanggalPengajuan)}',
                      style: TextStyle(
                        color: _getStatusColor(cuti.status),
                        fontSize: AppTextSize.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  // String _formatTanggal(String mulai, String selesai) {
  //   // Perubahan format tanggal
  //   if (mulai == selesai) {
  //     return mulai;
  //   } else {
  //     return '$mulai - $selesai';
  //   }
  // }

  String _extractStartDay(String tanggal) {
    try {
      final parts = tanggal.split('/');
      return parts[0];
    } catch (e) {
      return '';
    }
  }

  String _extractStartMonth(String tanggal) {
    try {
      final parts = tanggal.split('/');
      return parts[1];
    } catch (e) {
      return '';
    }
  }

  String _extractStartYear(String tanggal) {
    try {
      final parts = tanggal.split('/');
      return parts[2];
    } catch (e) {
      return '';
    }
  }

  String _extractEndDay(String tanggal) {
    try {
      final parts = tanggal.split('/');
      return parts[0];
    } catch (e) {
      return '';
    }
  }

  String _extractEndMonth(String tanggal) {
    try {
      final parts = tanggal.split('/');
      return parts[1];
    } catch (e) {
      return '';
    }
  }

  String _extractEndYear(String tanggal) {
    try {
      final parts = tanggal.split('/');
      return parts[2];
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
        return Colors.red;
      default:
        return Colors.grey;
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
