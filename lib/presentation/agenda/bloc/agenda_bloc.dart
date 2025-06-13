import 'package:flutter_bloc/flutter_bloc.dart';
import 'agenda_event.dart';
import 'agenda_state.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';
import 'package:portal_pegawai_app/domain/repositories/agenda_repository.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final AgendaRepository repository;

  AgendaBloc({required this.repository}) : super(AgendaInitial()) {
    on<LoadAgenda>((event, emit) async {
      emit(AgendaLoading());

      try {
        final agendas = await repository.getAllAgendas(); // Muat semua agenda
        emit(AgendaLoaded(agendas));
      } catch (e) {
        emit(AgendaError(e.toString()));
      }
    });

    on<AddAgenda>((event, emit) async {
      emit(AgendaLoading());

      try {
        await repository.createAgenda(event.agenda);
        final agendas = await repository.getAllAgendas();
        emit(AgendaLoaded(agendas));
      } catch (e) {
        emit(AgendaError(e.toString()));
      }
    });

    on<LoadAgendaByDate>((event, emit) async {
      emit(AgendaLoading());

      try {
        final agendas = await repository.getAgendaByDate(event.date);
        emit(AgendaLoaded(agendas));
      } catch (e) {
        emit(AgendaError(e.toString()));
      }
    });
  }
}
