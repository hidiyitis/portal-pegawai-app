import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class CalendarHeader extends StatefulWidget {
  const CalendarHeader({super.key});

  @override
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  DateTime _focusedMonth = DateTime.now();
  DateTime? _selectedDate;

  final List<String> weekdays = [
    'Min',
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final totalDaysInMonth = DateUtils.getDaysInMonth(
      _focusedMonth.year,
      _focusedMonth.month,
    );
    final startWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    // Add blank days
    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    // Add day buttons
    for (int i = 1; i <= totalDaysInMonth; i++) {
      final currentDate = DateTime(_focusedMonth.year, _focusedMonth.month, i);
      final isSelected =
          _selectedDate != null &&
          _selectedDate!.day == i &&
          _selectedDate!.month == _focusedMonth.month &&
          _selectedDate!.year == _focusedMonth.year;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : null,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              i.toString(),
              style: TextStyle(
                color:
                    isSelected ? AppColors.onBackground : AppColors.onPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: AppTextSize.bodyMedium,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month - 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_left, color: AppColors.onPrimary),
            ),
            Column(
              children: [
                Text(
                  DateFormat.MMMM('id_ID').format(_focusedMonth),
                  style: TextStyle(
                    fontSize: AppTextSize.bodyLarge,
                    color: AppColors.onPrimary,
                  ),
                ),
                Text(
                  DateFormat.y('id_ID').format(_focusedMonth),
                  style: TextStyle(
                    fontSize: AppTextSize.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(
                    _focusedMonth.year,
                    _focusedMonth.month + 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_right, color: AppColors.onPrimary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children:
                weekdays.map((day) {
                  final isSunday = day == 'Min';
                  return Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppTextSize.bodySmall,
                        color:
                            isSunday ? AppColors.onError : AppColors.onPrimary,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            children: dayWidgets,
          ),
        ),
      ],
    );
  }
}
