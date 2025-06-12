import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/data/models/leave_request_model.dart';
import 'package:portal_pegawai_app/domain/entities/leave_request_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Abstract class untuk mendefinisikan kontrak remote data source
// Ini memungkinkan kita untuk mudah mengganti implementasi jika diperlukan
abstract class LeaveRequestRemoteDataSource {
  Future<LeaveRequestModel> createLeaveRequest(
    CreateLeaveRequestEntity leaveRequest,
    XFile? attachmentFile,
  );

  Future<List<LeaveRequestModel>> getLeaveRequests(String? status);
  Future<LeaveRequestDashboardModel> getLeaveRequestDashboard();
  Future<LeaveRequestModel> updateLeaveRequestStatus(
    int leaveId,
    String status,
  );
}

// Implementasi konkret dari remote data source
// Kelas ini menangani semua komunikasi HTTP dengan backend
class LeaveRequestRemoteDataSourceImpl implements LeaveRequestRemoteDataSource {
  final Dio dio;

  LeaveRequestRemoteDataSourceImpl({required this.dio});

  // Method untuk membuat pengajuan cuti baru
  // Menggunakan multipart form data karena ada file upload
  @override
  Future<LeaveRequestModel> createLeaveRequest(
    CreateLeaveRequestEntity leaveRequest,
    XFile? attachmentFile,
  ) async {
    try {
      // Ambil token autentikasi dari storage lokal
      var token = getIt<SharedPreferences>().getString('access_token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Siapkan FormData untuk multipart request
      // FormData diperlukan karena kita mengirim file dan data text bersamaan
      final formData = FormData.fromMap({
        'title': leaveRequest.title,
        'start_date': leaveRequest.startDate, // Sudah dalam format ISO8601
        'end_date': leaveRequest.endDate, // Sudah dalam format ISO8601
        'manager_nip': leaveRequest.managerNip,
        'description': leaveRequest.description ?? '',
      });

      // Tambahkan file jika ada
      // File akan diupload sebagai multipart file
      if (attachmentFile != null) {
        formData.files.add(
          MapEntry(
            'file', // Key yang diharapkan backend
            await MultipartFile.fromFile(
              attachmentFile.path,
              filename: attachmentFile.name,
            ),
          ),
        );
      }

      // Kirim POST request ke endpoint leave-request
      final response = await dio.post(
        '/leave-request',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            // Content-Type akan otomatis di-set ke multipart/form-data oleh Dio
          },
        ),
      );

      // Validasi response status
      if (response.statusCode == 201) {
        // Parse response JSON menjadi model object
        return LeaveRequestModel.fromJson(response.data);
      }

      throw Exception('Failed to create leave request: ${response.statusCode}');
    } on DioException catch (e) {
      // Handle error dari server dengan menampilkan pesan yang jelas
      String errorMessage = 'Network error occurred';

      if (e.response?.data != null) {
        // Ambil pesan error dari server jika ada
        errorMessage = e.response?.data['message'] ?? 'Server error occurred';
      }

      throw Exception('Failed to create leave request: $errorMessage');
    } catch (e) {
      // Handle error umum lainnya
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }

  // Method untuk mendapatkan daftar pengajuan cuti
  @override
  Future<List<LeaveRequestModel>> getLeaveRequests(String? status) async {
    try {
      var token = getIt<SharedPreferences>().getString('access_token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Siapkan query parameters jika status ada
      Map<String, dynamic> queryParameters = {};
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await dio.get(
        '/leave-request',
        queryParameters: queryParameters,
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

        // Konversi setiap item dalam list menjadi LeaveRequestModel
        return dataList.map((item) {
          try {
            return LeaveRequestModel.fromJson(item);
          } catch (e) {
            throw FormatException('Failed to parse leave request item: $e');
          }
        }).toList();
      }

      throw Exception('Failed to load leave requests: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(
        'Server error: ${e.response?.data['message'] ?? 'Unknown error'}',
      );
    }
  }

  // Method untuk mendapatkan dashboard data
  @override
  Future<LeaveRequestDashboardModel> getLeaveRequestDashboard() async {
    try {
      var token = getIt<SharedPreferences>().getString('access_token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await dio.get(
        '/dashboard-leave-request',
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
        return LeaveRequestDashboardModel.fromJson(responseData['data']);
      }

      throw Exception('Failed to load dashboard: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(
        'Server error: ${e.response?.data['message'] ?? 'Unknown error'}',
      );
    }
  }

  // Method untuk update status pengajuan (untuk manager)
  @override
  Future<LeaveRequestModel> updateLeaveRequestStatus(
    int leaveId,
    String status,
  ) async {
    try {
      var token = getIt<SharedPreferences>().getString('access_token');
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await dio.put(
        '/leave-request/$leaveId',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return LeaveRequestModel.fromJson(response.data);
      }

      throw Exception('Failed to update leave request: ${response.statusCode}');
    } on DioException catch (e) {
      throw Exception(
        'Server error: ${e.response?.data['message'] ?? 'Unknown error'}',
      );
    }
  }
}
