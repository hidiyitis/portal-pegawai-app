import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // DEBUGGING: Print untuk memastikan widget rebuild dengan data yang benar
    print('StatusFilterWidget rebuild with currentFilter: $currentFilter');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24),
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
    // KUNCI PERBAIKAN: Pastikan comparison yang exact
    final bool isSelected = currentFilter.toLowerCase() == filter.toLowerCase();

    // DEBUGGING: Print untuk trace selection logic
    print('Filter: $filter, Current: $currentFilter, Selected: $isSelected');

    return InkWell(
      onTap: () {
        // TAMBAHAN: Haptic feedback untuk better UX
        HapticFeedback.selectionClick();
        onFilterChanged(filter);
      },
      child: AnimatedContainer(
        // PERBAIKAN: Animasi smooth untuk transition
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // PERBAIKAN: Warna yang lebih kontras untuk selected state
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.onSurface,
            width: isSelected ? 2 : 1, // Border lebih tebal untuk selected
          ),
          // TAMBAHAN: Shadow untuk selected state
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.onPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
