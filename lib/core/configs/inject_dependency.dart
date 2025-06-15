import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/data/datasources/agenda_remote_data_source.dart';
import 'package:portal_pegawai_app/data/datasources/attendance_remote_data_source.dart';
import 'package:portal_pegawai_app/data/datasources/user_remote_data_source.dart';
import 'package:portal_pegawai_app/data/datasources/leave_request_remote_data_source.dart';
import 'package:portal_pegawai_app/data/local/attendance_local_data_source.dart';
import 'package:portal_pegawai_app/data/local/auth_local_data_source.dart';
import 'package:portal_pegawai_app/data/repositories/agenda_repository_impl.dart';
import 'package:portal_pegawai_app/data/repositories/attendance_repository_impl.dart';
import 'package:portal_pegawai_app/data/repositories/cuti_repository_impl.dart';
import 'package:portal_pegawai_app/data/repositories/user_repository_impl.dart';
import 'package:portal_pegawai_app/data/repositories/leave_request_repository_impl.dart';
import 'package:portal_pegawai_app/domain/repositories/agenda_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/attendance_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/cuti_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/user_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/leave_request_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:portal_pegawai_app/data/datasources/auth_remote_data_source.dart';
import 'package:portal_pegawai_app/data/repositories/auth_repository_impl.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Inisialisasi format tanggal untuk lokalisasi Indonesia
  // Ini penting untuk menampilkan tanggal dalam format yang sesuai dengan budaya Indonesia
  initializeDateFormatting('id_ID', null);

  // Registrasi Dio sebagai HTTP client
  // BaseURL disesuaikan dengan alamat backend server
  getIt.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.6:3000/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );

  // External dependencies - SharedPreferences untuk storage lokal
  try {
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(() => sharedPrefs);
  } catch (e) {
    throw Exception('Failed to initialize SharedPreferences: $e');
  }

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel desc',
      defaultColor: AppColors.primary,
      ledColor: Colors.white,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      onlyAlertOnce: true,
      playSound: true,
      criticalAlerts: true,
    ),
  ], debug: false);

  await AwesomeNotifications().requestPermissionToSendNotifications();

  // === REMOTE DATA SOURCES ===
  // Registrasi semua remote data source yang menangani komunikasi dengan backend

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<AgendaRemoteDataSource>(
    () => AgendaRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<AttendanceRemoteDateSource>(
    () => AttendanceRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // Registrasi baru untuk leave request remote data source
  // Ini akan menangani semua komunikasi HTTP untuk fitur pengajuan cuti
  getIt.registerLazySingleton<LeaveRequestRemoteDataSource>(
    () => LeaveRequestRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // === LOCAL DATA SOURCES ===
  // Registrasi local data source untuk penyimpanan data offline

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(prefs: getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<AttendanceLocalDataSource>(
    () => AttendanceLoaclDataSourceImpl(prefs: getIt<SharedPreferences>()),
  );

  // === REPOSITORIES ===
  // Registrasi semua repository yang mengimplementasikan kontrak domain layer

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: getIt<AuthRemoteDataSource>(),
      local: getIt<AuthLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<AgendaRepository>(
    () => AgendaRepositoryImpl(remote: getIt<AgendaRemoteDataSource>()),
  );

  getIt.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(
      remote: getIt<AttendanceRemoteDateSource>(),
      local: getIt<AttendanceLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remote: getIt<UserRemoteDataSource>()),
  );

  // Registrasi baru untuk leave request repository
  // Repository ini mengintegrasikan remote data source dengan domain layer
  getIt.registerLazySingleton<LeaveRequestRepository>(
    () => LeaveRequestRepositoryImpl(
      remoteDataSource: getIt<LeaveRequestRemoteDataSource>(),
    ),
  );

  // Tetap gunakan implementasi dummy untuk backward compatibility
  // Nantinya CutiRepository yang lama bisa diganti dengan LeaveRequestRepository
  getIt.registerLazySingleton<CutiRepository>(() => CutiRepositoryImpl());
}
