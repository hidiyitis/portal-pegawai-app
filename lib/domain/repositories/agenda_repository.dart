import 'package:portal_pegawai_app/data/models/agenda_model.dart';

abstract class AgendaRepository {
  Future<List<AgendasModel>> getListAgenda();
  Future<void> createAgenda(AgendasModel agenda);
  Future<void> updateAgenda(int id, AgendasModel agenda);
  Future<void> deleteAgenda(int id);
  Future<AgendasModel> getAgendaById(int id);
  Future<List<AgendasModel>> getAllAgendas();
}
