import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';

class StatusFilterWidget extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const StatusFilterWidget({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildFilterChip('Semua', 'semua'),
            SizedBox(width: 8),
            _buildFilterChip('Dalam Pengajuan', 'dalam_pengajuan'),
            SizedBox(width: 8),
            _buildFilterChip('Ditolak', 'ditolak'),
            SizedBox(width: 8),
            _buildFilterChip('Disetujui', 'disetujui'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    final isSelected = currentFilter == filter;

    return InkWell(
      onTap: () => onFilterChanged(filter),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.onSurface,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.onPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
