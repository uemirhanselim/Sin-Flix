import 'package:dating_app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BonusItem extends StatelessWidget {
  final Map<String, dynamic> bonus;

  const BonusItem({super.key, required this.bonus});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 55.w, // Ana container'dan 2px büyük
          height: 55.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/premium_icon_bg.png"),
            ),
          ),
          child: Center(
            child: Image.asset(
              bonus['icon'],
              width: 32.w, // İsteğe bağlı boyut
              height: 32.h, // İsteğe bağlı boyut
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          bonus['title'],
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: AppColors.text),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
