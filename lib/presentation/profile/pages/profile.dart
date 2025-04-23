import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_text_size.dart';
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
        backgroundColor: Colors.transparent,
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
          create: (context) => ProfileBloc()..add(LoadProfile()),
          child: BlocConsumer<ProfileBloc, ProfileState>(
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
                  padding: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      spacing: 16,
                      children: [
                        ProfilePictureWidget(
                          imageFile: profile.profilePicture,
                          isLoading: state is ProfileUpdating,
                        ),
                        _buildProfileInfo(profile),
                        const PasswordForm(),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(ProfileLoaded profile) {
    return Column(
      children: [
        Text(
          'Arshita Hira',
          style: TextStyle(
            fontSize: AppTextSize.headingSmall,
            fontWeight: FontWeight.w500,
            color: AppColors.onPrimary,
          ),
        ),
        Text(
          '1303223017',
          style: TextStyle(
            fontSize: AppTextSize.bodyLarge,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
