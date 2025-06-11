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
import 'addAgenda.dart';

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
            CalendarHeader(
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
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
                    final agendas = state.agendas;

                    if (agendas.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada agenda saat ini'),
                      );
                    }

                    return ListView.builder(
                      itemCount: agendas.length,
                      itemBuilder: (context, index) {
                        final a = agendas[index];

                        return AgendaTile(
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
