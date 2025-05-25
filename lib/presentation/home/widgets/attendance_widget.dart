import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_bloc.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';

class AttendanceWidget extends StatelessWidget {
  const AttendanceWidget({
    super.key,
    required bool isClockedIn,
    required bool isClockedOut,
    required Future<void> Function() onClockInOut,
    String? lastClockIn,
    String? lastClockOut,
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
              state.isClockedIn || state.isClockedOut
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.isClockedIn ? 'Clock In' : 'Clock Out',
                        style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: AppTextSize.bodyLarge,
                        ),
                      ),
                      Text(
                        state.isClockedIn
                            ? state.lastClockIn!
                            : state.lastClockOut!,
                        style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: AppTextSize.bodyLarge,
                        ),
                      ),
                    ],
                  )
                  : Center(
                    child: Text(
                      'Belum melakukan Clock In',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: AppTextSize.bodyLarge,
                      ),
                    ),
                  ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      () =>
                          (!state.isClockedIn || !state.isClockedOut)
                              ? context.read<HomeBloc>().processClockInClockOut(
                                context,
                              )
                              : null,
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
