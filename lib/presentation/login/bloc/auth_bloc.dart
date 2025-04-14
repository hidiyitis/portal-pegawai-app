import 'package:bloc/bloc.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_event.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<AuthCheckEvent>(_onAuthCheck);
  }

  Future<void> _onAuthCheck(
    AuthCheckEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    var expiredAt = getIt<SharedPreferences>().getString(
      'access_token_expired_at',
    );
    await Future.delayed(Duration(seconds: 3));
    if (expiredAt != null &&
        DateTime.now().isBefore(DateTime.parse(expiredAt))) {
      emit(AuthAuthenticated());
      return;
    }
    getIt<AuthRepository>().clearAuthData();
    emit(AuthUnauthenticated('Token Expired!!!'));
    return;
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final auth = await authRepository.login(event.nip, event.password);
      await authRepository.cacheAuthData(auth);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthUnauthenticated(e.toString()));
    }
  }
}
