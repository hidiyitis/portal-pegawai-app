import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';
import 'package:portal_pegawai_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:portal_pegawai_app/presentation/agenda/bloc/agenda_state.dart';
import 'package:portal_pegawai_app/presentation/agenda/bloc/agenda_event.dart';
import 'package:portal_pegawai_app/presentation/agenda/widgets/agenda_tile.dart';
import 'package:portal_pegawai_app/presentation/agenda/widgets/header_calendar.dart';
import 'package:portal_pegawai_app/presentation/agenda/pages/addAgenda.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<AgendaBloc>().add(LoadAgenda());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
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
            const SizedBox(height: 8),
            BlocBuilder<AgendaBloc, AgendaState>(
              builder: (context, state) {
                List<AgendasModel> agendas = [];
                List<DateTime> agendaDates = [];

                if (state is AgendaLoaded) {
                  agendas = state.agendas;
                  agendaDates =
                      agendas
                          .where((a) => a.date != null)
                          .map((a) => a.date!)
                          .toList();
                }

                return CalendarHeader(
                  agendaDates: agendaDates,
                  onDateSelected: (date) {
                    setState(() => _selectedDate = date);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Agenda',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppTextSize.headingSmall,
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                AddAgendaScreen(selectedDate: _selectedDate),
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
                      side: const BorderSide(
                        width: 1,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<AgendaBloc, AgendaState>(
                builder: (context, state) {
                  if (state is AgendaLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AgendaLoaded) {
                    final agendas =
                        state.agendas
                            .where(
                              (a) =>
                                  a.date != null &&
                                  a.date!.year == _selectedDate.year &&
                                  a.date!.month == _selectedDate.month &&
                                  a.date!.day == _selectedDate.day,
                            )
                            .toList();

                    if (agendas.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada agenda saat ini'),
                      );
                    }

                    return ListView.builder(
                      itemCount: agendas.length,
                      itemBuilder: (context, index) {
                        final a = agendas[index];
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AgendaDetailDialog(agenda: a),
                            );
                          },
                          child: AgendaTile(
                            agenda: AgendaModel(
                              title: a.title ?? '',
                              subtitle: a.location ?? '',
                              time:
                                  a.date != null
                                      ? DateFormat.Hm().format(a.date!)
                                      : '--:--',
                              color: AppColors.primary,
                              dateLabel:
                                  a.date != null
                                      ? DateFormat('d\nMMM').format(a.date!)
                                      : '--\n--',
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is AgendaError) {
                    return Center(
                      child: Text('Gagal memuat agenda: ${state.message}'),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgendaDetailDialog extends StatelessWidget {
  final AgendasModel agenda;

  const AgendaDetailDialog({super.key, required this.agenda});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        agenda.title ?? 'Detail Agenda',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppTextSize.headingSmall,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            'Tanggal',
            DateFormat.yMMMMEEEEd().format(agenda.date!.toLocal()),
          ),
          const SizedBox(height: 8),
          _buildRow('Waktu', DateFormat.Hm().format(agenda.date!.toLocal())),
          const SizedBox(height: 8),
          _buildRow('Lokasi', agenda.location ?? '-'),
          const SizedBox(height: 8),
          _buildRow('Deskripsi', agenda.description ?? '-'),
          const SizedBox(height: 8),
          if (agenda.participants != null && agenda.participants!.isNotEmpty)
            _buildRow(
              'Partisipan',
              agenda.participants!.map((p) => p.name).join(', '),
            ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text(
            'Tutup',
            style: TextStyle(color: AppColors.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }
}
