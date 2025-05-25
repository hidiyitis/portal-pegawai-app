import 'package:dio/dio.dart';
import 'package:portal_pegawai_app/core/errors/error.dart';
import 'package:portal_pegawai_app/data/datasources/agenda_remote_data_source.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';
import 'package:portal_pegawai_app/domain/repositories/agenda_repository.dart';

class AgendaRepositoryImpl implements AgendaRepository {
  final AgendaRemoteDataSource remote;

  AgendaRepositoryImpl({required this.remote});
  @override
  Future<List<AgendasModel>> getListAgenda() async {
    try {
      var res = await remote.getListAgenda();
      return res;
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Get agenda failed',
      );
    }
  }
}
