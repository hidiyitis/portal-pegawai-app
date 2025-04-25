import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_event.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfilePicture>(_onUpdateProfilePicture);
    on<ChangePassword>(_onChangePassword);
  }
  @override
  void onChange(Change<ProfileState> change) {
    debugPrint('State change: ${change.currentState} -> ${change.nextState}');
    super.onChange(change);
  }

  @override
  void onEvent(ProfileEvent event) {
    debugPrint('Event received: $event in state: $state');
    super.onEvent(event);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      // Simulasi load data dari API
      await Future.delayed(const Duration(seconds: 1));
      emit(
        ProfileLoaded(
          name: 'Arshita Hira',
          email: 'arshita@example.com',
          imageUrl: 'https://picsum.photos/200',
        ),
      );
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
        // Simulasi upload ke server
        await Future.delayed(const Duration(seconds: 1));
        String newImageUrl =
            'https://picsum.photos/200?random=${DateTime.now().millisecondsSinceEpoch}';

        emit(
          ProfileLoaded(
            name: currentState.name,
            email: currentState.email,
            imageUrl: newImageUrl,
          ),
        );
      } else {
        emit(currentState);
      }
    } catch (e) {
      print(e.toString());
      emit(ProfileError('Gagal mengupdate foto: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;

    emit(ProfileUpdating(state as ProfileLoaded));

    try {
      // Simulasi proses ganti password
      await Future.delayed(const Duration(seconds: 2));

      if (event.newPassword.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }

      emit(
        ProfileLoaded(
          name: (state as ProfileLoaded).name,
          email: (state as ProfileLoaded).email,
          imageUrl: (state as ProfileLoaded).imageUrl,
        ),
      );
    } catch (e) {
      emit(ProfileError('Gagal ganti password: ${e.toString()}'));
      emit(state as ProfileLoaded);
    }
  }
}
