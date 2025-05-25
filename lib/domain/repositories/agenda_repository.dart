import 'package:portal_pegawai_app/data/models/agenda_model.dart';

abstract class AgendaRepository {
  Future<List<AgendasModel>> getListAgenda();
}
