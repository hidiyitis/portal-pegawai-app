import 'dart:ui';
import 'package:portal_pegawai_app/data/models/user_model.dart';

class AgendaModel {
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final String dateLabel;

  AgendaModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.dateLabel,
  });
}

class AgendasModel {
  int? agendaId;
  String? title;
  DateTime? date;
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

  /// 🔄 JSON deserialization
  factory AgendasModel.fromJson(Map<String, dynamic> json) {
    return AgendasModel(
      agendaId: json['agenda_id'],
      title: json['title'],
      date:
          json['date'] != null ? DateTime.parse(json['date']).toLocal() : null,
      location: json['location'],
      description: json['description'],
      createdBy: json['created_by'],
      creator:
          json['creator'] != null ? UserModel.fromJson(json['creator']) : null,
      participants:
          json['participants'] != null
              ? (json['participants'] as List)
                  .map((e) => UserModel.fromJson(e))
                  .toList()
              : [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  /// 🔄 JSON serialization (for POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'date': date?.toUtc().toIso8601String(),
      'created_by': createdBy,
      'participants': participants?.map((e) => e.nip).toList(), // ⬅️ penting
    };
  }
}
