import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class LoadProfile extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class UpdateProfilePicture extends ProfileEvent {
  final ImageSource source;

  const UpdateProfilePicture({required this.source});

  @override
  List<Object> get props => [source];
}

class ChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePassword({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword, confirmPassword];
}
