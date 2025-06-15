import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/data/models/user_model.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/domain/repositories/user_repository.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_event.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  ProfileBloc({required this.authRepository, required this.userRepository})
    : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
    on<ChangePassword>(_onChangePassword);
  }
  @override
  void onChange(Change<ProfileState> change) {
    super.onChange(change);
  }

  @override
  void onEvent(ProfileEvent event) {
    super.onEvent(event);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      var user = await authRepository.getAuthUserData();
      if (user != null) {
        emit(
          ProfileLoaded(
            name: user.name,
            nip: user.nip,
            imageUrl: user.photoUrl,
          ),
        );
      } else {
        emit(
          ProfileLoaded(
            name: 'Arshita Hira',
            nip: 1303223017,
            imageUrl: 'https://picsum.photos/200',
          ),
        );
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfilePicture(
    UpdateProfilePicture event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;

    final currentState = state as ProfileLoaded;

    try {
      final image = await ImagePicker().pickImage(
        source: event.source,
        imageQuality: 85,
        maxWidth: 800,
      );

      if (image != null) {
        UserModel updated = await userRepository.uploadAvatar(image);
        await authRepository.updateAuthData(updated);
        emit(
          ProfileLoaded(
            name: currentState.name,
            nip: currentState.nip,
            imageUrl: updated.photoUrl,
          ),
        );
      } else {
        emit(currentState);
      }
    } catch (e) {
      emit(ProfileError('Gagal mengupdate foto: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;
    emit(ProfileUpdating(state as ProfileLoaded));

    try {
      if (event.newPassword.length < 8) {
        throw Exception('Password minimal 8 karakter');
      }

      final data = await userRepository.updatePassword(
        event.currentPassword,
        event.newPassword,
        event.confirmPassword,
      );
      emit(ProfileError('Success Update password'));
      emit(
        ProfileLoaded(name: data.name, nip: data.nip, imageUrl: data.photoUrl),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      emit(
        ProfileLoaded(
          name: currentState.name,
          nip: currentState.nip,
          imageUrl: currentState.imageUrl,
        ),
      );
    }
  }
}
