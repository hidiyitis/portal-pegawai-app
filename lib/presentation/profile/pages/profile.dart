import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/core/configs/inject_dependency.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
import 'package:portal_pegawai_app/domain/repositories/auth_repository.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_bloc.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_event.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_state.dart';
import 'package:portal_pegawai_app/presentation/profile/widget/password_form_widget.dart';
import 'package:portal_pegawai_app/presentation/profile/widget/profile_picture_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onPrimary,
        title: Text(
          'Profil',
          style: TextStyle(
            fontSize: AppTextSize.headingSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          lazy: false,
          create:
              (context) =>
                  ProfileBloc(authRepository: getIt<AuthRepository>())
                    ..add(LoadProfile()),
          child: _profilePageContent(),
        ),
      ),
    );
  }

  BlocConsumer<ProfileBloc, ProfileState> _profilePageContent() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded || state is ProfileUpdating) {
          final profile =
              state is ProfileUpdating
                  ? state.previousState
                  : state as ProfileLoaded;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              spacing: 16,
              children: [
                ProfilePictureWidget(
                  imageUrl: profile.imageUrl,
                  isLoading: state is ProfileUpdating,
                ),
                _buildProfileInfo(profile),
                const PasswordForm(),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildProfileInfo(ProfileLoaded profile) {
    return Column(
      children: [
        Text(
          profile.name,
          style: TextStyle(
            fontSize: AppTextSize.headingSmall,
            fontWeight: FontWeight.w500,
            color: AppColors.onPrimary,
          ),
        ),
        Text(
          profile.nip.toString(),
          style: TextStyle(
            fontSize: AppTextSize.bodyLarge,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
