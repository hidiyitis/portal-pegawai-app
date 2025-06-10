import 'package:flutter/material.dart';
import 'package:portal_pegawai_app/domain/entities/leave_request_entity.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';

// Model yang diperbaiki untuk menangani data manager dengan lebih comprehensive
// Kita perlu memahami bahwa leave request tidak hanya berisi ID manager,
// tetapi juga perlu informasi lengkap tentang manager tersebut
class LeaveRequestModel extends LeaveRequestEntity {
  // Tambahkan property untuk menyimpan data manager lengkap
  // Ini memungkinkan kita menampilkan nama manager tanpa lookup tambahan
  final UserModel? manager;

  LeaveRequestModel({
    super.leaveId,
    required super.title,
    required super.userNip,
    required super.managerNip,
    required super.startDate,
    required super.endDate,
    super.attachmentUrl,
    super.description,
    required super.status,
    this.manager, // Manager data opsional karena mungkin tidak selalu di-include dalam response
  });

  // Factory constructor yang diperbaiki untuk menangani berbagai format response dari backend
  // Backend mungkin mengirim data manager dalam berbagai cara:
  // 1. Sebagai object nested dalam response leave request
  // 2. Sebagai data terpisah yang perlu di-join
  // 3. Atau tidak sama sekali (untuk backward compatibility)
  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    // Parse manager data jika tersedia dalam response
    // Ini mengikuti prinsip "graceful degradation" - aplikasi tetap berfungsi
    // meskipun beberapa data tidak tersedia
    UserModel? managerData;
    if (json.containsKey('manager') && json['manager'] != null) {
      try {
        managerData = UserModel.fromJson(json['manager']);
      } catch (e) {
        // Log error tetapi jangan crash aplikasi
        print('Warning: Failed to parse manager data: $e');
        managerData = null;
      }
    }

    return LeaveRequestModel(
      leaveId: json['leave_id'],
      title: json['title'],
      userNip: json['user_nip'],
      managerNip: json['manager_nip'],
      // Parse tanggal dengan error handling yang robust
      // Beberapa backend mungkin mengirim format tanggal yang berbeda
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      attachmentUrl: json['attachment_url'],
      description: json['description'],
      // Normalize status untuk konsistensi
      // Backend mungkin mengirim status dalam format yang berbeda (uppercase, lowercase, dll)
      status: _normalizeStatus(json['status']),
      manager: managerData,
    );
  }

  // Helper method untuk parsing tanggal yang lebih robust
  // Method ini menangani berbagai format tanggal yang mungkin dikirim backend
  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();

    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue).toLocal();
      } else if (dateValue is DateTime) {
        return dateValue.toLocal();
      } else {
        // Fallback untuk format yang tidak dikenal
        return DateTime.now();
      }
    } catch (e) {
      print('Warning: Failed to parse date $dateValue: $e');
      return DateTime.now();
    }
  }

  // Helper method untuk normalisasi status
  // Ini memastikan status selalu dalam format yang konsisten untuk UI
  static String _normalizeStatus(dynamic statusValue) {
    if (statusValue == null) return 'IN_PROGRESS';

    String status = statusValue.toString().toUpperCase();

    // Map berbagai variasi status yang mungkin dikirim backend
    // ke format standar yang kita gunakan dalam aplikasi
    switch (status) {
      case 'IN_PROGRESS':
      case 'PENDING':
      case 'DALAM_PENGAJUAN':
        return 'IN_PROGRESS';
      case 'COMPLETED':
      case 'APPROVED':
      case 'DISETUJUI':
        return 'COMPLETED';
      case 'REJECTED':
      case 'DITOLAK':
        return 'REJECTED';
      case 'CANCELLED':
      case 'DIBATALKAN':
        return 'CANCELLED';
      default:
        // Default ke IN_PROGRESS untuk status yang tidak dikenal
        return 'IN_PROGRESS';
    }
  }

  // Method untuk mendapatkan nama manager dengan fallback yang elegant
  // Ini mengikuti prinsip "progressive enhancement" - aplikasi memberikan
  // pengalaman terbaik ketika data lengkap tersedia, tetapi tetap berfungsi
  // dengan data terbatas
  String getManagerName() {
    if (manager != null) {
      return manager!.name;
    } else {
      // Fallback yang informatif ketika data manager tidak tersedia
      return 'Manager (NIP: $managerNip)';
    }
  }

  // Method untuk mendapatkan status yang user-friendly
  // Ini mengubah status technical menjadi label yang mudah dipahami user
  String getDisplayStatus() {
    switch (status) {
      case 'IN_PROGRESS':
        return 'Dalam Pengajuan';
      case 'COMPLETED':
        return 'Disetujui';
      case 'REJECTED':
        return 'Ditolak';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return 'Status Tidak Dikenal';
    }
  }

  // Method untuk mendapatkan warna status yang sesuai dengan requirement
  // Kuning untuk in progress, merah untuk ditolak, hijau untuk diterima
  Color getStatusColor() {
    switch (status) {
      case 'IN_PROGRESS':
        return Colors.orange; // Kuning/orange untuk dalam pengajuan
      case 'COMPLETED':
        return Colors.green; // Hijau untuk disetujui
      case 'REJECTED':
        return Colors.red; // Merah untuk ditolak
      case 'CANCELLED':
        return Colors.grey; // Abu-abu untuk dibatalkan
      default:
        return Colors.grey; // Default abu-abu
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final json = {
      'leave_id': leaveId,
      'title': title,
      'user_nip': userNip,
      'manager_nip': managerNip,
      'start_date': startDate.toUtc().toIso8601String(),
      'end_date': endDate.toUtc().toIso8601String(),
      'attachment_url': attachmentUrl,
      'description': description,
      'status': status,
    };

    // Include manager data dalam JSON jika tersedia
    if (manager != null) {
      json['manager'] = manager!.toJson();
    }

    return json;
  }

  // Override method toEntity untuk kompatibilitas dengan domain layer
  // Ini memungkinkan kita menggunakan enhanced model sambil tetap
  // menjaga kontrak dengan domain layer yang sudah ada
  @override
  LeaveRequestEntity toEntity() {
    return LeaveRequestEntity(
      leaveId: leaveId,
      title: title,
      userNip: userNip,
      managerNip: managerNip,
      startDate: startDate,
      endDate: endDate,
      attachmentUrl: attachmentUrl,
      description: description,
      status: status,
    );
  }
}

// Model dashboard yang juga diperbaiki untuk konsistensi
class LeaveRequestDashboardModel {
  final int leaveQuota;
  final int inProgress;
  final int cancelled;
  final int rejected;
  final int completed;

  LeaveRequestDashboardModel({
    required this.leaveQuota,
    required this.inProgress,
    required this.cancelled,
    required this.rejected,
    required this.completed,
  });

  factory LeaveRequestDashboardModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestDashboardModel(
      leaveQuota: _parseInt(json['leave_quota']),
      inProgress: _parseInt(json['in_progress']),
      cancelled: _parseInt(json['cancelled']),
      rejected: _parseInt(json['rejected']),
      completed: _parseInt(json['completed']),
    );
  }

  // Helper method untuk parsing integer dengan fallback
  // Ini menangani case dimana backend mengirim string atau null
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
