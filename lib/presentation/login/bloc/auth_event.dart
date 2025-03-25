import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String nip;
  final String password;

  LoginRequested({required this.nip, required this.password});

  @override
  List<Object> get props => [nip, password];
}
