import 'package:dio/dio.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/data/models/agenda_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AgendaRemoteDataSource {
  Future<List<AgendasModel>> getListAgenda();
}

class AgendaRemoteDataSourceImpl implements AgendaRemoteDataSource {
  final Dio dio;

  AgendaRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AgendasModel>> getListAgenda() async {
    try {
      var token = getIt<SharedPreferences>().getString('access_token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await dio.get(
        '/agendas',
        queryParameters: {'date': DateTime.now().toUtc().toIso8601String()},
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
    } on DioException catch (e) {
      throw Exception('Server error: ${e.response?.data['message']}');
    }
  }
}
