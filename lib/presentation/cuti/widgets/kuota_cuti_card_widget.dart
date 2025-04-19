// lib/presentation/cuti/widgets/kuota_cuti_card_widget.dart
import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class KuotaCutiCardWidget extends StatelessWidget {
  final int kuotaTotal;
  final int dalamPengajuan;
  final int ditolak;
  final int disetujui;
  final VoidCallback onAjukanPressed;

  const KuotaCutiCardWidget({
    Key? key,
    required this.kuotaTotal,
    required this.dalamPengajuan,
    required this.ditolak,
    required this.disetujui,
    required this.onAjukanPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistik cuti - baris 1
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kuota Cuti',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: AppTextSize.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '$kuotaTotal',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppTextSize.headingMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dalam Pengajuan',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: AppTextSize.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '$dalamPengajuan',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: AppTextSize.headingMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Statistik cuti - baris 2
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ditolak',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: AppTextSize.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '$ditolak',
                      style: TextStyle(
                        color: AppColors.onError,
                        fontSize: AppTextSize.headingMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disetujui',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: AppTextSize.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '$disetujui',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: AppTextSize.headingMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Button ajukan cuti
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: onAjukanPressed,
              child: Text('Ajukan'),
            ),
          ),
        ],
      ),
    );
  }
}
