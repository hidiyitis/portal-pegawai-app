import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';

class AgendaTile extends StatelessWidget {
  final AgendaModel agenda;

  const AgendaTile({super.key, required this.agenda});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: agenda.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.onSurface),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: agenda.color,
            child: Text(
              agenda
                  .dateLabel, // Disarankan: buat `dateLabel` di model misalnya '1\nMar'
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agenda.title,
                  style: TextStyle(
                    fontSize: AppTextSize.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  agenda.subtitle,
                  style: TextStyle(
                    fontSize: AppTextSize.bodyMedium,
                    color: AppColors.onSecondary,
                  ),
                ),
                if (agenda.time.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      agenda.time,
                      style: TextStyle(
                        fontSize: AppTextSize.bodySmall,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
