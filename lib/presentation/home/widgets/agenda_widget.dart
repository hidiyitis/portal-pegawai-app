import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_event.dart';

class AgendaWidget extends StatefulWidget {
  const AgendaWidget({super.key, required List<Map<String, dynamic>> agendas});

  @override
  State<AgendaWidget> createState() => _AgendaWidgetState();
}

class _AgendaWidgetState extends State<AgendaWidget> {
  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(horizontal: 2),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: AppColors.onPrimary,
                overlayColor: Colors.transparent,
              ),
              onPressed:
                  () => context.read<NavigationBloc>().add(
                    NavigationTabChanged(1),
                  ),
              child: Row(
                children: [
                  Text(
                    'Lihat Selengkapnya',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: AppTextSize.bodyLarge,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_outlined,
                    size: 24,
                    color: AppColors.onPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [AppColors.primaryBoldVariant, AppColors.primary],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '12:30 AM',
                  style: TextStyle(
                    color: AppColors.onBackground,
                    fontSize: AppTextSize.headingLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sprint Planning - Ruang Meeting 10',
                  style: TextStyle(
                    color: AppColors.onBackground,
                    fontSize: AppTextSize.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
