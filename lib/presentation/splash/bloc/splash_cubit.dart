import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/presentation/splash/bloc/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  void appStarted() async {
    var expiredAt = getIt<SharedPreferences>().getString(
      'access_token_expired_at',
    );
    await Future.delayed(Duration(seconds: 3));
    if (expiredAt != null &&
        DateTime.now().isBefore(DateTime.parse(expiredAt))) {
      emit(Authenticated());
      return;
    }
    getIt<AuthRepository>().clearAuthData();
    emit(UnAuthenticated());
    return;
  }
}
