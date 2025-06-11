import 'package:dio/dio.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AgendaRemoteDataSource {
  Future<List<AgendasModel>> getListAgenda();
  Future<void> createAgenda(AgendasModel agenda);
  Future<void> updateAgenda(int id, AgendasModel agenda);
  Future<void> deleteAgenda(int id);
  Future<AgendasModel> getAgendaById(int id);
  Future<List<AgendasModel>> getAllAgendas();
}

class AgendaRemoteDataSourceImpl implements AgendaRemoteDataSource {
  final Dio dio;

  AgendaRemoteDataSourceImpl({required this.dio});

  SharedPreferences get prefs => getIt<SharedPreferences>();

  @override
  Future<List<AgendasModel>> getListAgenda() async {
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('Authentication token not found');

    // final today = DateTime.now().toUtc().toIso8601String().split('T').first;
    final today =
        DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).toIso8601String(); // Hasil: 2025-06-11T00:00:00.000Z

    final response = await dio.get(
      '/agendas',
      queryParameters: {'date': today},
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = response.data as Map<String, dynamic>;
      final dataList = responseData['data'] as List;

      return dataList.map((item) {
        try {
          return AgendasModel.fromJson(item);
        } catch (e) {
          throw FormatException('Failed to parse agenda item: $e');
        }
      }).toList();
    }
    throw Exception('Failed to load agendas: ${response.statusCode}');
  }

  @override
  Future<void> createAgenda(AgendasModel agenda) async {
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('Authentication token not found');

    await dio.post(
      '/agendas',
      data: {
        "title": agenda.title,
        "date": agenda.date?.toUtc().toIso8601String(),
        "location": agenda.location,
        "description": agenda.description,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  @override
  Future<void> updateAgenda(int id, AgendasModel agenda) async {
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('Authentication token not found');

    await dio.put(
      '/agendas/$id',
      data: {
        "title": agenda.title,
        "date": agenda.date?.toUtc().toIso8601String(),
        "location": agenda.location,
        "description": agenda.description,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  @override
  Future<void> deleteAgenda(int id) async {
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('Authentication token not found');

    await dio.delete(
      '/agendas/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
  }

  @override
  Future<AgendasModel> getAgendaById(int id) async {
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('Authentication token not found');

    final response = await dio.get(
      '/agendas/$id',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return AgendasModel.fromJson(response.data['data']);
    }

    throw Exception('Failed to fetch agenda by ID: ${response.statusCode}');
  }

  @override
  Future<List<AgendasModel>> getAllAgendas() async {
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('Token not found');

    final response = await dio.get(
      '/agendas/all',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final dataList = response.data['data'] as List;
      return dataList.map((e) => AgendasModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch all agendas');
    }
  }
}
