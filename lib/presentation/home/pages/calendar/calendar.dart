import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/agenda_tile.dart';
import 'package:portal_pegawai_app/presentation/home/widgets/header_calendar.dart';
import 'addAgenda.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AgendaModel> agendas = [
      AgendaModel(
        title: 'Sprint Planning 10',
        subtitle: 'Ruang Meeting 10',
        time: '10.30 AM',
        color: AppColors.primary,
        dateLabel: '1\nMar',
      ),
      AgendaModel(
        title: 'Cuti Menikah',
        subtitle: 'Cuti',
        time: '',
        color: AppColors.onError,
        dateLabel: '2\nMar',
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kalender',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontSize: AppTextSize.headingSmall,
                fontWeight: FontWeight.bold,
              ),
            ),
            const CalendarHeader(),
            Text(
              'Agenda',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppTextSize.headingSmall,
                color: AppColors.onPrimary,
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAgendaScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Agenda'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    textStyle: TextStyle(
                      fontSize: AppTextSize.bodyLarge,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(width: 1, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: agendas.length,
                itemBuilder: (context, index) {
                  return AgendaTile(agenda: agendas[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
