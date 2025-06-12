import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';

class CalendarHeader extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final List<DateTime> agendaDates;

  const CalendarHeader({
    super.key,
    this.onDateSelected,
    required this.agendaDates,
  });

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
    super.initState();
    _selectedDate = DateTime.now();
  }

  bool _hasAgenda(DateTime day) {
    return widget.agendaDates.any(
      (aDate) =>
          aDate.year == day.year &&
          aDate.month == day.month &&
          aDate.day == day.day,
    );
  }

  bool _isPast(DateTime day) {
    final now = DateTime.now();
    return day.isBefore(DateTime(now.year, now.month, now.day));
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

    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox.shrink());
    }

    for (int i = 1; i <= totalDaysInMonth; i++) {
      final currentDate = DateTime(_focusedMonth.year, _focusedMonth.month, i);
      final isSelected =
          _selectedDate != null &&
          _selectedDate!.day == i &&
          _selectedDate!.month == _focusedMonth.month &&
          _selectedDate!.year == _focusedMonth.year;

      final hasAgenda = _hasAgenda(currentDate);
      final isPast = _isPast(currentDate);

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = currentDate;
            });
            widget.onDateSelected?.call(currentDate);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : null,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  i.toString(),
                  style: TextStyle(
                    color:
                        isSelected
                            ? AppColors.onBackground
                            : AppColors.onPrimary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: AppTextSize.bodyMedium,
                  ),
                ),
                if (hasAgenda)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isPast ? AppColors.onError : AppColors.primary,
                      ),
                    ),
                  ),
              ],
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
