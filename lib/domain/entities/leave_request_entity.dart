// Domain entity untuk leave request
// Entitas ini merepresentasikan model bisnis murni untuk pengajuan cuti
class LeaveRequestEntity {
  final int? leaveId;
  final String title;
  final int userNip;
  final int managerNip;
  final DateTime startDate;
  final DateTime endDate;
  final String? attachmentUrl;
  final String? description;
  final String status;

  LeaveRequestEntity({
    this.leaveId,
    required this.title,
    required this.userNip,
    required this.managerNip,
    required this.startDate,
    required this.endDate,
    this.attachmentUrl,
    this.description,
    this.status = 'IN_PROGRESS', // Default status untuk pengajuan baru
  });
}

// DTO untuk input pengajuan cuti baru
// Memisahkan input dari entitas untuk fleksibilitas
class CreateLeaveRequestEntity {
  final String title;
  final String startDate; // Format ISO8601 string
  final String endDate; // Format ISO8601 string
  final int managerNip;
  final String? description;

  CreateLeaveRequestEntity({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.managerNip,
    this.description,
  });
}
