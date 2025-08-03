import 'package:dating_app/core/services/logger_service.dart';
import 'package:dating_app/core/themes/app_theme.dart';
import 'package:dating_app/features/auth/domain/usecases/login_user.dart';
import 'package:dating_app/features/auth/domain/usecases/register_user.dart';
import 'package:dating_app/shared/widgets/lottie_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/services/locator.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/social_button.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => AuthBloc(
            loginUser: locator<LoginUser>(),
            registerUser: locator<RegisterUser>(),
            logger: locator<LoggerService>(),
            initialState: const RegisterFormState(),
          ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterFormState) {
            if (state.formStatus == FormStatus.submissionInProgress) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => Center(
                      child: LottieAnimation(
                        "assets/lottie/loading.json",
                        width: 70.w,
                        height: 70.h,
                      ),
                    ),
              );
            } else if (state.formStatus == FormStatus.submissionSuccess ||
                state.formStatus == FormStatus.submissionFailure) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).popUntil((route) => route.isFirst);
            }
          }

          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(tr("registerSuccessfull"))));
            context.go('/login');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(color: AppColors.background),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: const _RegisterForm(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final registerState = state as RegisterFormState;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 100.h),
            Text(
              tr('welcome'),
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
            SizedBox(height: 8.h),
            Text(
              tr('registerSubtitle'),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 40.h),
            _FullNameTextField(fullName: registerState.fullName),
            SizedBox(height: 10.h),
            _EmailTextField(email: registerState.email),
            SizedBox(height: 16.h),
            _PasswordTextField(password: registerState.password),
            SizedBox(height: 10.h),
            _ConfirmPasswordTextField(
              confirmPassword: registerState.confirmPassword,
              password: registerState.password,
            ),
            SizedBox(height: 16.h),
            _TermsAndConditionsText(),
            SizedBox(height: 40.h),
            PrimaryButton(
              text: tr('register'),
              onPressed:
                  registerState.isValid
                      ? () => context.read<AuthBloc>().add(RegisterSubmitted())
                      : () {},
            ),
            SizedBox(height: 30.h),
            const _SocialButtons(),
            SizedBox(height: 30.h),
            _LoginText(),
          ],
        );
      },
    );
  }
}

class _FullNameTextField extends StatelessWidget {
  final String fullName;
  const _FullNameTextField({required this.fullName});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      initialValue: fullName,
      hintText: tr('fullName'),
      prefixIcon: Image.asset("assets/icons/add_user.png"),
      onChanged:
          (value) =>
              context.read<AuthBloc>().add(FullNameChanged(fullName: value)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) {
        if (fullName.isEmpty) {
          return tr("nameSurnameNeeded");
        }
        return null;
      },
    );
  }
}

class _EmailTextField extends StatelessWidget {
  final String email;
  const _EmailTextField({required this.email});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      initialValue: email,
      hintText: tr('email'),
      prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
      keyboardType: TextInputType.emailAddress,
      onChanged:
          (value) => context.read<AuthBloc>().add(EmailChanged(email: value)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) {
        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(email)) {
          return tr("emailError");
        }
        return null;
      },
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  final String password;
  const _PasswordTextField({required this.password});

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      initialValue: widget.password,
      hintText: tr('password'),
      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.grey,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
      onChanged:
          (value) =>
              context.read<AuthBloc>().add(PasswordChanged(password: value)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) {
        if (widget.password.length < 6) {
          return tr("passwordError");
        }
        return null;
      },
    );
  }
}

class _ConfirmPasswordTextField extends StatefulWidget {
  final String password;
  final String confirmPassword;
  const _ConfirmPasswordTextField({
    required this.password,
    required this.confirmPassword,
  });

  @override
  State<_ConfirmPasswordTextField> createState() =>
      _ConfirmPasswordTextFieldState();
}

class _ConfirmPasswordTextFieldState extends State<_ConfirmPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      initialValue: widget.confirmPassword,
      hintText: tr('confirmPassword'),
      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.grey,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      ),
      onChanged:
          (value) => context.read<AuthBloc>().add(
            ConfirmPasswordChanged(confirmPassword: value),
          ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) {
        if (widget.password != widget.confirmPassword) {
          return tr("passwordDoesNotMatch");
        }
        return null;
      },
    );
  }
}

class _TermsAndConditionsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
          children: [
            TextSpan(text: tr('termsAndConditions')),
            TextSpan(
              text: tr('iHaveReadAndAccept'),
              style: textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.underline,
                color: AppColors.text,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      /* TODO: Kullanıcı sözleşmesini göster */
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          assetPath: 'assets/icons/google.png',
          onTap: () {},
        ), // Placeholder
        SizedBox(width: 20.w),
        SocialButton(
          assetPath: 'assets/icons/apple.png',
          onTap: () {},
        ), // Placeholder
        SizedBox(width: 20.w),
        SocialButton(
          assetPath: 'assets/icons/facebook.png',
          onTap: () {},
        ), // Placeholder
      ],
    );
  }
}

class _LoginText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
        children: [
          TextSpan(text: "${tr('alreadyHaveAccount')}  "),
          TextSpan(
            text: "${tr('login')}!",
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.bold,
            ),
            recognizer:
                TapGestureRecognizer()..onTap = () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
