import 'package:equatable/equatable.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';

abstract class AgendaState extends Equatable {
  const AgendaState();

  @override
  List<Object?> get props => [];
}

class AgendaInitial extends AgendaState {}

class AgendaLoading extends AgendaState {}

class AgendaLoaded extends AgendaState {
  final List<AgendasModel> agendas;

  const AgendaLoaded(this.agendas);

  @override
  List<Object?> get props => [agendas];
}

class AgendaError extends AgendaState {
  final String message;

  const AgendaError(this.message);

  @override
  List<Object?> get props => [message];
}
