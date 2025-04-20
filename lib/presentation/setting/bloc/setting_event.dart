import 'package:equatable/equatable.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class LoadUserData extends SettingEvent {}

class LogoutUser extends SettingEvent {}
