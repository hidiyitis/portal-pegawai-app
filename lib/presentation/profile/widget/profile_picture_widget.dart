import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/configs/assets/app_images.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_bloc.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_event.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_state.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? imageUrl;
  final bool isLoading;

  const ProfilePictureWidget({
    super.key,
    this.imageUrl,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              imageUrl != ''
                  ? CachedNetworkImageProvider(imageUrl!)
                  : AssetImage(AppImages.defaultProfile),
          child: isLoading ? const CircularProgressIndicator() : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: FloatingActionButton.small(
            backgroundColor: AppColors.primary,
            onPressed: isLoading ? null : () => _showImageSourceDialog(context),
            child: const Icon(Icons.camera_alt, color: AppColors.onBackground),
          ),
        ),
      ],
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text(
              'Pilih Sumber Foto',
              style: TextStyle(color: AppColors.onPrimary),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  final currentState = context.read<ProfileBloc>().state;
                  if (currentState is ProfileLoaded) {
                    context.read<ProfileBloc>().add(
                      UpdateProfilePicture(source: ImageSource.camera),
                    );
                  }
                },
                child: const Text(
                  'Kamera',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  final profileState = context.read<ProfileBloc>().state;
                  if (profileState is ProfileLoaded) {
                    context.read<ProfileBloc>().add(
                      UpdateProfilePicture(source: ImageSource.gallery),
                    );
                  }
                },
                child: const Text(
                  'Galeri',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
    );
  }
}
