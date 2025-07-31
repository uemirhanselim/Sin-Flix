import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;

  const SocialButton({super.key, required this.assetPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFF2a2a2a),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.w),
        ),
        child: Image.asset(assetPath, height: 30.h, width: 30.w, errorBuilder: (c, o, s) => const Icon(Icons.error, color: Colors.white)),
      ),
    );
  }
}
