import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends AuthEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends AuthEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends AuthEvent {}

class RegisterSubmitted extends AuthEvent {}

class FullNameChanged extends AuthEvent {
  final String fullName;

  const FullNameChanged({required this.fullName});

  @override
  List<Object> get props => [fullName];
}

class ConfirmPasswordChanged extends AuthEvent {
  final String confirmPassword;

  const ConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];
}