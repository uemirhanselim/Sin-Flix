import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/services/locator.dart';
import '../../auth/domain/repositories/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;
      // if (user != null) {
      //   // TODO: Ana sayfaya yönlendir
      //   context.go('/home');
      // } else {
      //   context.go('/login');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        AppAssets.splashPng,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
} 