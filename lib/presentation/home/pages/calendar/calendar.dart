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
        color: Colors.teal,
        dateLabel: '1\nMar',
      ),
      AgendaModel(
        title: 'Cuti Menikah',
        subtitle: 'Cuti',
        time: '',
        color: Colors.redAccent,
        dateLabel: '2\nMar',
      ),
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CalendarHeader(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              'Agenda',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppTextSize.headingSmall,
                color: AppColors.onPrimary,
              ),
            ),
          ),
          Center(
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
                foregroundColor: Colors.white,
                backgroundColor: AppColors.primary,
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
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: agendas.length,
              itemBuilder: (context, index) {
                return AgendaTile(agenda: agendas[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
