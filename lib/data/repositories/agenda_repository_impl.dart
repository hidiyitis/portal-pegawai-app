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
      return await remote.getListAgenda();
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Get agenda failed',
      );
    }
  }

  @override
  Future<void> createAgenda(AgendasModel agenda) async {
    try {
      await remote.createAgenda(agenda);
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Create agenda failed',
      );
    }
  }

  @override
  Future<void> updateAgenda(int id, AgendasModel agenda) async {
    try {
      await remote.updateAgenda(id, agenda);
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Update agenda failed',
      );
    }
  }

  @override
  Future<void> deleteAgenda(int id) async {
    try {
      await remote.deleteAgenda(id);
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Delete agenda failed',
      );
    }
  }

  @override
  Future<AgendasModel> getAgendaById(int id) async {
    try {
      return await remote.getAgendaById(id);
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Get agenda by ID failed',
      );
    }
  }

  @override
  Future<List<AgendasModel>> getAllAgendas() async {
    try {
      return await remote.getAllAgendas();
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Get all agenda failed',
      );
    }
  }
}
