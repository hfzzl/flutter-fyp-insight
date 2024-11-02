import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String email;
  final String password;

  const LoggedIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class Registered extends AuthEvent {
  final String email;
  final String password;
  final String role;

  const Registered(
      {required this.email, required this.password, required this.role});

  @override
  List<Object> get props => [email, password, role];
}

class LoggedOut extends AuthEvent {}
