import 'dart:ui';

import 'package:portal_pegawai_app/data/models/user_model.dart';

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

class AgendasModel {
  int? agendaId;
  String? title;
  String? date;
  String? location;
  String? description;
  int? createdBy;
  UserModel? creator;
  List<UserModel>? participants;
  String? createdAt;
  String? updatedAt;

  AgendasModel({
    this.agendaId,
    this.title,
    this.date,
    this.location,
    this.description,
    this.createdBy,
    this.creator,
    this.participants,
    this.createdAt,
    this.updatedAt,
  });
  factory AgendasModel.fromJson(Map<String, dynamic> json) {
    return AgendasModel(
      agendaId: json['agenda_id'],
      title: json['title'],
      date: json['date'],
      location: json['location'],
      description: json['description'],
      createdBy: json['created_by'],
      creator:
          json['creator'] != null ? UserModel.fromJson(json['creator']) : null,
      participants:
          json['participants'].length > 0
              ? (json['participants'] as List)
                  .map((e) => UserModel.fromJson(e))
                  .toList()
              : [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
