import 'package:equatable/equatable.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';

abstract class AgendaEvent extends Equatable {
  const AgendaEvent();

  @override
  List<Object?> get props => [];
}

class LoadAgenda extends AgendaEvent {}

class AddAgenda extends AgendaEvent {
  final AgendasModel agenda;

  const AddAgenda(this.agenda);

  @override
  List<Object?> get props => [agenda];
}
