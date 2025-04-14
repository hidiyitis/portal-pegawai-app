import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/core/configs/assets/app_icons.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class LeaveWidget extends StatefulWidget {
  const LeaveWidget({super.key});

  @override
  State<LeaveWidget> createState() => _LeaveWidgetState();
}

class _LeaveWidgetState extends State<LeaveWidget> {
  @override
  Widget build(BuildContext context) {
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
                    '10',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppTextSize.headingLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
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
                onTap: () {},
                child: Column(
                  children: [
                    Image(image: AssetImage(AppIcons.fileIcon), width: 28),
                    Text('Riwayat'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Image(image: AssetImage(AppIcons.calendarIcon), width: 28),
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
}
