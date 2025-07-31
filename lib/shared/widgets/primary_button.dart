import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE50914),
        foregroundColor: Colors.white,
        minimumSize: Size.fromHeight(53.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
    );
  }
}
