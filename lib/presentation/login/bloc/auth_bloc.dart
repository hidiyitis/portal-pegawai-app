import 'package:bloc/bloc.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_event.dart';
import 'package:portal_pegawai_app/presentation/login/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final auth = await authRepository.login(event.nip, event.password);
      await authRepository.cacheAuthData(auth);
      emit(AuthSuccess(auth));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
