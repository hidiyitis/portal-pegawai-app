import 'package:flutter/material.dart';
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              'Agenda',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAgendaScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Color(0xFF00ADB5)),
              label: const Text(
                'Tambah Agenda',
                style: TextStyle(
                  color: Color(0xFF00ADB5),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF00ADB5), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
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
