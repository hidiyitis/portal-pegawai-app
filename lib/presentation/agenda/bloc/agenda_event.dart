import 'package:equatable/equatable.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';

abstract class AgendaEvent extends Equatable {
  const AgendaEvent();

  @override
  List<Object?> get props => [];
}

// Memuat semua agenda
class LoadAgenda extends AgendaEvent {}

// Memuat agenda berdasarkan tanggal
class LoadAgendaByDate extends AgendaEvent {
  final DateTime date;

  const LoadAgendaByDate(this.date);

  @override
  List<Object?> get props => [date];
}

// Menambahkan agenda baru
class AddAgenda extends AgendaEvent {
  final AgendasModel agenda;

  const AddAgenda(this.agenda);

  @override
  List<Object?> get props => [agenda];
}
