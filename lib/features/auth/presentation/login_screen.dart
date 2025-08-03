import 'package:dating_app/core/services/logger_service.dart';
import 'package:dating_app/core/themes/app_theme.dart';
import 'package:dating_app/features/auth/domain/usecases/login_user.dart';
import 'package:dating_app/features/auth/domain/usecases/register_user.dart';
import 'package:dating_app/shared/widgets/lottie_extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/services/locator.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/social_button.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => AuthBloc(
            loginUser: locator<LoginUser>(),
            registerUser: locator<RegisterUser>(),
            logger: locator<LoggerService>(),
          ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginFormState) {
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
            context.go('/home');
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
                    child: const _LoginForm(),
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

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoginFormState) {
          final loginState = state;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 200.h),
              Text(
                tr('hello'),
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium,
              ),
              SizedBox(height: 8.h),
              Text(
                tr('loginSubtitle'),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium!.copyWith(color: AppColors.text),
              ),
              SizedBox(height: 40.h),
              _EmailTextField(email: loginState.email),
              SizedBox(height: 10.h),
              _PasswordTextField(password: loginState.password),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    /* TODO: Şifremi unuttum */
                  },
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  child: Text(
                    tr('forgotPassword'),
                    style: textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.underline,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              PrimaryButton(
                text: tr('login'),
                onPressed:
                    loginState.isValid
                        ? () => context.read<AuthBloc>().add(LoginSubmitted())
                        : () {},
              ),
              SizedBox(height: 40.h),
              const _SocialButtons(),
              SizedBox(height: 40.h),
              _RegisterText(),
            ],
          );
        }
        return const SizedBox.shrink();
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
      prefixIcon: Image.asset('assets/icons/message.png'),
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
      hintText: '  ' + tr('password'),
      prefixIcon: Image.asset('assets/icons/unlock.png'),
      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey[400],
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
        SizedBox(width: 10.w),
        SocialButton(
          assetPath: 'assets/icons/apple.png',
          onTap: () {},
        ), // Placeholder
        SizedBox(width: 10.w),
        SocialButton(
          assetPath: 'assets/icons/facebook.png',
          onTap: () {},
        ), // Placeholder
      ],
    );
  }
}

class _RegisterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
        children: [
          TextSpan(text: '${tr('dontHaveAccount')}   '),
          TextSpan(
            text: "${tr('register')}!",
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
            recognizer:
                TapGestureRecognizer()..onTap = () => context.go('/register'),
          ),
        ],
      ),
    );
  }
}
