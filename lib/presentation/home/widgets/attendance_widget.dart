import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/constants/date.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class AttendanceWidget extends StatefulWidget {
  const AttendanceWidget({super.key});

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  final date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${DateConstant.day[date.weekday - 1]}, ${date.day} ${DateConstant.bulan[date.month - 1]} ${date.year}',
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
            onPressed: () {},
            child: Text(
              'Clock In',
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
}
