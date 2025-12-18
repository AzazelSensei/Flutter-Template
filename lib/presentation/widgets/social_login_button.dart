import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconAsset;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.iconAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.white5,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            width: 1.w,
            color: AppColors.white20,
          ),
        ),
        child: Center(
          child: SvgIcon(
            assetPath: iconAsset,
            size: 24.w,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
