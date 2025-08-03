import 'package:dating_app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String? initialValue;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    this.initialValue,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    required this.onChanged,
    this.validator,
    this.keyboardType,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      initialValue: initialValue,
      style: textTheme.bodyLarge,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: textTheme.bodySmall,
        filled: true,
        fillColor: const Color(0xFF2a2a2a),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColors.text.withOpacity(0.2),
            width: 1.w,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColors.text.withOpacity(0.2),
            width: 1.w,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: AppColors.text.withOpacity(0.5),
            width: 1.w,
          ),
        ),
        contentPadding: EdgeInsets.all(16.w),
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      autovalidateMode: autovalidateMode,
    );
  }
}
