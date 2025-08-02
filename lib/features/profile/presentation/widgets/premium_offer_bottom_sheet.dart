import 'dart:ui';
import 'package:dating_app/core/themes/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'bonus_item.dart';
import 'frosted_glass_painter.dart';
import 'package:dating_app/features/profile/presentation/widgets/package_card.dart';

class PremiumOfferBottomSheet extends StatelessWidget {
  const PremiumOfferBottomSheet({super.key});

  static final List<Map<String, dynamic>> bonuses = [
    {
      'icon': "assets/icons/premium_dia.png",
      'title': 'Premium\nAccount',
      'desc': '',
    },
    {
      'icon': "assets/icons/premium_double_love.png",
      'title': 'More\nMatch',
      'desc': '',
    },
    {'icon': "assets/icons/premium_up.png", 'title': 'Stand\nOut', 'desc': ''},
    {
      'icon': "assets/icons/premium_love.png",
      'title': 'More\nLikes',
      'desc': '',
    },
  ];

  static final List<Map<String, dynamic>> packages = [
    {
      'original': '200',
      'bonus': '330',
      'discount': '+10%',
      'price': '₺99,99',
      'color': AppColors.background,
    },
    {
      'original': '2.000',
      'bonus': '3.375',
      'discount': '+70%',
      'price': '₺799,99',
      'color': AppColors.secondary,
    },
    {
      'original': '1.000',
      'bonus': '1.350',
      'discount': '+35%',
      'price': '₺399,99',
      'color': AppColors.background,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
      child: Container(
        color: AppColors.background, // Dark overlay
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              child: Stack(
                children: [
                  // CustomPainter ile buzlu cam arka plan
                  CustomPaint(
                    painter: FrostedGlassPainter(borderRadius: 20.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        children: [
                          Text(
                            tr("limitedOffer"),
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 6.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.w),
                            child: Text(
                              tr("limitedOfferExplaining"),
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _buildBonusesSection(context),
                          SizedBox(height: 16.h),
                          Text(
                            tr("chooseJetonPackage"),
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.h),
                          _buildPackageSelectionSection(),
                          SizedBox(height: 32.h),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text(
                                  tr("seeAllJetons"),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBonusesSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.w),
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            tr("bonussesYouGet"),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bonuses.map((bonus) => BonusItem(bonus: bonus)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageSelectionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          packages.map((package) => PackageCard(package: package)).toList(),
    );
  }
}
