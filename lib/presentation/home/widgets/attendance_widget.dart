import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_event.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';

class AttendanceWidget extends StatelessWidget {
  const AttendanceWidget({
    super.key,
    required bool isClockedIn,
    String? lastClockInPhoto,
    required Future<void> Function() onClockIn,
    required void Function() onClockOut,
    Position? lastClockInPosition,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeDataLoaded) {
          return Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.currentDate,
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: AppTextSize.headingSmall,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Runtutan',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: AppTextSize.bodyLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      () =>
                          !state.isClockedIn
                              ? context.read<HomeBloc>().processClockIn(context)
                              : context.read<HomeBloc>().add(
                                ClockOutRequested(),
                              ),
                  child: Text(
                    !state.isClockedIn ? 'Clock In' : 'Clock Out',
                    style: TextStyle(
                      color: AppColors.onBackground,
                      fontSize: AppTextSize.bodyLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}
