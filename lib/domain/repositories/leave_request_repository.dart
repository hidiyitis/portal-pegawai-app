import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/domain/entities/leave_request_entity.dart';

// Abstract repository untuk leave request
// Interface ini mendefinisikan kontrak yang harus dipenuhi oleh implementasi konkret
// Pendekatan ini memungkinkan kita mengganti implementasi tanpa mengubah business logic
abstract class LeaveRequestRepository {
  // Method untuk membuat pengajuan cuti baru
  // Menerima data pengajuan dan file lampiran (opsional)
  // File akan diupload ke server sebagai multipart data
  Future<LeaveRequestEntity> createLeaveRequest(
    CreateLeaveRequestEntity leaveRequest,
    XFile? attachmentFile, // File lampiran bisa null (opsional)
  );

  // Method untuk mendapatkan daftar pengajuan cuti berdasarkan status
  // Status bisa: 'IN_PROGRESS', 'COMPLETED', 'REJECTED', 'CANCELLED'
  // Jika status null, ambil semua pengajuan
  Future<List<LeaveRequestEntity>> getLeaveRequests(String? status);

  // Method untuk mendapatkan dashboard data kuota cuti
  // Berisi informasi kuota total, dalam pengajuan, ditolak, disetujui
  Future<Map<String, dynamic>> getLeaveRequestDashboard();

  // Method untuk update status pengajuan cuti (untuk manager)
  // Digunakan ketika manager approve/reject pengajuan
  Future<LeaveRequestEntity> updateLeaveRequestStatus(
    int leaveId,
    String status,
  );
}
