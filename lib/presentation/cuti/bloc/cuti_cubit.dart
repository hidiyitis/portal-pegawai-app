import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/domain/entities/cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/kuota_cuti_entity.dart';
import 'package:portal_pegawai_app/domain/entities/leave_request_entity.dart';
import 'package:portal_pegawai_app/domain/repositories/cuti_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/user_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/leave_request_repository.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:portal_pegawai_app/presentation/cuti/bloc/cuti_state.dart';

// CutiCubit yang diperbaiki dengan capability untuk resolve manager data
// Seperti seorang detektif yang mengumpulkan informasi dari berbagai sumber,
// Cubit ini akan mengombinasikan data leave request dengan data users
// untuk memberikan informasi yang lengkap kepada UI
class CutiCubit extends Cubit<CutiState> {
  final CutiRepository cutiRepository;
  final UserRepository userRepository = getIt<UserRepository>();
  final LeaveRequestRepository leaveRequestRepository =
      getIt<LeaveRequestRepository>();

  // Cache untuk menyimpan data yang sudah di-load
  // Cache ini seperti perpustakaan pribadi yang menyimpan buku-buku yang sering dibaca
  // sehingga kita tidak perlu pergi ke perpustakaan besar setiap kali butuh informasi
  KuotaCutiEntity? _kuotaCuti;
  List<CutiEntity>? _daftarCuti;
  Map<int, UserModel> _userCache =
      {}; // Cache untuk menyimpan data users berdasarkan NIP
  String _currentFilter = 'semua';

  CutiCubit({required this.cutiRepository}) : super(CutiInitial());

  // Method untuk mendapatkan kuota cuti dengan error handling yang robust
  Future<void> getKuotaCuti() async {
    try {
      final dashboardData =
          await leaveRequestRepository.getLeaveRequestDashboard();

      _kuotaCuti = KuotaCutiEntity(
        total: dashboardData['leave_quota'],
        dalamPengajuan: dashboardData['in_progress'],
        ditolak: dashboardData['rejected'],
        disetujui: dashboardData['completed'],
      );

      if (_daftarCuti != null) {
        emit(
          CutiDataLoaded(
            kuotaCuti: _kuotaCuti!,
            daftarCuti: _daftarCuti!,
            filter: _currentFilter,
          ),
        );
      } else {
        emit(CutiLoading());
      }
    } catch (e) {
      emit(FormCutiError('Gagal memuat kuota cuti: ${e.toString()}'));
    }
  }

  // Method yang diperbaiki untuk mendapatkan daftar cuti dengan resolusi manager yang proper
  // Seperti seorang jurnalis yang tidak hanya melaporkan fakta mentah,
  // tetapi juga mencari konteks dan detail untuk memberikan cerita yang lengkap
  Future<void> getDaftarCuti({required String filter}) async {
    if (state is! CutiDataLoaded) {
      emit(CutiLoading());
    }

    try {
      _currentFilter = filter;

      // Langkah 1: Ambil data leave requests dari backend
      String? statusFilter =
          filter == 'semua' ? null : _mapFilterToBackendStatus(filter);
      final leaveRequests = await leaveRequestRepository.getLeaveRequests(
        statusFilter,
      );

      // Langkah 2: Collect semua manager NIPs yang unik
      // Ini seperti membuat daftar tamu undangan sebelum menyiapkan tempat duduk
      Set<int> managerNips =
          leaveRequests
              .map((request) => request.managerNip)
              .where(
                (nip) => !_userCache.containsKey(nip),
              ) // Hanya ambil yang belum di-cache
              .toSet();

      // Langkah 3: Fetch data users untuk managers yang belum ada di cache
      // Ini adalah optimasi penting untuk menghindari multiple API calls yang sama
      if (managerNips.isNotEmpty) {
        await _loadUsersToCache(managerNips);
      }

      // Langkah 4: Konversi LeaveRequestEntity ke CutiEntity dengan data manager yang lengkap
      // Ini adalah proses "enrichment" dimana kita menambahkan informasi kontekstual
      final daftarCuti =
          leaveRequests.map((leaveRequest) {
            return _convertLeaveRequestToCutiEntity(leaveRequest);
          }).toList();

      _daftarCuti = daftarCuti;

      if (_kuotaCuti != null) {
        emit(
          CutiDataLoaded(
            kuotaCuti: _kuotaCuti!,
            daftarCuti: daftarCuti,
            filter: filter,
          ),
        );
      }
    } catch (e) {
      emit(FormCutiError('Gagal memuat daftar cuti: ${e.toString()}'));
    }
  }

  // Method untuk load data users ke cache dengan batch processing
  // Seperti seorang chef yang menyiapkan semua ingredients sekaligus
  // sebelum mulai memasak, kita load semua data users yang diperlukan dalam satu operasi
  Future<void> _loadUsersToCache(Set<int> nips) async {
    try {
      // Dalam implementasi ideal, backend akan mendukung query users berdasarkan list of NIPs
      // Untuk saat ini, kita load semua users dan filter di client side
      // Ini adalah trade-off antara network calls vs memory usage
      final allUsers = await userRepository.getUsers();

      // Populate cache dengan users yang kita butuhkan
      for (final user in allUsers) {
        if (nips.contains(user.nip)) {
          _userCache[user.nip] = user;
        }
      }
    } catch (e) {
      // Jika gagal load user data, aplikasi tetap berfungsi dengan fallback names
      print('Warning: Failed to load user data for managers: $e');
    }
  }

  // Method untuk mapping filter UI ke status backend
  // Ini adalah "translation layer" yang mengubah istilah user-friendly
  // menjadi istilah technical yang dipahami backend
  String _mapFilterToBackendStatus(String uiFilter) {
    switch (uiFilter.toLowerCase()) {
      case 'dalam_pengajuan':
      case 'pending':
        return 'IN_PROGRESS';
      case 'disetujui':
      case 'diterima':
        return 'COMPLETED';
      case 'ditolak':
        return 'REJECTED';
      case 'dibatalkan':
        return 'CANCELLED';
      default:
        return 'IN_PROGRESS'; // Default fallback
    }
  }

  // Method untuk mapping status backend ke status display
  // Ini mengubah istilah technical menjadi istilah yang user-friendly
  String _mapBackendStatusToDisplayStatus(String backendStatus) {
    switch (backendStatus.toUpperCase()) {
      case 'IN_PROGRESS':
      case 'PENDING':
        return 'dalam_pengajuan';
      case 'COMPLETED':
      case 'APPROVED':
        return 'disetujui';
      case 'REJECTED':
        return 'ditolak';
      case 'CANCELLED':
        return 'dibatalkan';
      default:
        return 'dalam_pengajuan'; // Default fallback
    }
  }

  // Method loadAllData yang diperbaiki dengan manager resolution
  Future<void> loadAllData({String filter = 'semua'}) async {
    emit(CutiLoading());
    try {
      // Jalankan operasi secara parallel untuk efficiency
      final kuotaFuture = leaveRequestRepository.getLeaveRequestDashboard();
      String? statusFilter =
          filter == 'semua' ? null : _mapFilterToBackendStatus(filter);
      final daftarCutiFuture = leaveRequestRepository.getLeaveRequests(
        statusFilter,
      );

      final results = await Future.wait([kuotaFuture, daftarCutiFuture]);

      final dashboardData = results[0] as Map<String, dynamic>;
      final leaveRequests = results[1] as List<LeaveRequestEntity>;

      // Update kuota cache
      _kuotaCuti = KuotaCutiEntity(
        total: dashboardData['leave_quota'],
        dalamPengajuan: dashboardData['in_progress'],
        ditolak: dashboardData['rejected'],
        disetujui: dashboardData['completed'],
      );

      // Load manager data untuk semua leave requests
      Set<int> managerNips =
          leaveRequests
              .map((request) => request.managerNip)
              .where((nip) => !_userCache.containsKey(nip))
              .toSet();

      if (managerNips.isNotEmpty) {
        await _loadUsersToCache(managerNips);
      }

      // Konversi dengan manager names yang proper
      final daftarCuti =
          leaveRequests.map((leaveRequest) {
            return _convertLeaveRequestToCutiEntity(leaveRequest);
          }).toList();

      _daftarCuti = daftarCuti;
      _currentFilter = filter;

      emit(
        CutiDataLoaded(
          kuotaCuti: _kuotaCuti!,
          daftarCuti: daftarCuti,
          filter: filter,
        ),
      );
    } catch (e) {
      emit(FormCutiError('Gagal memuat data: ${e.toString()}'));
    }
  }

  // Method untuk mendapatkan daftar manager (users) tetap sama
  Future<void> getDaftarManager() async {
    emit(CutiLoading());
    try {
      final daftarUsers = await userRepository.getUsers();

      // Sekaligus populate user cache untuk optimasi future operations
      for (final user in daftarUsers) {
        _userCache[user.nip] = user;
      }

      print('Daftar Users (sebagai Manager): ${daftarUsers.length}');
      emit(DaftarManagerLoaded(daftarUsers));
    } catch (e) {
      emit(FormCutiError('Gagal memuat daftar manager: ${e.toString()}'));
    }
  }

  // Method ajukanCuti tetap sama karena sudah berfungsi dengan baik
  Future<void> ajukanCuti({
    required String kegiatan,
    required String tanggalMulai,
    required String tanggalSelesai,
    required int managerId,
    String? lampiran,
    String? catatan,
    XFile? attachmentFile,
  }) async {
    emit(CutiLoading());
    try {
      final leaveRequest = CreateLeaveRequestEntity(
        title: kegiatan,
        startDate: tanggalMulai,
        endDate: tanggalSelesai,
        managerNip: managerId,
        description: catatan,
      );

      final result = await leaveRequestRepository.createLeaveRequest(
        leaveRequest,
        attachmentFile,
      );

      // Ambil nama manager untuk entity yang baru dibuat
      final managerData = _userCache[result.managerNip];
      final managerName =
          managerData?.name ?? 'Manager (NIP: ${result.managerNip})';

      final cutiEntity = _convertLeaveRequestToCutiEntity(result);

      emit(CutiSubmitSuccess(cutiEntity));
    } catch (e) {
      emit(FormCutiError('Gagal mengajukan cuti: ${e.toString()}'));
    }
  }

  // Helper method untuk format tanggal yang konsisten
  String _formatDateForDisplay(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Method untuk clear cache jika diperlukan (misalnya saat logout)
  void clearCache() {
    _userCache.clear();
    _kuotaCuti = null;
    _daftarCuti = null;
  }

  ///////////////////////////////
  ///// Method yang diperbaiki untuk konversi LeaveRequestEntity ke CutiEntity
  CutiEntity _convertLeaveRequestToCutiEntity(LeaveRequestEntity leaveRequest) {
    // Ambil data manager dari cache
    final managerData = _userCache[leaveRequest.managerNip];
    final managerName =
        managerData?.name ?? 'Manager (NIP: ${leaveRequest.managerNip})';

    return CutiEntity(
      id: leaveRequest.leaveId ?? 0,
      kegiatan: leaveRequest.title,
      tanggalMulai: _formatDateForDisplay(leaveRequest.startDate),
      tanggalSelesai: _formatDateForDisplay(leaveRequest.endDate),
      managerId: leaveRequest.managerNip,
      managerNama: managerName,
      status: _mapBackendStatusToDisplayStatus(leaveRequest.status),
      tanggalPengajuan: DateTime.now().toString(),

      // PERBAIKAN: Mapping field yang benar dari LeaveRequestEntity
      // Catatan: field 'lampiran' tetap untuk backward compatibility
      lampiran: leaveRequest.attachmentUrl,
      catatan: leaveRequest.description, // Field lama untuk compatibility
      // Field baru yang akan digunakan di UI
      attachmentFileName: _extractFileNameFromUrl(leaveRequest.attachmentUrl),
      description: leaveRequest.description, // Deskripsi yang sebenarnya
    );
  }

  // Helper method untuk mengekstrak nama file dari URL
  String? _extractFileNameFromUrl(String? attachmentUrl) {
    if (attachmentUrl == null || attachmentUrl.isEmpty) return null;

    try {
      // Extract filename dari URL seperti:
      // "https://storage.googleapis.com/bucket/filename_timestamp.pdf" -> "filename_timestamp.pdf"
      final uri = Uri.parse(attachmentUrl);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        return pathSegments.last;
      }
    } catch (e) {
      print('Error extracting filename from URL: $e');
    }

    return null;
  }
}
