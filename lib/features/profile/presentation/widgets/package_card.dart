import 'dart:ui';

import 'package:dating_app/core/themes/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inner_shadow_container/inner_shadow_container.dart';

class PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;

  const PackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 195.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 100.w,
            height: 180.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: RadialGradient(
                radius: 1.6,
                stops: const [0.12, 1.9],
                colors: [
                  package['original'] == "2.000"
                      ? AppColors.secondary
                      : AppColors.card,
                  AppColors.primary,
                ],
                center: const Alignment(-0.65, -0.6),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Buzlu cam overlay for cards
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      package['original'],
                      style: textTheme.titleLarge?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.text,
                      ),
                    ),
                    Text(package['bonus'], style: textTheme.displayMedium),
                    Text('Jeton', style: textTheme.titleLarge),
                    SizedBox(height: 10.h),
                    const Divider(
                      endIndent: 6,
                      indent: 6,
                      thickness: 0.5,
                      color: Colors.white24,
                    ),
                    Text(
                      package['price'],
                      style: textTheme.titleLarge?.copyWith(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      tr("weekly"),
                      style: textTheme.bodySmall!.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Center(
              child: InnerShadowContainer(
                height: 25.h,
                width: 61.w,
                backgroundColor:
                    package['original'] == "2.000"
                        ? AppColors.secondary
                        : AppColors.card,
                borderRadius: 20,
                blur: 5,
                offset: const Offset(2, 2),
                shadowColor: AppColors.textFaded,
                isShadowTopLeft: true,
                isShadowBottomRight: true,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Center(
                    child: Text(
                      package['discount'],
                      style: textTheme.bodySmall!.copyWith(
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
