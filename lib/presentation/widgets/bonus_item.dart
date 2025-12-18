import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';

class BonusItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const BonusItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56.w,
          height: 56.h,
          padding: EdgeInsets.all(11.w),
          decoration: BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.circular(900.r),
          ),
          child: Icon(icon, size: 32.w, color: AppColors.white),
        ),
        12.verticalSpace,
        SizedBox(
          width: 80.w,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmallRegular.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
