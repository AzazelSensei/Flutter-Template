import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/core/theme/app_typography.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool useGradient;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.useGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final lighterPrimary = Color.lerp(primaryColor, Colors.white, 0.2) ?? primaryColor;

    if (useGradient) {
      return Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [lighterPrimary, primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            overlayColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
            elevation: 0,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.sm,
            ),
          ),
          child: _buildChild(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading || onPressed == null ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          splashFactory: NoSplash.splashFactory,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.sm,
            ),
            child: _buildChild(),
          ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    return isLoading
        ? SizedBox(
            height: 20.h,
            width: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.white,
            ),
          )
        : Text(
            text,
            style: AppTypography.bodyLargeSemibold.copyWith(
              color: AppColors.white,
            ),
          );
  }
}
