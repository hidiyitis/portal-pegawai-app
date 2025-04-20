import 'package:equatable/equatable.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

class SettingInitial extends SettingState {}

class UserDataLoaded extends SettingState {
  final dynamic userData;

  const UserDataLoaded(this.userData);

  @override
  List<Object> get props => [userData ?? ''];
}

class LogoutSuccess extends SettingState {}

class SettingError extends SettingState {
  final String message;

  const SettingError(this.message);

  @override
  List<Object> get props => [message];
}
