import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/logger_service.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LoggerService logger;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logger,
    AuthState? initialState,
  }) : super(initialState ?? const LoginFormState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<FullNameChanged>(_onFullNameChanged);
  }

  void _onEmailChanged(EmailChanged event, Emitter<AuthState> emit) {
    if (state is LoginFormState) {
      final s = state as LoginFormState;
      emit(s.copyWith(email: event.email, isValid: _validateLoginForm(event.email, s.password)));
    } else if (state is RegisterFormState) {
      final s = state as RegisterFormState;
      emit(s.copyWith(email: event.email, isValid: _validateRegisterForm(event.email, s.password, s.confirmPassword, s.fullName)));
    }
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<AuthState> emit) {
    if (state is LoginFormState) {
      final s = state as LoginFormState;
      emit(s.copyWith(password: event.password, isValid: _validateLoginForm(s.email, event.password)));
    } else if (state is RegisterFormState) {
      final s = state as RegisterFormState;
      emit(s.copyWith(password: event.password, isValid: _validateRegisterForm(s.email, event.password, s.confirmPassword, s.fullName)));
    }
  }

  void _onConfirmPasswordChanged(ConfirmPasswordChanged event, Emitter<AuthState> emit) {
    final s = state as RegisterFormState;
    emit(s.copyWith(confirmPassword: event.confirmPassword, isValid: _validateRegisterForm(s.email, s.password, event.confirmPassword, s.fullName)));
  }

  void _onFullNameChanged(FullNameChanged event, Emitter<AuthState> emit) {
    final s = state as RegisterFormState;
    emit(s.copyWith(fullName: event.fullName, isValid: _validateRegisterForm(s.email, s.password, s.confirmPassword, event.fullName)));
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<AuthState> emit) async {
    final state = this.state as LoginFormState;
    if (!state.isValid) return;

    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
    final result = await loginUser(LoginUserParams(email: state.email, password: state.password));

    result.fold(
      (failure) {
        emit(state.copyWith(formStatus: FormStatus.submissionFailure));
        emit(AuthError(failure.message));
      },
      (user) {
        emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<AuthState> emit) async {
    final state = this.state as RegisterFormState;
    if (!state.isValid) return;

    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
    logger.i('Register attempt for email: ${state.email}');
    final result = await registerUser(RegisterUserParams(name: state.fullName, email: state.email, password: state.password));

    result.fold(
      (failure) {
        logger.e('Register failed for email: ${state.email}', failure.message);
        emit(state.copyWith(formStatus: FormStatus.submissionFailure));
        emit(AuthError(failure.message));
      },
      (user) {
        logger.i('Register successful for email: ${state.email}');
        emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
        emit(AuthAuthenticated(user));
      },
    );
  }

  bool _validateLoginForm(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty && password.length >= 6 && RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(email);
  }

  bool _validateRegisterForm(String email, String password, String confirmPassword, String fullName) {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        password.length >= 6 &&
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(email) &&
        password == confirmPassword &&
        fullName.isNotEmpty;
  }
}