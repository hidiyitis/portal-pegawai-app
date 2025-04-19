import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:portal_pegawai_app/data/local/auth_local_data_source.dart';
import 'package:portal_pegawai_app/data/repositories/cuti_repository_impl.dart';
import 'package:portal_pegawai_app/domain/repositories/cuti_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:portal_pegawai_app/data/datasources/auth_remote_data_source.dart';
import 'package:portal_pegawai_app/data/repositories/auth_repository_impl.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Dio
  getIt.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: 'http://192.168.18.201:3000/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );
  // External
  try {
    final sharedPrefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(() => sharedPrefs);
  } catch (e) {
    throw Exception('Failed to initialize SharedPreferences: $e');
  }

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(prefs: getIt<SharedPreferences>()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: getIt<AuthRemoteDataSource>(),
      local: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CutiRepository>(() => CutiRepositoryImpl());
}
