import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/domain/entities/attendance_entity.dart';
import 'package:portal_pegawai_app/domain/repositories/agenda_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/attendance_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_event.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ImagePicker _picker = ImagePicker();
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final AgendaRepository _agendaRepository = getIt<AgendaRepository>();
  final AttendanceRepository _attendanceRepository =
      getIt<AttendanceRepository>();

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<ClockInClockOutRequested>(_onClockInClockOutRequested);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final user = await _authRepository.getAuthUserData();
      final agenda = await _agendaRepository.getAllAgendas();

      final isClockedIn = await _attendanceRepository.checkClockedIn();
      final isClockedOut = await _attendanceRepository.checkClockedOut();
      final currentDate = DateFormat(
        'EEEE, d MMMM y',
        'id_ID',
      ).format(DateTime.now());
      emit(
        HomeDataLoaded(
          greeting: _getGreeting(),
          user: user!,
          currentDate: currentDate,
          notificationCount: 8,
          agendas: agenda,
          leaveQuota: user.leaveQuota,
          isClockedIn: isClockedIn,
          isClockedOut: isClockedOut,
          lastClockIn:
              isClockedIn ? await _attendanceRepository.getClockIn() : null,
          lastClockOut:
              isClockedOut ? await _attendanceRepository.getClockOut() : null,
        ),
      );
    } catch (e) {
      emit(HomeError('Gagal memuat data: ${e.toString()}'));
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    return hour < 10
        ? 'Pagi'
        : hour >= 14 && hour < 18
        ? 'Sore'
        : hour >= 18
        ? 'Malam'
        : 'Siang';
  }

  Future<void> _onClockInClockOutRequested(
    ClockInClockOutRequested event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final isClockedIn = await _attendanceRepository.checkClockedIn();
      final attendance = await _attendanceRepository.clockedInAndOut(
        !isClockedIn
            ? AttendenceStatus.CLOCK_IN.name
            : AttendenceStatus.CLOCK_OUT.name,
        event.position,
        event.photo,
      );

      final isClockIn = attendance.status == AttendenceStatus.CLOCK_IN;
      final isClockOut = attendance.status == AttendenceStatus.CLOCK_OUT;
      final time =
          DateFormat('HH:mm', 'id_ID').format(attendance.createdAt).toString();
      await _attendanceRepository.storeClockedInClockOut(
        attendance.status.name,
        time,
      );

      emit(
        (state as HomeDataLoaded).copyWith(
          isClockedIn: isClockIn,
          isClockedOut: isClockOut,
          lastClockIn: isClockIn ? time : (state as HomeDataLoaded).lastClockIn,
          lastClockOut:
              isClockOut ? time : (state as HomeDataLoaded).lastClockOut,
        ),
      );
    } catch (e) {
      emit(ClockInError('Gagal Clock In: ${e.toString()}'));
    }
  }

  Future<void> processClockInClockOut(BuildContext context) async {
    try {
      // 1. Ambil foto dari kamera
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return;

      // 2. Ambil lokasi
      final position = await _determinePosition();

      // 3. Trigger event
      add(ClockInClockOutRequested(photo, position));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi tidak aktif');
    }

    LocationPermission permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi ditolak permanen');
    }

    return await _geolocator.getCurrentPosition();
  }
}
