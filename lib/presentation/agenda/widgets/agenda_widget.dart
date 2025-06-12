import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/agenda/pages/agenda_list_page.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';

class AgendaWidget extends StatelessWidget {
  const AgendaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeDataLoaded) {
          final allAgendas = state.agendas;
          final now = DateTime.now();
          final agendasToday =
              allAgendas.where((a) {
                final d = a.date?.toLocal();
                return d != null &&
                    d.year == now.year &&
                    d.month == now.month &&
                    d.day == now.day;
              }).toList();
          print('📅 Today: ${DateTime.now()}');
          for (var a in allAgendas) {
            print(
              '🔹 Agenda: ${a.title}, date: ${a.date}, local: ${a.date?.toLocal()}',
            );
          }
          print('HomeDataLoaded total agendas: ${state.agendas.length}');

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agenda',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppTextSize.bodyLarge,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: AppColors.onPrimary,
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AgendaListPage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Lihat Selengkapnya',
                          style: TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: AppTextSize.bodyLarge,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_outlined,
                          size: 24,
                          color: AppColors.onPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (agendasToday.isNotEmpty)
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryBoldVariant,
                          AppColors.primary,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(
                            agendasToday.first.date!.toLocal().toString(),
                          ),
                          style: TextStyle(
                            color: AppColors.onBackground,
                            fontSize: AppTextSize.headingLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${agendasToday.first.title} - ${agendasToday.first.location}',
                          style: TextStyle(
                            color: AppColors.onBackground,
                            fontSize: AppTextSize.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.surface,
                  ),
                  child: Text(
                    'Tidak ada agenda hari ini',
                    style: TextStyle(color: AppColors.onPrimary),
                  ),
                ),
            ],
          );
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.surface,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator(color: AppColors.primary)],
          ),
        );
      },
    );
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString).toLocal();
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return '--:--';
    }
  }
}
