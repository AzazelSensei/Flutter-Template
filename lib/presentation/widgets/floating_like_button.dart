import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/theme/app_colors.dart';
import 'package:flutter_template/domain/entities/movie.dart';
import 'package:flutter_template/presentation/widgets/svg_icon.dart';

/// Floating like button with blur backdrop
///
/// Film beğeni butonu - blur efekti ve animasyonlu icon değişimi ile.
/// HomePage'de kullanılır.
class FloatingLikeButton extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final double? right;
  final double? bottom;

  const FloatingLikeButton({
    super.key,
    required this.movie,
    required this.onTap,
    this.right,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right ?? 24.w,
      bottom: bottom ?? 191.h,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(82.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 52.w,
              height: 72.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: AppColors.black.withValues(
                  alpha: movie.isFavorite ? 0.20 : 0.05,
                ),
                borderRadius: BorderRadius.circular(82.r),
                border: Border.all(
                  color: AppColors.white.withValues(
                    alpha: movie.isFavorite ? 0.60 : 0.20,
                  ),
                  width: 1,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: SvgIcon(
                  key: ValueKey(movie.isFavorite),
                  assetPath: movie.isFavorite
                      ? AppIcons.heartFill
                      : AppIcons.heart,
                  color: movie.isFavorite
                      ? AppColors.primaryOf(context)
                      : AppColors.white,
                  size: 24.w,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
