import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portal_pegawai_app/core/configs/theme/app_colors.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_bloc.dart';
import 'package:portal_pegawai_app/presentation/profile/bloc/profile_event.dart';

class ProfilePictureWidget extends StatelessWidget {
  final File? imageFile;
  final bool isLoading;

  const ProfilePictureWidget({
    super.key,
    this.imageFile,
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
              imageFile != null
                  ? FileImage(imageFile!)
                  : const AssetImage('assets/images/profile.jpg'),
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
          (context) => AlertDialog(
            title: const Text('Pilih Sumber Foto'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                    UpdateProfilePicture(source: ImageSource.camera),
                  );
                },
                child: const Text('Kamera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ProfileBloc>().add(
                    UpdateProfilePicture(source: ImageSource.gallery),
                  );
                },
                child: const Text('Galeri'),
              ),
            ],
          ),
    );
  }
}
