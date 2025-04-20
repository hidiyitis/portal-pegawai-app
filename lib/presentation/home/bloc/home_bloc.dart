import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_event.dart';
import 'package:portal_pegawai_app/presentation/home/bloc/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ImagePicker _picker = ImagePicker();
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<ClockInRequested>(_onClockInRequested);
    on<ClockOutRequested>(_onClockOutRequested);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final prefs = getIt<SharedPreferences>();
      final user =
          prefs.containsKey('user')
              ? jsonDecode(prefs.getString('user')!)
              : null;

      // Data dummy sesuai UI
      final currentDate = DateFormat('EEEE, d MMMM y').format(DateTime.now());
      emit(
        HomeDataLoaded(
          greeting: _getGreeting(),
          user: user,
          currentDate: currentDate,
          notificationCount: 8,
          agendas: [
            {
              'time': DateTime.now().subtract(Duration(minutes: 10)),
              'title': 'Sprint Planning – Ruang Meeting 10',
            },
            {
              'time': DateTime.now().add(Duration(hours: 1)),
              'title': 'Sprint Planning – Ruang Meeting 10',
            },
          ],
          leaveQuota: 10,
          isClockedIn: false,
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

  Future<void> _onClockInRequested(
    ClockInRequested event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // 1. Simpan data ke API (contoh simulasi)
      await Future.delayed(const Duration(seconds: 1));

      // 2. Update state
      emit(
        (state as HomeDataLoaded).copyWith(
          isClockedIn: true,
          lastClockInPhoto: event.photoPath,
          lastClockInPosition: event.position,
        ),
      );
    } catch (e) {
      emit(ClockInError('Gagal Clock In: ${e.toString()}'));
    }
  }

  Future<void> _onClockOutRequested(
    ClockOutRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeDataLoaded) {
      emit((state as HomeDataLoaded).copyWith(isClockedIn: false));
    }
  }

  // Helper method untuk dipanggil dari UI
  Future<void> processClockIn(BuildContext context) async {
    try {
      // 1. Ambil foto dari kamera
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return;

      // 2. Ambil lokasi
      final position = await _determinePosition();

      // 3. Trigger event
      add(ClockInRequested(photo.path, position));
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
