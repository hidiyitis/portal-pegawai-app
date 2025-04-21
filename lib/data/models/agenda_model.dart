import 'dart:ui';

class AgendaModel {
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final String dateLabel; // ✅ Tambahkan ini

  AgendaModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.dateLabel, // ✅ Tambahkan ini
  });
}
