import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

// Simplified kuota cuti card yang hanya menampilkan total kuota
// Seperti dashboard yang clean dan minimalis, fokus pada informasi utama
// tanpa detail yang membingungkan
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section yang clean dan simple
            _buildHeaderSection(context),

            SizedBox(height: 24),

            // Divider untuk pemisah visual
            Container(height: 1, color: Colors.grey[200]),

            SizedBox(height: 20),

            // Status section yang disederhanakan
            _buildSimpleStatusSection(context),

            SizedBox(height: 24),

            // Action button
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  // Header section yang fokus pada total kuota saja
  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Kuota Cuti Anda',
          style: TextStyle(
            color: AppColors.onSecondary,
            fontSize: AppTextSize.bodyMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),

        // Tampilan kuota yang prominent dan clean
        Row(
          children: [
            // Icon sederhana untuk visual appeal
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.event_available,
                color: AppColors.primary,
                size: 32,
              ),
            ),

            SizedBox(width: 16),

            // Total kuota dengan styling yang jelas
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$kuotaTotal',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppTextSize.headingLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'hari',
                    style: TextStyle(
                      color: AppColors.onSecondary,
                      fontSize: AppTextSize.bodyMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Status section yang disederhanakan - hanya menampilkan informasi penting
  Widget _buildSimpleStatusSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status Pengajuan',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontSize: AppTextSize.bodyMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),

        // Row dengan status items yang clean
        Row(
          children: [
            Expanded(
              child: _buildSimpleStatusItem(
                label: 'Dalam Proses',
                value: dalamPengajuan,
                color: Colors.orange[600]!,
                icon: Icons.schedule,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSimpleStatusItem(
                label: 'Disetujui',
                value: disetujui,
                color: Colors.green[600]!,
                icon: Icons.check_circle,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSimpleStatusItem(
                label: 'Ditolak',
                value: ditolak,
                color: Colors.red[600]!,
                icon: Icons.cancel,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Status item yang simple tanpa kompleksitas berlebihan
  Widget _buildSimpleStatusItem({
    required String label,
    required int value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: AppTextSize.headingSmall,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: AppTextSize.bodySmall,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Action button yang simple
  Widget _buildActionButton(BuildContext context) {
    // KUNCI PERBAIKAN: Hitung sisa kuota yang benar
    // Sisa kuota = Total kuota - Cuti yang sudah disetujui

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: kuotaTotal > 0 ? AppColors.primary : Colors.grey,
          foregroundColor: Colors.white,
          elevation: kuotaTotal > 0 ? 2 : 0,
          shadowColor:
              kuotaTotal > 0 ? AppColors.primary.withOpacity(0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // LOGIKA DISABLE: null akan membuat button disabled
        onPressed: kuotaTotal > 0 ? onAjukanPressed : null,
        icon: Icon(
          // Icon berubah berdasarkan kondisi kuota
          kuotaTotal > 0 ? Icons.add_circle : Icons.block,
          size: 20,
        ),
        label: Text(
          // Text berubah berdasarkan kondisi kuota
          kuotaTotal > 0
              ? 'Ajukan Cuti Baru'
              : 'Kuota Habis ($kuotaTotal hari)',
          style: TextStyle(
            fontSize: AppTextSize.bodyMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
