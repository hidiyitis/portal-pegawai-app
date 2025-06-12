import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:portal_pegawai_app/presentation/agenda/bloc/agenda_event.dart';
import 'package:portal_pegawai_app/presentation/agenda/bloc/agenda_state.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';

class AgendaListPage extends StatefulWidget {
  const AgendaListPage({super.key});

  @override
  State<AgendaListPage> createState() => _AgendaListPageState();
}

class _AgendaListPageState extends State<AgendaListPage> {
  String selectedFilter = 'Hari Ini';

  @override
  void initState() {
    super.initState();
    context.read<AgendaBloc>().add(LoadAgenda());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'List Agenda',
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFilter(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AgendaBloc, AgendaState>(
                builder: (context, state) {
                  if (state is AgendaLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AgendaLoaded) {
                    final allAgendas = [...state.agendas];
                    allAgendas.sort((a, b) {
                      final aDate = a.date ?? DateTime(2000);
                      final bDate = b.date ?? DateTime(2000);
                      return bDate.compareTo(aDate);
                    });

                    final now = DateTime.now();
                    final next3Days = now.add(const Duration(days: 3));

                    final filtered =
                        selectedFilter == 'Hari Ini'
                            ? allAgendas.where((a) {
                              return a.date != null &&
                                  a.date!.year == now.year &&
                                  a.date!.month == now.month &&
                                  a.date!.day == now.day;
                            }).toList()
                            : allAgendas.where((a) {
                              return a.date != null &&
                                  a.date!.isAfter(
                                    now.subtract(const Duration(seconds: 1)),
                                  ) &&
                                  a.date!.isBefore(
                                    next3Days.add(const Duration(days: 1)),
                                  );
                            }).toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tidak ada agenda yang tersedia.',
                          style: TextStyle(color: AppColors.onSecondary),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildAgendaCard(filtered[index]);
                      },
                    );
                  }

                  if (state is AgendaError) {
                    return Center(
                      child: Text(
                        'Gagal: ${state.message}',
                        style: const TextStyle(color: AppColors.onError),
                      ),
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

  Widget _buildFilter() {
    final filters = ['Hari Ini', 'Next 3 Hari'];

    return Row(
      children:
          filters.map((f) {
            final selected = f == selectedFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  f,
                  style: TextStyle(
                    fontSize: AppTextSize.bodySmall,
                    color: selected ? Colors.white : AppColors.onPrimary,
                  ),
                ),
                selected: selected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onSelected: (_) {
                  setState(() => selectedFilter = f);
                },
              ),
            );
          }).toList(),
    );
  }

  Widget _buildAgendaCard(AgendasModel agenda) {
    final dateText =
        agenda.date != null
            ? DateFormat('dd\nMMM', 'id_ID').format(agenda.date!.toLocal())
            : '--\n--';
    final timeText =
        agenda.date != null
            ? DateFormat.Hm().format(agenda.date!.toLocal())
            : '--:--';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 110,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              dateText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agenda.title ?? 'Tanpa Judul',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppTextSize.bodyLarge,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  Text(
                    agenda.location ?? '-',
                    style: TextStyle(
                      color: AppColors.onSecondary,
                      fontSize: AppTextSize.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeText,
                        style: TextStyle(
                          color: AppColors.primaryBoldVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AgendaDetailDialog(agenda: agenda),
                          );
                        },
                        child: const Text(
                          'Detail',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AgendaDetailDialog extends StatelessWidget {
  final AgendasModel agenda;

  const AgendaDetailDialog({super.key, required this.agenda});

  @override
  Widget build(BuildContext context) {
    final participantsText =
        (agenda.participants != null && agenda.participants!.isNotEmpty)
            ? agenda.participants!.map((e) => e.name).join(', ')
            : '-';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        agenda.title ?? 'Detail Agenda',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppTextSize.headingSmall,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(
              'Tanggal',
              agenda.date != null
                  ? DateFormat.yMMMMEEEEd().format(agenda.date!.toLocal())
                  : '-',
            ),
            const SizedBox(height: 8),
            _buildRow(
              'Waktu',
              agenda.date != null
                  ? DateFormat.Hm().format(agenda.date!.toLocal())
                  : '--:--',
            ),
            const SizedBox(height: 8),
            _buildRow('Lokasi', agenda.location ?? '-'),
            const SizedBox(height: 8),
            _buildRow('Deskripsi', agenda.description ?? '-'),
            const SizedBox(height: 8),
            _buildRow('Partisipan', participantsText),
          ],
        ),
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
