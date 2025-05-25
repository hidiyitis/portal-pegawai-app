import 'package:bloc/bloc.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/presentation/setting/bloc/setting_event.dart';
import 'package:portal_pegawai_app/presentation/setting/bloc/setting_state.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final AuthRepository _authRepository;
  SettingBloc(this._authRepository) : super(SettingInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<LogoutUser>(_onLogoutUser);
  }

  void _onLoadUserData(LoadUserData event, Emitter<SettingState> emit) async {
    final user = await _authRepository.getAuthUserData();
    emit(UserDataLoaded(user));
  }

  void _onLogoutUser(LogoutUser event, Emitter<SettingState> emit) async {
    try {
      final authRepo = getIt<AuthRepository>();
      authRepo.clearAuthData();
      emit(LogoutSuccess());
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }
}
