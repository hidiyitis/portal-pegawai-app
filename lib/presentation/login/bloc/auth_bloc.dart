import 'package:bloc/bloc.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_event.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_state.dart';

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
    // var expiredAt = getIt<SharedPreferences>().getString(
    //   'access_token_expired_at',
    // );
    await Future.delayed(Duration(seconds: 3));
    // if (expiredAt != null &&
    //     DateTime.now().isBefore(DateTime.parse(expiredAt))) {
    //   emit(AuthAuthenticated());
    //   return;
    // }
    // if (expiredAt != null &&
    //     DateTime.now().isAfter(DateTime.parse(expiredAt))) {
    //   emit(AuthUnauthenticated('Token Expired!!!'));
    //   getIt<AuthRepository>().clearAuthData();
    //   return;
    // }
    // emit(AuthUnauthenticated('Login Required'));
    emit(AuthUnauthenticated(''));
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // final auth = await authRepository.login(event.nip, event.password);
      // await authRepository.cacheAuthData(auth);
      // if (event.nip != event.password) {
      //   emit(AuthUnauthenticated('NIP dan Password tidak seseuai'));
      //   return;
      // }
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthUnauthenticated(e.toString()));
    }
  }
}
