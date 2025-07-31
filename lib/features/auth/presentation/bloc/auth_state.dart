import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum FormStatus { initial, invalid, valid, submissionInProgress, submissionSuccess, submissionFailure }

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class LoginFormState extends AuthState {
  final String email;
  final String password;
  final FormStatus formStatus;
  final bool isValid;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.formStatus = FormStatus.initial,
    this.isValid = false,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    FormStatus? formStatus,
    bool? isValid,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [email, password, formStatus, isValid];
}

class RegisterFormState extends AuthState {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final FormStatus formStatus;
  final bool isValid;

  const RegisterFormState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formStatus = FormStatus.initial,
    this.isValid = false,
  });

  RegisterFormState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    FormStatus? formStatus,
    bool? isValid,
  }) {
    return RegisterFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formStatus: formStatus ?? this.formStatus,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [fullName, email, password, confirmPassword, formStatus, isValid];
} 