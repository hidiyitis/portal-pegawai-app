import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final String name;
  final int nip;
  final String? imageUrl;

  const ProfileLoaded({required this.name, required this.nip, this.imageUrl});

  @override
  List<Object?> get props => [name, nip, imageUrl];
}

class ProfileUpdating extends ProfileState {
  final ProfileLoaded previousState;

  const ProfileUpdating(this.previousState);

  @override
  List<Object> get props => [previousState];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
