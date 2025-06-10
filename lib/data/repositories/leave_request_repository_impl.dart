import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/errors/error.dart';
import 'package:portal_pegawai_app/data/datasources/leave_request_remote_data_source.dart';
import 'package:portal_pegawai_app/domain/entities/leave_request_entity.dart';
import 'package:portal_pegawai_app/domain/repositories/leave_request_repository.dart';

// Implementasi konkret dari LeaveRequestRepository
// Kelas ini mengimplementasikan kontrak yang didefinisikan di domain layer
// dan menerjemahkan panggilan ke remote data source
class LeaveRequestRepositoryImpl implements LeaveRequestRepository {
  final LeaveRequestRemoteDataSource remoteDataSource;

  LeaveRequestRepositoryImpl({required this.remoteDataSource});

  // Implementasi method untuk membuat pengajuan cuti baru
  // Method ini bertugas menangani error dan mengkonversi model ke entity
  @override
  Future<LeaveRequestEntity> createLeaveRequest(
    CreateLeaveRequestEntity leaveRequest,
    XFile? attachmentFile,
  ) async {
    try {
      // Panggil remote data source untuk komunikasi dengan backend
      // Remote data source mengembalikan model yang perlu dikonversi ke entity
      final result = await remoteDataSource.createLeaveRequest(
        leaveRequest,
        attachmentFile,
      );

      // Konversi model menjadi entity untuk business logic layer
      // Ini memastikan domain layer tidak bergantung pada detail implementasi data layer
      return result.toEntity();
    } on DioException catch (e) {
      // Handle network dan server errors dengan mapping ke custom exception
      // Custom exception membantu UI layer menampilkan pesan error yang tepat
      throw ServerExecption(
        message:
            e.response?.data['message'] ?? 'Failed to create leave request',
      );
    } catch (e) {
      // Handle unexpected errors
      throw ServerExecption(
        message: 'Unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Implementasi method untuk mendapatkan daftar pengajuan cuti
  @override
  Future<List<LeaveRequestEntity>> getLeaveRequests(String? status) async {
    try {
      final result = await remoteDataSource.getLeaveRequests(status);

      // Konversi list model menjadi list entity
      // Setiap model dikonversi ke entity menggunakan method toEntity()
      return result.map((model) => model.toEntity()).toList();
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Failed to load leave requests',
      );
    } catch (e) {
      throw ServerExecption(
        message: 'Unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Implementasi method untuk mendapatkan dashboard data
  // Mengembalikan Map untuk fleksibilitas data dashboard
  @override
  Future<Map<String, dynamic>> getLeaveRequestDashboard() async {
    try {
      final result = await remoteDataSource.getLeaveRequestDashboard();

      // Konversi dashboard model menjadi Map untuk kemudahan penggunaan
      // Map memberikan fleksibilitas dalam mengakses data dashboard
      return {
        'leave_quota': result.leaveQuota,
        'in_progress': result.inProgress,
        'cancelled': result.cancelled,
        'rejected': result.rejected,
        'completed': result.completed,
      };
    } on DioException catch (e) {
      throw ServerExecption(
        message: e.response?.data['message'] ?? 'Failed to load dashboard',
      );
    } catch (e) {
      throw ServerExecption(
        message: 'Unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Implementasi method untuk update status pengajuan cuti
  @override
  Future<LeaveRequestEntity> updateLeaveRequestStatus(
    int leaveId,
    String status,
  ) async {
    try {
      final result = await remoteDataSource.updateLeaveRequestStatus(
        leaveId,
        status,
      );

      return result.toEntity();
    } on DioException catch (e) {
      throw ServerExecption(
        message:
            e.response?.data['message'] ?? 'Failed to update leave request',
      );
    } catch (e) {
      throw ServerExecption(
        message: 'Unexpected error occurred: ${e.toString()}',
      );
    }
  }
}
