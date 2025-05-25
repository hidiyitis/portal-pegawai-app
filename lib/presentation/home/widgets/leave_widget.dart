import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/common/constants/routes/routes_name.dart';
import 'package:portal_pegawai_app/core/configs/assets/app_icons.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:portal_pegawai_app/presentation/bottom_navigation/bloc/navigation_event.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';

class LeaveWidget extends StatelessWidget {
  const LeaveWidget({super.key, required int leaveQuota});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeDataLoaded) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.background, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sisa Kuota Cuti'),
                        Text(
                          '${state.leaveQuota}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: AppTextSize.headingLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            RoutesName.pengajuanCuti,
                          ),
                      child: Text(
                        'Ajukan Cuti',
                        style: TextStyle(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap:
                          () => Navigator.pushNamed(
                            context,
                            RoutesName.pengajuanCuti,
                          ),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(AppIcons.fileIcon),
                            width: 28,
                          ),
                          Text('Riwayat'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          () => context.read<NavigationBloc>().add(
                            NavigationTabChanged(1),
                          ),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(AppIcons.calendarIcon),
                            width: 28,
                          ),
                          Text('Kalender'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
